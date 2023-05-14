class Story {
  final String url;
  final bool isVideo;
  final String? caption;

  Story({
    required this.url,
    required this.isVideo,
    this.caption,
  });
}
