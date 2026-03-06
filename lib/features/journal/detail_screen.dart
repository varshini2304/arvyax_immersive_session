import 'dart:ui';

import 'package:flutter/material.dart';
import '../../data/models/journal_entry.dart';
import '../../shared/theme/app_theme.dart';

class DetailScreen extends StatelessWidget {
  final JournalEntry entry;
  const DetailScreen({Key? key, required this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const _DetailBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 28),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 760),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
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
                          const Spacer(),
                        ],
                      ),
                      Text(
                        'Reflection Detail',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              color: Colors.white.withOpacity(0.92),
                            ),
                      ),
                      const SizedBox(height: 22),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 9, sigmaY: 9),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.2),
                                  Colors.white.withOpacity(0.1),
                                ],
                              ),
                              border: Border.all(color: Colors.white.withOpacity(0.24)),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.accentGlow.withOpacity(0.24),
                                  blurRadius: 24,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${_month(entry.date.month)} ${entry.date.day}, ${entry.date.year}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        color: Colors.white.withOpacity(0.78),
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  entry.ambienceTitle,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                        color: Colors.white.withOpacity(0.96),
                                      ),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      AmbienceUiTokens.pillRadius,
                                    ),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.white.withOpacity(0.32),
                                        Colors.white.withOpacity(0.18),
                                      ],
                                    ),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.2),
                                    ),
                                  ),
                                  child: Text(
                                    '${entry.mood.emoji} ${entry.mood.label}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          color: Colors.white.withOpacity(0.95),
                                        ),
                                  ),
                                ),
                                const SizedBox(height: 18),
                                Text(
                                  entry.text,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        color: Colors.white.withOpacity(0.86),
                                        height: 1.7,
                                        fontWeight: FontWeight.w400,
                                      ),
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
        ],
      ),
    );
  }

  String _month(int value) => const [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ][value - 1];
}

class _DetailBackground extends StatelessWidget {
  const _DetailBackground();

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
          alignment: const Alignment(0.3, 0.08),
          child: Container(
            width: 640,
            height: 640,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AmbienceUiTokens.glowCore.withOpacity(0.74),
                  AmbienceUiTokens.glowRing.withOpacity(0.22),
                  Colors.transparent,
                ],
                stops: const [0.08, 0.45, 1],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
