import 'package:flutter/material.dart';

class CaptionArrow extends StatelessWidget {
  const CaptionArrow({
    required Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.bottomCenter,
      child: Icon(
        Icons.keyboard_arrow_up,
        color: Colors.white,
        size: 75,
      ),
    );
  }
}
