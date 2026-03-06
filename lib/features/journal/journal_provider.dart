import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/journal_entry.dart';
import '../../data/repositories/journal_repository.dart';

final journalRepositoryProvider = Provider<JournalRepository>(
  (ref) => JournalRepository(),
);

class JournalNotifier extends AutoDisposeAsyncNotifier<List<JournalEntry>> {
  @override
  Future<List<JournalEntry>> build() async {
    return ref.read(journalRepositoryProvider).fetchEntries();
  }

  Future<void> addEntry(JournalEntry entry) async {
    await ref.read(journalRepositoryProvider).addEntry(entry);
    state = AsyncData(await ref.read(journalRepositoryProvider).fetchEntries());
  }
}

final journalListProvider =
    AutoDisposeAsyncNotifierProvider<JournalNotifier, List<JournalEntry>>(
  JournalNotifier.new,
);

final selectedMoodProvider = StateProvider<Mood?>((ref) => null);

final journalTextProvider = StateProvider<String>((ref) => '');
