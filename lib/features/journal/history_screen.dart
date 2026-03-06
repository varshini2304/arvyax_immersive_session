import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/widgets/journal_card.dart';
import '../../shared/theme/app_theme.dart';
import 'journal_provider.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(journalListProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const _HistoryBackground(),
          SafeArea(
            child: entriesAsync.when(
              data: (entries) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(22, 28, 22, 28),
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
                          IconButton(
                            onPressed: () =>
                                Navigator.pushReplacementNamed(context, '/'),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.black.withOpacity(0.18),
                            ),
                            icon: const Icon(
                              Icons.home_rounded,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, '/reflection'),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.black.withOpacity(0.18),
                            ),
                            icon: const Icon(
                              Icons.edit_note_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Reflection History',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              color: Colors.white.withOpacity(0.92),
                            ),
                      ),
                      const SizedBox(height: 24),
                      if (entries.isNotEmpty)
                        ...entries.take(2).map(
                              (e) => GestureDetector(
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  '/journalDetail',
                                  arguments: e,
                                ),
                                child: JournalCard(entry: e),
                              ),
                            ),
                      const SizedBox(height: 90),
                      const _EmptyState(showTitle: false),
                    ],
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) =>
                  const Center(child: Text('Failed to load reflections')),
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryBackground extends StatelessWidget {
  const _HistoryBackground();

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
          alignment: const Alignment(0.35, 0.05),
          child: Container(
            width: 680,
            height: 680,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AmbienceUiTokens.glowCore.withOpacity(0.72),
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

class _EmptyState extends StatelessWidget {
  const _EmptyState({this.showTitle = true});

  final bool showTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showTitle) ...[
          const SizedBox(height: 28),
          Text(
            'Reflection History',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Colors.white.withOpacity(0.92),
                ),
          ),
          const Spacer(),
        ],
        Container(
          width: 116,
          height: 116,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.2),
                Colors.white.withOpacity(0.08),
              ],
            ),
            border: Border.all(color: Colors.white.withOpacity(0.22)),
            boxShadow: [
              BoxShadow(
                color: AppColors.accentGlow.withOpacity(0.24),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(
            Icons.menu_book_rounded,
            size: 58,
            color: Colors.white.withOpacity(0.56),
          ),
        ),
        const SizedBox(height: 22),
        Text(
          'No reflections yet.\nStart a session to begin.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white.withOpacity(0.72),
                height: 1.5,
              ),
        ),
        if (showTitle) const Spacer(flex: 2),
      ],
    );
  }
}
