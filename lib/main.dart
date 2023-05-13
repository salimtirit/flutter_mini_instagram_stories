import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mini_insta_stories/data.dart';
import 'package:mini_insta_stories/story_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      title: 'Mini Insta Stories',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StoryScreen(stories: stories, users: users),
    );
  }
}
