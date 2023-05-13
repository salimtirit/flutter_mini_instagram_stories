import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mini_insta_stories/data.dart';
import 'package:mini_insta_stories/story.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // device orientation to portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: StoryScreen(
          stories: stories,
        ));
  }
}

class StoryScreen extends StatefulWidget {
  final List<Story> stories;

  const StoryScreen({super.key, required this.stories});

  @override
  _StoryScreenState createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen>
    with SingleTickerProviderStateMixin {
  PageController? _pageController;
  VideoPlayerController? _videoPlayerController;
  AnimationController? _animationController;

  int _currentIndex = 0;

  //init state
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController();

    final Story firstStory = widget.stories.first;
    _loadStory(story: firstStory, animateToPage: false);

    _animationController = AnimationController(vsync: this);

    _animationController!.addStatusListener((status) {
      //TODO check this
      if (status == AnimationStatus.completed) {
        _animationController!.stop();
        _animationController!.reset();
        setState(() {
          if (_currentIndex + 1 < widget.stories.length) {
            _currentIndex += 1;
            _loadStory(story: widget.stories[_currentIndex]);
          } else {
            _currentIndex = 0;
            _loadStory(story: widget.stories[_currentIndex]);
            // or call Navigator.pop(context);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Story story = widget.stories[_currentIndex];
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: (details) => _onTapDown(details, story),
        child: PageView.builder(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.stories.length,
          itemBuilder: (context, i) {
            final Story story = widget.stories[i];
            if (!story.isVideo) {
              return CachedNetworkImage(
                imageUrl: story.url,
                fit: BoxFit.cover,
              );
            } else {
              if (_videoPlayerController != null &&
                  _videoPlayerController!.value.isInitialized) {
                return FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _videoPlayerController!.value.size.width,
                    height: _videoPlayerController!.value.size.height,
                    child: VideoPlayer(_videoPlayerController!),
                  ),
                );
              }
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  _onTapDown(TapDownDetails details, Story story) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double dx = details.globalPosition.dx;
    if (dx < screenWidth / 3) {
      setState(() {
        if (_currentIndex - 1 >= 0) {
          _currentIndex = _currentIndex - 1;
          _loadStory(story: widget.stories[_currentIndex]);
        }
        _videoPlayerController?.dispose();
      });
    } else if (dx > 2 * screenWidth / 3) {
      setState(() {
        if (_currentIndex + 1 < widget.stories.length) {
          _currentIndex = _currentIndex + 1;
          _loadStory(story: widget.stories[_currentIndex]);
        } else {
          _currentIndex = 0;
          // add Navigator.pop(context);
          _loadStory(story: widget.stories[_currentIndex]);
        }
      });
    } else {
      if (story.isVideo) {
        if (_videoPlayerController != null &&
            _videoPlayerController!.value.isPlaying) {
          _videoPlayerController?.pause();
          _animationController?.stop();
        } else {
          _videoPlayerController?.play();
          _animationController?.forward();
        }
      }
    }
  }

  void _loadStory({required Story story, bool animateToPage = true}) {
    _animationController?.stop();
    _animationController?.reset();
    if (story.isVideo) {
      _videoPlayerController = null;
      _videoPlayerController?.dispose();
      _videoPlayerController = VideoPlayerController.network(story.url)
        ..initialize().then((value) {
          setState(() {});
          if (_videoPlayerController!.value.isInitialized) {
            _animationController?.duration =
                _videoPlayerController!.value.duration;
            _videoPlayerController?.play();
            _animationController?.forward();
          }
        });
    } else {
      _animationController?.duration = story.duration;
      _animationController?.forward();
    }

    if (animateToPage) {
      _pageController?.animateToPage(_currentIndex,
          duration: const Duration(milliseconds: 1), curve: Curves.easeInOut);
    }

    _animationController?.duration = story.duration;
    _animationController?.forward();
    _videoPlayerController = VideoPlayerController.network(story.url)
      ..initialize().then((value) {
        setState(() {});
      });
    _videoPlayerController?.play();
  }
}
