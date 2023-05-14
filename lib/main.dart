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
    CarouselSliderController _controller = CarouselSliderController();

    return MaterialApp(
      title: 'Mini Insta Stories',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CarouselSlider(
          controller: _controller,
          slideTransform: CubeTransform(),
          unlimitedMode: true,
          children: [
            ...users.map((User u) => StoryScreen(
                stories: stories[u]!, user: u, controller: _controller)),
          ]),
    );
  }
}
