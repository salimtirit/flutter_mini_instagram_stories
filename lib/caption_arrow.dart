import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CaptionArrow extends StatelessWidget {
  final url;

  const CaptionArrow({
    required Key key,
    required this.url,
  }) : super(key: key);

  Future<void> _launchUrl(url) async {
    Uri _url = Uri.parse(url);
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        onTap: () => _launchUrl(url),
        child: Icon(
          Icons.keyboard_arrow_up,
          color: Colors.white,
          size: 75,
        ),
      ),
    );
  }
}
