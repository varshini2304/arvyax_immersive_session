enum Mood { calm, grounded, energized, sleepy }

extension MoodX on Mood {
  String get label => switch (this) {
        Mood.calm => 'Calm',
        Mood.grounded => 'Grounded',
        Mood.energized => 'Energized',
        Mood.sleepy => 'Sleepy',
      };

  String get emoji => switch (this) {
        Mood.calm => '😌',
        Mood.grounded => '🌿',
        Mood.energized => '⚡',
        Mood.sleepy => '😴',
      };
}

class JournalEntry {
  final String id;
  final DateTime date;
  final String ambienceTitle;
  final Mood mood;
  final String text;

  JournalEntry({
    required this.id,
    required this.date,
    required this.ambienceTitle,
    required this.mood,
    required this.text,
  });
}
