import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/ambience.dart';
import '../../data/repositories/ambience_repository.dart';

final ambienceRepositoryProvider = Provider<AmbienceRepository>(
  (ref) => AmbienceRepository(),
);

final ambienceQueryProvider = StateProvider<String>((ref) => '');
final ambienceTagProvider = StateProvider<String?>((ref) => null);

final ambienceListProvider = FutureProvider<List<Ambience>>((ref) async {
  final repo = ref.read(ambienceRepositoryProvider);
  final query = ref.watch(ambienceQueryProvider);
  final tag = ref.watch(ambienceTagProvider);
  return repo.fetchAmbiences(query: query, tag: tag);
});
