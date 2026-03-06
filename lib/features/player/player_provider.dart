import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../../data/models/ambience.dart';

final currentAmbienceProvider = StateProvider<Ambience?>((ref) => null);
final playerPlayingProvider = StateProvider<bool>((ref) => false);
final playerElapsedProvider = StateProvider<Duration>((ref) => Duration.zero);

final playerActiveProvider = Provider<bool>(
  (ref) => ref.watch(currentAmbienceProvider) != null,
);

final audioPlayerProvider = Provider<AudioPlayer>((ref) {
  final player = AudioPlayer();
  player.setLoopMode(LoopMode.one);
  ref.onDispose(player.dispose);
  return player;
});

final playerSyncProvider = Provider<void>((ref) {
  final player = ref.watch(audioPlayerProvider);

  final stateSub = player.playerStateStream.listen((state) {
    ref.read(playerPlayingProvider.notifier).state = state.playing;
  });

  ref.onDispose(() {
    stateSub.cancel();
  });
});

final playerControllerProvider = Provider<PlayerController>(
  (ref) {
    final controller = PlayerController(ref);
    ref.onDispose(controller.dispose);
    return controller;
  },
);

class PlayerController {
  PlayerController(this.ref);

  final Ref ref;
  final Duration _sessionTotal = const Duration(minutes: 3);
  Timer? _tick;
  Duration _elapsedBase = Duration.zero;
  DateTime? _runningFrom;

  AudioPlayer get _player => ref.read(audioPlayerProvider);

  Future<void> startAmbience(Ambience ambience) async {
    _tick?.cancel();
    _elapsedBase = Duration.zero;
    _runningFrom = DateTime.now();
    ref.read(currentAmbienceProvider.notifier).state = ambience;
    ref.read(playerElapsedProvider.notifier).state = Duration.zero;

    try {
      await _player.setAsset(ambience.audioAsset);
      await _player.play();
      _startTicker();
    } catch (_) {
      _runningFrom = null;
      ref.read(playerPlayingProvider.notifier).state = false;
    }
  }

  Future<void> togglePlayPause() async {
    if (_player.playing) {
      _elapsedBase = _currentElapsed();
      _runningFrom = null;
      await _player.pause();
    } else {
      _runningFrom = DateTime.now();
      await _player.play();
      _startTicker();
    }
  }

  Future<void> seek(Duration position) async {
    final clamped = _clampToSession(position);
    _elapsedBase = clamped;
    _runningFrom = _player.playing ? DateTime.now() : null;
    ref.read(playerElapsedProvider.notifier).state = clamped;

    final audioDuration = _player.duration;
    if (audioDuration != null && audioDuration > Duration.zero) {
      final ms = clamped.inMilliseconds % audioDuration.inMilliseconds;
      await _player.seek(Duration(milliseconds: ms));
    }
  }

  Future<void> stopAndClear() async {
    _tick?.cancel();
    _elapsedBase = Duration.zero;
    _runningFrom = null;
    await _player.stop();
    ref.read(playerPlayingProvider.notifier).state = false;
    ref.read(playerElapsedProvider.notifier).state = Duration.zero;
    ref.read(currentAmbienceProvider.notifier).state = null;
  }

  void _startTicker() {
    _tick?.cancel();
    _tick = Timer.periodic(const Duration(milliseconds: 200), (_) {
      if (_runningFrom == null) return;

      final elapsed = _clampToSession(_currentElapsed());
      ref.read(playerElapsedProvider.notifier).state = elapsed;

      if (elapsed >= _sessionTotal) {
        _finishAtLimit();
      }
    });
  }

  Duration _currentElapsed() {
    final startedAt = _runningFrom;
    if (startedAt == null) return _elapsedBase;
    return _elapsedBase + DateTime.now().difference(startedAt);
  }

  Duration _clampToSession(Duration value) {
    if (value < Duration.zero) return Duration.zero;
    if (value > _sessionTotal) return _sessionTotal;
    return value;
  }

  Future<void> _finishAtLimit() async {
    _tick?.cancel();
    _runningFrom = null;
    _elapsedBase = _sessionTotal;
    await _player.pause();
    ref.read(playerElapsedProvider.notifier).state = _sessionTotal;
    ref.read(playerPlayingProvider.notifier).state = false;
  }

  void dispose() {
    _tick?.cancel();
  }
}
