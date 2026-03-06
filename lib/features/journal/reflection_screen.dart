import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/journal_entry.dart';
import '../../shared/theme/app_theme.dart';
import 'journal_provider.dart';
import '../player/player_provider.dart';

class ReflectionScreen extends ConsumerWidget {
  const ReflectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mood = ref.watch(selectedMoodProvider);
    final text = ref.watch(journalTextProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const _ReflectionBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 30, 22, 30),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 760),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
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
                      const SizedBox(height: 8),
                      Text(
                        'Reflection',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              color: Colors.white.withOpacity(0.92),
                            ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'What is gently present with you right now?',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Colors.white.withOpacity(0.74),
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      const SizedBox(height: 30),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: Container(
                            height: 310,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white.withOpacity(0.18),
                                  Colors.white.withOpacity(0.09),
                                ],
                              ),
                              border: Border.all(color: Colors.white.withOpacity(0.25)),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.accentGlow.withOpacity(0.3),
                                  blurRadius: 24,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: TextField(
                              maxLines: null,
                              expands: true,
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    color: Colors.white.withOpacity(0.9),
                                    fontWeight: FontWeight.w400,
                                  ),
                              onChanged: (v) =>
                                  ref.read(journalTextProvider.notifier).state = v,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.fromLTRB(
                                  24,
                                  24,
                                  24,
                                  24,
                                ),
                                border: InputBorder.none,
                                hintText: '| Write your thoughts...',
                                hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.56),
                                  fontSize: 48 / 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 12,
                        runSpacing: 10,
                        children: Mood.values.map((m) {
                          final isSelected = mood == m;
                          return _MoodPill(
                            label: '${m.emoji} ${m.label}',
                            selected: isSelected,
                            onTap: () =>
                                ref.read(selectedMoodProvider.notifier).state = m,
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                      _SaveButton(
                        onTap: () async {
                          final entry = JournalEntry(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            date: DateTime.now(),
                            ambienceTitle:
                                ref.read(currentAmbienceProvider)?.title ??
                                    'Quiet Pause',
                            mood: mood ?? Mood.calm,
                            text: text.trim().isEmpty
                                ? 'I took a quiet moment to breathe and reset.'
                                : text.trim(),
                          );

                          await ref.read(journalListProvider.notifier).addEntry(entry);

                          ref.read(journalTextProvider.notifier).state = '';
                          ref.read(selectedMoodProvider.notifier).state = null;

                          Navigator.pushReplacementNamed(context, '/journalHistory');
                        },
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
}

class _ReflectionBackground extends StatelessWidget {
  const _ReflectionBackground();

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
          alignment: const Alignment(0.32, 0.04),
          child: Container(
            width: 620,
            height: 620,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AmbienceUiTokens.glowCore.withOpacity(0.75),
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

class _MoodPill extends StatelessWidget {
  const _MoodPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = _accentFromLabel(label);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AmbienceUiTokens.pillRadius),
          gradient: LinearGradient(
            colors: selected
                ? [
                    accent.withOpacity(0.44),
                    Colors.white.withOpacity(0.34),
                  ]
                : [
                    accent.withOpacity(0.28),
                    Colors.white.withOpacity(0.11),
                  ],
          ),
          border: Border.all(color: Colors.white.withOpacity(0.24)),
          boxShadow: [
            BoxShadow(
              color: AppColors.accentGlow.withOpacity(selected ? 0.28 : 0.18),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white.withOpacity(0.94),
                fontWeight: FontWeight.w500,
                fontSize: 19,
              ),
        ),
      ),
    );
  }

  Color _accentFromLabel(String value) {
    final key = value.toLowerCase();
    if (key.contains('calm')) return const Color(0xFFD18B6C);
    if (key.contains('grounded')) return const Color(0xFF56B180);
    if (key.contains('energized')) return const Color(0xFFDD7F95);
    if (key.contains('sleepy')) return const Color(0xFF7E84FF);
    return AppColors.softLavender;
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 560),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AmbienceUiTokens.pillRadius),
        gradient: const LinearGradient(
          colors: AmbienceUiTokens.primaryButtonGradient,
        ),
        border: Border.all(color: Colors.white.withOpacity(0.26)),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentGlow.withOpacity(0.32),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          minimumSize: const Size(double.infinity, 82),
          foregroundColor: Colors.white,
          shape: const StadiumBorder(),
        ),
        onPressed: onTap,
        child: Text(
          'Save Reflection',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white.withOpacity(0.95),
                fontWeight: FontWeight.w500,
              ),
        ),
      ),
    );
  }
}
