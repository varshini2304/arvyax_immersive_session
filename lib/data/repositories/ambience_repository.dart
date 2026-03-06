import '../models/ambience.dart';

class AmbienceRepository {
  final List<Ambience> _ambiences = [
    Ambience(
      id: '1',
      title: 'Forest Focus',
      tag: 'Focus',
      duration: Duration(minutes: 3),
      imageUrl: 'assets/images/forest.jpg',
      description:
          'A gentle forest soundscape designed to help you focus and feel grounded.',
      sensoryRecipe: ['Breeze', 'Warm Light', 'Mist', 'Binaural', 'Soft Rain'],
    ),
    Ambience(
      id: '2',
      title: 'Ocean Calm',
      tag: 'Calm',
      duration: Duration(minutes: 2),
      imageUrl: 'assets/images/ocean.jpg',
      description:
          'Rolling ocean textures and distant shorelines for a calm, steady mind.',
      sensoryRecipe: ['Sea Air', 'Blue Light', 'Mist', 'Soft Tide', 'Binaural'],
    ),
    Ambience(
      id: '3',
      title: 'Night Rain',
      tag: 'Sleep',
      duration: Duration(minutes: 4),
      imageUrl: 'assets/images/rain.jpg',
      description:
          'Layered rain droplets and low evening ambience designed to ease sleep.',
      sensoryRecipe: [
        'Soft Rain',
        'Moonlight',
        'Cool Air',
        'Stillness',
        'Deep Tone'
      ],
    ),
    Ambience(
      id: '4',
      title: 'Mountain Reset',
      tag: 'Reset',
      duration: Duration(minutes: 3),
      imageUrl: 'assets/images/mountain.jpg',
      description:
          'A refreshing alpine sound bath to reset your attention and energy.',
      sensoryRecipe: [
        'Wind',
        'Warm Sun',
        'Clear Air',
        'Birdsong',
        'Ground Tone'
      ],
    ),
  ];

  Future<List<Ambience>> fetchAmbiences({String? query, String? tag}) async {
    await Future.delayed(Duration(milliseconds: 300));
    return _ambiences.where((a) {
      final matchesQuery = query == null ||
          query.isEmpty ||
          a.title.toLowerCase().contains(query.toLowerCase());
      final matchesTag = tag == null ||
          tag.isEmpty ||
          a.tag.toLowerCase() == tag.toLowerCase();
      return matchesQuery && matchesTag;
    }).toList();
  }
}
