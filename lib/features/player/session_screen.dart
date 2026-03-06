import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/theme/app_theme.dart';
import 'player_provider.dart';

class SessionScreen extends ConsumerStatefulWidget {
  const SessionScreen({super.key});

  @override
  ConsumerState<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends ConsumerState<SessionScreen>
    with TickerProviderStateMixin {
  late final AnimationController _breathController;
  late final AnimationController _gradientController;

  @override
  void initState() {
    super.initState();
    _breathController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 6),
    )..repeat(reverse: true);
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _breathController.dispose();
    _gradientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(playerSyncProvider);

    final ambience = ref.watch(currentAmbienceProvider);
    if (ambience == null) {
      return const Scaffold(body: SizedBox.shrink());
    }

    final total = ambience.duration;
    final playing = ref.watch(playerPlayingProvider);
    final elapsed = ref.watch(playerElapsedProvider);
    final progress =
        (elapsed.inMilliseconds / total.inMilliseconds.clamp(1, 1 << 31))
            .clamp(0.0, 1.0)
            .toDouble();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedBuilder(
            animation: _gradientController,
            builder: (context, child) {
              final t = _gradientController.value;
              return Stack(
                fit: StackFit.expand,
                children: [
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: AmbienceUiTokens.backgroundGradient,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment(0.25 - (t * 0.15), 0.15),
                    child: Container(
                      width: 620,
                      height: 620,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AmbienceUiTokens.glowCore.withOpacity(0.72),
                            AmbienceUiTokens.glowRing.withOpacity(0.22),
                            Colors.transparent,
                          ],
                          stops: const [0.08, 0.46, 1],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final orbSize = constraints.maxWidth < 390 ? 260.0 : 290.0;
                return Column(
                  children: [
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 14),
                        child: IconButton(
                          onPressed: () {
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            } else {
                              Navigator.pushReplacementNamed(context, '/');
                            }
                          },
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black.withOpacity(0.22),
                          ),
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      ambience.title,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.white.withOpacity(0.78),
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 26),
                    ScaleTransition(
                      scale: Tween(begin: 0.96, end: 1.04).animate(
                        CurvedAnimation(
                          parent: _breathController,
                          curve: Curves.easeInOutSine,
                        ),
                      ),
                      child: Container(
                        width: orbSize,
                        height: orbSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.34),
                              AppColors.calmBlue.withOpacity(0.25),
                              AppColors.softLavender.withOpacity(0.4),
                            ],
                          ),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.42),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accentGlow.withOpacity(0.4),
                              blurRadius: 46,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 34),
                    Text(
                      '${_format(elapsed)} / ${_format(total)}',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.white.withOpacity(0.76),
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 36),
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          overlayShape: SliderComponentShape.noOverlay,
                          thumbColor: Colors.white.withOpacity(0.9),
                          thumbShape:
                              const RoundSliderThumbShape(enabledThumbRadius: 3),
                          activeTrackColor: AppColors.calmBlue,
                          inactiveTrackColor: Colors.white.withOpacity(0.34),
                          trackHeight: 2,
                        ),
                        child: Slider(
                          value: progress * total.inSeconds.toDouble(),
                          max: total.inSeconds.toDouble(),
                          onChanged: (v) => ref
                              .read(playerControllerProvider)
                              .seek(Duration(seconds: v.toInt())),
                        ),
                      ),
                    ),
                    const SizedBox(height: 34),
                    GestureDetector(
                      onTap: () =>
                          ref.read(playerControllerProvider).togglePlayPause(),
                      child: Container(
                        width: 108,
                        height: 108,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.36),
                              AppColors.calmBlue.withOpacity(0.28),
                            ],
                          ),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.35),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.22),
                              blurRadius: 26,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Icon(
                          playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                          size: 54,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 44),
                      child: SizedBox(
                        width: constraints.maxWidth * 0.62,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(AmbienceUiTokens.pillRadius),
                            gradient: LinearGradient(
                              colors: [
                                AppColors.calmBlue.withOpacity(0.75),
                                AppColors.softLavender.withOpacity(0.75),
                              ],
                            ),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.24),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accentGlow.withOpacity(0.28),
                                blurRadius: 24,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white.withOpacity(0.84),
                              shape: const StadiumBorder(),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            onPressed: () => _showEndSessionDialog(context),
                            child: Text(
                              'End Session',
                              style:
                                  Theme.of(context).textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showEndSessionDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'End Session?',
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () async {
                              Navigator.of(context, rootNavigator: true).pop();
                              if (!mounted) return;

                              Navigator.of(
                                context,
                              ).pushReplacementNamed('/reflection');

                              await ref
                                  .read(playerControllerProvider)
                                  .stopAndClear();
                            },
                            child: const Text('End'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _format(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
