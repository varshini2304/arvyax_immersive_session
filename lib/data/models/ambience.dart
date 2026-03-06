class Ambience {
  final String id;
  final String title;
  final String tag;
  final Duration duration;
  final String imageUrl;
  final String audioAsset;
  final String description;
  final List<String> sensoryRecipe;

  Ambience({
    required this.id,
    required this.title,
    required this.tag,
    required this.duration,
    required this.imageUrl,
    required this.audioAsset,
    this.description = '',
    this.sensoryRecipe = const [],
  });
}
