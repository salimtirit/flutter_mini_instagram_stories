import 'package:flutter/material.dart';
import 'package:mini_insta_stories/story.dart';
import 'package:mini_insta_stories/user_info.dart';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mini_insta_stories/animated_bar.dart';
import 'package:mini_insta_stories/user.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';

class StoryScreen extends StatefulWidget {
  final User user;
  final List<Story> stories;
  final CarouselSliderController? controller;
  final int lastIndex;
  final Function updateLastIndex;

  const StoryScreen({
    required this.stories,
    required this.user,
    required this.controller,
    required this.lastIndex,
    required this.updateLastIndex,
  });

  @override
  _StoryScreenState createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen>
    with SingleTickerProviderStateMixin {
  PageController? _pageController;
  AnimationController? _animController;
  VideoPlayerController? _videoController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animController = AnimationController(vsync: this);
    _currentIndex = widget.lastIndex;

    // TODO: add null check here.
    final Story firstStory = widget.stories[_currentIndex];
    _loadStory(story: firstStory, animateToPage: false);

    _animController?.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animController?.stop();
        _animController?.reset();
        setState(() {
          if (_currentIndex + 1 < widget.stories.length) {
            _currentIndex += 1;
            // TODO: null check
            widget.updateLastIndex(widget.user, _currentIndex);
            _loadStory(story: widget.stories[_currentIndex]);
          } else {
            widget.controller?.nextPage();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController?.dispose();
    _animController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Story story = widget.stories[_currentIndex];
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: (details) => _onTapDown(details, story),
        onLongPressStart: (details) => _onLongPress(details, story),
        onLongPressEnd: (details) => _onLongPressEnd(details, story),
        child: Stack(
          children: <Widget>[
            PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.stories.length,
              itemBuilder: (context, i) {
                final Story story = widget.stories[i];
                if (story.isVideo) {
                  if (_videoController != null &&
                      _videoController!.value.isInitialized) {
                    return FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _videoController!.value.size.width,
                        height: _videoController!.value.size.height,
                        child: VideoPlayer(_videoController!),
                      ),
                    );
                  }
                } else {
                  return CachedNetworkImage(
                    imageUrl: story.url,
                    fit: BoxFit.cover,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            Positioned(
              top: 40.0,
              left: 10.0,
              right: 10.0,
              child: Column(
                children: <Widget>[
                  Row(
                    children: widget.stories
                        .asMap()
                        .map((i, e) {
                          return MapEntry(
                            i,
                            AnimatedBar(
                              animController: _animController!,
                              position: i,
                              currentIndex: _currentIndex,
                              key: UniqueKey(),
                            ),
                          );
                        })
                        .values
                        .toList(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 1.5,
                      vertical: 10.0,
                    ),
                    child: UserInfo(user: widget.user, key: UniqueKey()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTapDown(TapDownDetails details, Story story) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double dx = details.globalPosition.dx;
    if (dx < screenWidth / 3) {
      setState(() {
        if (_currentIndex - 1 >= 0) {
          _currentIndex -= 1;
          widget.updateLastIndex(widget.user, _currentIndex);
          _loadStory(story: widget.stories[_currentIndex]);
        } else {
          widget.controller?.previousPage();
        }
      });
    } else if (dx > 2 * screenWidth / 3) {
      setState(() {
        if (_currentIndex + 1 < widget.stories.length) {
          _currentIndex += 1;
          widget.updateLastIndex(widget.user, _currentIndex);
          _loadStory(story: widget.stories[_currentIndex]);
        } else {
          widget.controller?.nextPage();
        }
      });
    }
  }

  void _loadStory({required Story story, bool animateToPage = true}) {
    _animController?.stop();
    _animController?.reset();
    if (story.isVideo) {
      _videoController = null;
      _videoController?.dispose();
      _videoController = VideoPlayerController.network(story.url)
        ..initialize().then((_) {
          setState(() {});
          if (_videoController!.value.isInitialized) {
            _animController!.duration = _videoController?.value.duration;
            _videoController?.play();
            _animController?.forward();
          }
        });
    } else {
      _animController?.duration = const Duration(seconds: 5);
      _animController?.forward();
    }

    if (animateToPage) {
      _pageController?.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onLongPress(LongPressStartDetails details, Story story) {
    _videoController?.pause();
    _animController?.stop();
  }

  void _onLongPressEnd(LongPressEndDetails details, Story story) {
    _videoController?.play();
    _animController?.forward();
  }
}
