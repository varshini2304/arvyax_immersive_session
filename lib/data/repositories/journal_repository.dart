import '../models/journal_entry.dart';

class JournalRepository {
  final List<JournalEntry> _entries = [
    JournalEntry(
      id: 'seed-1',
      date: DateTime(2025, 8, 22),
      ambienceTitle: 'Forest Focus',
      mood: Mood.calm,
      text:
          'I felt very relaxed today and noticed more space between thoughts.',
    ),
    JournalEntry(
      id: 'seed-2',
      date: DateTime(2025, 8, 20),
      ambienceTitle: 'Night Rain',
      mood: Mood.sleepy,
      text: 'The rain ambience helped me settle down before bed.',
    ),
  ];

  Future<List<JournalEntry>> fetchEntries() async {
    await Future.delayed(Duration(milliseconds: 200));
    return List.unmodifiable(_entries);
  }

  Future<void> addEntry(JournalEntry entry) async {
    await Future.delayed(Duration(milliseconds: 100));
    _entries.insert(0, entry);
  }
}
