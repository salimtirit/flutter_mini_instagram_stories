import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:mini_insta_stories/data.dart';
import 'package:mini_insta_stories/story_screen.dart';
import 'package:mini_insta_stories/user.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    CarouselSliderController controller = CarouselSliderController();

    Map<User, int> lastIndexes = {};
    List<Widget> children = [];

    int currentIndex = 0;

    for (var u in users) {
      lastIndexes[u] = 0;
    }

    void updateLastIndex(User user, int index) {
      lastIndexes[user] = index;
    }

    void onSlideChanged(int index) {
      User u = users[currentIndex];
      children[currentIndex] = StoryScreen(
        stories: stories[u]!,
        user: u,
        controller: controller,
        lastIndex: lastIndexes[u]!,
        updateLastIndex: updateLastIndex,
      );
      currentIndex = index % users.length;
    }

    children = [
      ...users.map((User u) => StoryScreen(
            stories: stories[u]!,
            user: u,
            controller: controller,
            lastIndex: lastIndexes[u]!,
            updateLastIndex: updateLastIndex,
          )),
    ];

    return MaterialApp(
      title: 'Mini Insta Stories',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CarouselSlider(
        controller: controller,
        slideTransform: CubeTransform(),
        onSlideChanged: onSlideChanged,
        unlimitedMode: true,
        children: children,
      ),
    );
  }
}
