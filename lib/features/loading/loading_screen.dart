import 'package:flutter/material.dart';

import '../../shared/theme/app_theme.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    Future<void>.delayed(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/');
    });
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedBuilder(
        animation: _glowController,
        builder: (context, _) {
          final t = _glowController.value;
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
                alignment: const Alignment(0.2, 0.1),
                child: Container(
                  width: 560,
                  height: 560,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AmbienceUiTokens.glowCore.withOpacity(0.55 + 0.2 * t),
                        AmbienceUiTokens.glowRing.withOpacity(0.18 + 0.1 * t),
                        Colors.transparent,
                      ],
                      stops: const [0.1, 0.45, 1],
                    ),
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'ArvyaX',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: Colors.white.withOpacity(0.95),
                          ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Preparing your ambience...',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white.withOpacity(0.75),
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                    const SizedBox(height: 26),
                    SizedBox(
                      width: 120,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          AmbienceUiTokens.pillRadius,
                        ),
                        child: LinearProgressIndicator(
                          minHeight: 4,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          valueColor: AlwaysStoppedAnimation(
                            AppColors.softLavender.withOpacity(0.95),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
