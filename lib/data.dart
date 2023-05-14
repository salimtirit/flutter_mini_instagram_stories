import 'package:mini_insta_stories/story.dart';
import 'package:mini_insta_stories/user.dart';

final List<User> users = [
  const User(
    name: 'John Doe',
    profileImageUrl: 'https://wallpapercave.com/wp/AYWg3iu.jpg',
  ),
  const User(
    name: 'Jane Doe',
    profileImageUrl: 'https://wallpapercave.com/wp/wp10464458.jpg',
  ),
];

final Map<User, List<Story>> stories = {
  users[0]: [
    Story(
        url:
            'https://images.unsplash.com/photo-1534103362078-d07e750bd0c4?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
        isVideo: false,
        caption: 'https://www.nature.com/'),
    Story(
        url: 'https://media.giphy.com/media/moyzrwjUIkdNe/giphy.gif',
        isVideo: false,
        caption: 'https://tr.investing.com/crypto/dogecoin'),
    Story(
      url:
          'https://static.videezy.com/system/resources/previews/000/005/529/original/Reaviling_Sjusj%C3%B8en_Ski_Senter.mp4',
      isVideo: true,
    ),
    Story(
      url:
          'https://images.unsplash.com/photo-1531694611353-d4758f86fa6d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=564&q=80',
      isVideo: false,
    ),
    Story(
      url:
          'https://static.videezy.com/system/resources/previews/000/007/536/original/rockybeach.mp4',
      isVideo: true,
    )
  ],
  users[1]: [
    Story(
      url:
          'https://images.unsplash.com/photo-1683924070870-688ef2080511?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1976&q=80',
      isVideo: false,
    ),
    Story(
      url:
          'https://static.videezy.com/system/resources/previews/000/004/950/original/Snow_Day_4K_Living_Background.mp4',
      isVideo: true,
    ),
    Story(
      url:
          'https://images.unsplash.com/photo-1683969285330-eb996c2803db?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=707&q=80',
      isVideo: false,
    ),
    Story(
      url:
          'https://static.videezy.com/system/resources/previews/000/047/892/original/Pelican_2.mp4',
      isVideo: true,
    )
  ]
};
