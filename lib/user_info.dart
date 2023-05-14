import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mini_insta_stories/user.dart';

class UserInfo extends StatelessWidget {
  final User user;

  const UserInfo({
    required Key key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        CircleAvatar(
          radius: 20.0,
          backgroundColor: Colors.grey[300],
          backgroundImage: CachedNetworkImageProvider(
            user.profileImageUrl,
          ),
        ),
        const SizedBox(width: 10.0),
        Expanded(
          child: Text(
            user.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
