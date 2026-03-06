import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/ambience.dart';

final currentAmbienceProvider = StateProvider<Ambience?>((ref) => null);
final playerPlayingProvider = StateProvider<bool>((ref) => false);
final playerElapsedProvider = StateProvider<Duration>((ref) => Duration.zero);

final playerActiveProvider = Provider<bool>(
  (ref) => ref.watch(currentAmbienceProvider) != null,
);
