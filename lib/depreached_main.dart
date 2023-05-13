import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instagram Story Player',
      home: StoryPlayer(),
    );
  }
}

class StoryPlayer extends StatefulWidget {
  @override
  _StoryPlayerState createState() => _StoryPlayerState();
}

class _StoryPlayerState extends State<StoryPlayer> {
  final List<List<String>> storyGroups = [
    ['https://picsum.photos/id/1000/200/300', 'https://picsum.photos/id/1001/200/300', 'https://picsum.photos/id/1002/200/300'],
    ['https://picsum.photos/id/1003/200/300', 'https://picsum.photos/id/1004/200/300', 'https://picsum.photos/id/1005/200/300'],
    ['https://picsum.photos/id/1006/200/300', 'https://picsum.photos/id/1007/200/300', 'https://picsum.photos/id/1008/200/300'],

  ];

  PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  int _currentStoryIndex = 0;
  int _currentGroupIndex = 0;
  bool _isPaused = false;
  bool _storyPaused = false;

  late Duration _currentStoryDuration;

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.toInt();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onStoryPause() {
    setState(() {
      _isPaused = true;
    });
  }

  void _onStoryResume() {
    setState(() {
      _isPaused = false;
    });
  }


  void _onPreviousStory() {
    setState(() {
      if (_currentStoryIndex > 0) {
        _currentStoryIndex--;
      } else {
        if (_currentPage > 0) {
          _currentPage--;
          _currentStoryIndex = storyGroups[_currentPage].length - 1;
          _pageController.animateToPage(
            _currentPage,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOutCubic,
          );
        }
      }
    });
  }

  // void _onNextStory() {
  //   setState(() {
  //     if (_currentStoryIndex < storyGroups[_currentPage].length - 1) {
  //       _currentStoryIndex++;
  //     } else {
  //       if (_currentPage < storyGroups.length - 1) {
  //         _currentPage++;
  //         _currentStoryIndex = 0;
  //         _pageController.animateToPage(
  //           _currentPage,
  //           duration: Duration(milliseconds: 500),
  //           curve: Curves.easeInOutCubic,
  //         );
  //       }
  //     }
  //   });
  // }

  void _onNextGroup() {
    setState(() {
      if (_currentGroupIndex < storyGroups.length - 1) {
        _currentGroupIndex++;
        _currentStoryIndex = 0;
        _pageController.animateToPage(
          _currentGroupIndex,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  void _onNextStory({bool goToNextGroup = true}) {
    if (!_storyPaused) {
      if (_currentStoryIndex == storyGroups[_currentGroupIndex].length - 1) {
        if (goToNextGroup) {
          _onNextGroup();
        } else {
          _timer.cancel(); // ????????
        }
      } else {
        setState(() {
          _currentStoryIndex++;
        });
        _timer.cancel();
        // _currentStoryDuration = story.isVideo ? story.duration : Duration(seconds: 5);
        _timer = Timer(
          _currentStoryDuration,
          () => _onNextStory(goToNextGroup: true),
        );
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onLongPress: () {
            setState(() {
              _storyPaused = true;
            });
            _onStoryResume();
          },

          onLongPressUp: () {
            setState(() {
              _storyPaused = false;
            });
            _onStoryPause();
          },

          onTapDown: (_) => _onStoryPause(),
          onTapUp: (_) => _onStoryResume(),
          onTapCancel: () => _onStoryResume(),
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity! < 0) {
              _onNextStory();
            } else if (details.primaryVelocity! > 0) {
              _onPreviousStory();
            }
          },
          child: PageView.builder(
            controller: _pageController,
            itemCount: storyGroups.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                color: Colors.black,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              storyGroups[index][_currentStoryIndex],
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 8.0,
                                width: MediaQuery.of(context).size.width *
                                    (1 -
                                        (_currentStoryIndex + 1) /
                                            storyGroups[index].length),
                                color: Colors.grey,
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 8.0,
                                width: MediaQuery.of(context).size.width *
                                    (_currentStoryIndex + 1) /
                                    storyGroups[index].length,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Container(
                    //   height: 100.0,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       IconButton(
                    //         onPressed: _onPreviousStory,
                    //         icon: Icon(
                    //           Icons.chevron_left,
                    //           color: Colors.white,
                    //           size: 32.0,
                    //         ),
                    //       ),
                    //       IconButton(
                    //         onPressed: _onNextStory,
                    //         icon: Icon(
                    //           Icons.chevron_right,
                    //           color: Colors.white,
                    //           size: 32.0,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}




