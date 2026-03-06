import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/widgets/ambience_card.dart';
import '../../shared/widgets/mini_player.dart';
import '../../shared/theme/app_theme.dart';
import '../../shared/widgets/tag_chip.dart';
import 'ambience_provider.dart';
import '../player/player_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(playerSyncProvider);

    final ambiencesAsync = ref.watch(ambienceListProvider);
    final selectedTag = ref.watch(ambienceTagProvider);
    final query = ref.watch(ambienceQueryProvider);
    final currentAmbience = ref.watch(currentAmbienceProvider);
    final elapsed = ref.watch(playerElapsedProvider);

    final miniPlayerProgress = currentAmbience == null
        ? 0.0
        : elapsed.inMilliseconds.toDouble() /
            currentAmbience.duration.inMilliseconds.clamp(1, 1 << 31);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
          children: [
            const _HomeBackground(),
            Column(
              children: [
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isCompact = constraints.maxWidth < 380;
                      final maxContentWidth = constraints.maxWidth > 760
                          ? 700.0
                          : constraints.maxWidth;

                      return Center(
                        child: SizedBox(
                          width: maxContentWidth,
                          child: CustomScrollView(
                            slivers: [
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(
                                    24,
                                    16,
                                    24,
                                    isCompact ? 12 : 22,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Good Evening',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall
                                            ?.copyWith(
                                              color: Colors.white.withOpacity(0.72),
                                              fontWeight: FontWeight.w500,
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'Explore Ambiences',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineLarge
                                            ?.copyWith(
                                              color: Colors.white.withOpacity(0.95),
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 28),
                                      _GlassSearchBar(
                                        value: query,
                                        onChanged: (value) {
                                          ref
                                              .read(ambienceQueryProvider
                                                  .notifier)
                                              .state = value;
                                        },
                                      ),
                                      const SizedBox(height: 18),
                                      Wrap(
                                        spacing: 12,
                                        runSpacing: 8,
                                        children: [
                                          'Focus',
                                          'Calm',
                                          'Sleep',
                                          'Reset'
                                        ].map(
                                          (tag) {
                                            final isSelected =
                                                selectedTag == tag;
                                            return SizedBox(
                                              width: 108,
                                              child: TagChip(
                                                label: tag,
                                                selected: isSelected,
                                                filledGradient: false,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 12,
                                                  horizontal: 10,
                                                ),
                                                onTap: () {
                                                  ref
                                                      .read(ambienceTagProvider
                                                          .notifier)
                                                      .state = isSelected
                                                      ? null
                                                      : tag;
                                                },
                                              ),
                                            );
                                          },
                                        ).toList(),
                                      ),
                                      const SizedBox(height: 14),
                                    ],
                                  ),
                                ),
                              ),
                              ambiencesAsync.when(
                                data: (ambiences) {
                                  if (ambiences.isEmpty) {
                                    return SliverFillRemaining(
                                      hasScrollBody: false,
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(24),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'No ambiences found',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge,
                                              ),
                                              const SizedBox(height: 12),
                                              TextButton(
                                                onPressed: () {
                                                  ref
                                                      .read(
                                                        ambienceQueryProvider
                                                            .notifier,
                                                      )
                                                      .state = '';
                                                  ref
                                                      .read(
                                                        ambienceTagProvider
                                                            .notifier,
                                                      )
                                                      .state = null;
                                                },
                                                child:
                                                    const Text('Clear Filters'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }

                                  return SliverPadding(
                                    padding: const EdgeInsets.fromLTRB(
                                      24,
                                      8,
                                      24,
                                      160,
                                    ),
                                    sliver: SliverGrid(
                                      delegate: SliverChildBuilderDelegate((
                                        context,
                                        index,
                                      ) {
                                        final ambience = ambiences[index];
                                        return AmbienceCard(
                                          ambience: ambience,
                                          onTap: () => Navigator.pushNamed(
                                            context,
                                            '/details',
                                            arguments: ambience,
                                          ),
                                        );
                                      }, childCount: ambiences.length),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount:
                                            constraints.maxWidth < 340 ? 1 : 2,
                                        mainAxisSpacing: 16,
                                        crossAxisSpacing: 16,
                                        childAspectRatio: 0.86,
                                      ),
                                    ),
                                  );
                                },
                                loading: () => const SliverFillRemaining(
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                                error: (e, _) => SliverFillRemaining(
                                  child: Center(
                                    child: Text(
                                      'Error loading ambiences',
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (ref.watch(playerActiveProvider) && currentAmbience != null)
                  MiniPlayer(
                    ambience: currentAmbience,
                    progress: miniPlayerProgress,
                    playing: ref.watch(playerPlayingProvider),
                    onTap: () => Navigator.pushNamed(context, '/session'),
                    onPlayPause: () => ref.read(playerControllerProvider).togglePlayPause(),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeBackground extends StatelessWidget {
  const _HomeBackground();

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
          alignment: const Alignment(0, 0.2),
          child: Container(
            width: 520,
            height: 520,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AmbienceUiTokens.glowCore.withOpacity(0.7),
                  AmbienceUiTokens.glowRing.withOpacity(0.2),
                  Colors.transparent,
                ],
                stops: const [0.1, 0.48, 1],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _GlassSearchBar extends StatefulWidget {
  const _GlassSearchBar({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  State<_GlassSearchBar> createState() => _GlassSearchBarState();
}

class _GlassSearchBarState extends State<_GlassSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant _GlassSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && _controller.text != widget.value) {
      _controller.value = TextEditingValue(
        text: widget.value,
        selection: TextSelection.collapsed(offset: widget.value.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AmbienceUiTokens.pillRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentGlow.withOpacity(0.35),
            blurRadius: 26,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AmbienceUiTokens.pillRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: TextField(
            controller: _controller,
            onChanged: widget.onChanged,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.white.withOpacity(0.9)),
            decoration: InputDecoration(
              hintText: 'Search ambience',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: Colors.white.withOpacity(0.8),
                size: 33,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
              filled: true,
              fillColor: Colors.white.withOpacity(0.14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AmbienceUiTokens.pillRadius),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AmbienceUiTokens.pillRadius),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AmbienceUiTokens.pillRadius),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.45)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
