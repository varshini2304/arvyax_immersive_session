import 'dart:ui';
import 'package:flutter/material.dart';
import '../../data/models/ambience.dart';
import '../theme/app_theme.dart';

class AmbienceCard extends StatelessWidget {
  final Ambience ambience;
  final VoidCallback? onTap;

  const AmbienceCard({Key? key, required this.ambience, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tagColor = _tagColor(ambience.tag);

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Hero(
            tag: 'ambience-image-${ambience.id}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                ambience.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) {
                  return const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.deepIndigo, AppColors.calmBlue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  AppColors.darkBackground.withOpacity(0.65)
                ],
                stops: const [0.45, 1],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.darkBackground.withOpacity(0.17),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 13),
                  color: Colors.white.withOpacity(0.12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ambience.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: tagColor,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              ambience.tag,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${ambience.duration.inMinutes} min',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.95),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
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

  Color _tagColor(String tag) {
    switch (tag.toLowerCase()) {
      case 'focus':
        return const Color(0xFF6F7885).withOpacity(0.9);
      case 'calm':
        return const Color(0xFF6571D5).withOpacity(0.9);
      case 'sleep':
        return const Color(0xFF3E4AA7).withOpacity(0.9);
      case 'reset':
        return const Color(0xFFC18483).withOpacity(0.9);
      default:
        return Colors.white24;
    }
  }
}
