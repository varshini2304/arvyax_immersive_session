import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/ambience.dart';
import '../../shared/theme/app_theme.dart';
import '../player/player_provider.dart';

class DetailsScreen extends ConsumerWidget {
  final Ambience ambience;
  const DetailsScreen({Key? key, required this.ambience}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final heroHeight = screenWidth < 380 ? 260.0 : 340.0;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const _DetailsBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 26),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(AmbienceUiTokens.cardRadius),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: AmbienceUiTokens.glassPanelGradient,
                      ),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accentGlow.withOpacity(0.2),
                          blurRadius: 40,
                          offset: const Offset(0, 18),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(AmbienceUiTokens.imageRadius),
                          ),
                          child: Stack(
                            children: [
                              Hero(
                                tag: 'ambience-image-${ambience.id}',
                                child: Image.asset(
                                  ambience.imageUrl,
                                  width: double.infinity,
                                  height: heroHeight,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    height: heroHeight,
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.deepIndigo,
                                          AppColors.calmBlue,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned.fill(
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.55),
                                      ],
                                      stops: const [0.5, 1],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 12,
                                left: 12,
                                child: IconButton(
                                  onPressed: () {
                                    if (Navigator.canPop(context)) {
                                      Navigator.pop(context);
                                    } else {
                                      Navigator.pushReplacementNamed(
                                        context,
                                        '/',
                                      );
                                    }
                                  },
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.black.withOpacity(
                                      0.28,
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(AmbienceUiTokens.cardRadius),
                          ),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                              child: Column(
                                children: [
                                  Text(
                                    ambience.title,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(
                                          color: Colors.white.withOpacity(0.96),
                                        ),
                                  ),
                                  const SizedBox(height: 14),
                                  Wrap(
                                    alignment: WrapAlignment.center,
                                    spacing: 12,
                                    runSpacing: 8,
                                    children: [
                                      _MetaPill(label: ambience.tag),
                                      Text(
                                        '${ambience.duration.inMinutes} minutes',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                              color: Colors.white.withOpacity(0.72),
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    ambience.description,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          height: 1.55,
                                          color: Colors.white.withOpacity(0.72),
                                          fontWeight: FontWeight.w400,
                                        ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 24,
                                    ),
                                    child: Divider(
                                      color: Colors.white.withOpacity(0.14),
                                      height: 1,
                                    ),
                                  ),
                                  Text(
                                    'Sensory Recipe',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(
                                          color: Colors.white.withOpacity(0.78),
                                        ),
                                  ),
                                  const SizedBox(height: 16),
                                  Wrap(
                                    alignment: WrapAlignment.center,
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: ambience.sensoryRecipe
                                        .map((chip) => _RecipePill(label: chip))
                                        .toList(),
                                  ),
                                  const SizedBox(height: 26),
                                  _StartSessionButton(
                                    onPressed: () {
                                      ref
                                          .read(currentAmbienceProvider.notifier)
                                          .state = ambience;
                                      ref
                                          .read(playerElapsedProvider.notifier)
                                          .state = Duration.zero;
                                      ref
                                          .read(playerPlayingProvider.notifier)
                                          .state = true;
                                      Navigator.pushNamed(context, '/session');
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailsBackground extends StatelessWidget {
  const _DetailsBackground();

  @override
  Widget build(BuildContext context) {
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
          alignment: const Alignment(0, 0.25),
          child: Container(
            width: 680,
            height: 680,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AmbienceUiTokens.glowCore.withOpacity(0.7),
                  AmbienceUiTokens.glowRing.withOpacity(0.22),
                  Colors.transparent,
                ],
                stops: const [0.1, 0.5, 1],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MetaPill extends StatelessWidget {
  const _MetaPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AmbienceUiTokens.pillRadius),
        color: Colors.white.withOpacity(0.2),
        border: Border.all(color: Colors.white.withOpacity(0.18)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: Colors.white.withOpacity(0.94),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _RecipePill extends StatelessWidget {
  const _RecipePill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AmbienceUiTokens.pillRadius),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.1),
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.18)),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentGlow.withOpacity(0.18),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Text(
        '${_iconFor(label)} $label',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Colors.white.withOpacity(0.95),
        ),
      ),
    );
  }

  String _iconFor(String value) {
    final key = value.toLowerCase();
    if (key.contains('breeze')) return '🫧';
    if (key.contains('warm')) return '☀️';
    if (key.contains('mist')) return '☁️';
    if (key.contains('binaural')) return '🎧';
    if (key.contains('rain')) return '💧';
    return '•';
  }
}

class _StartSessionButton extends StatelessWidget {
  const _StartSessionButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AmbienceUiTokens.pillRadius),
        gradient: const LinearGradient(
          colors: AmbienceUiTokens.primaryButtonGradient,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentGlow.withOpacity(0.35),
            blurRadius: 26,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          minimumSize: const Size(double.infinity, 74),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AmbienceUiTokens.pillRadius),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          'Start Session',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
