import 'package:flutter/material.dart';
import '../data/models/ambience.dart';
import '../data/models/journal_entry.dart';
import '../features/ambience/home_screen.dart';
import '../features/ambience/details_screen.dart';
import '../features/player/session_screen.dart';
import '../features/journal/reflection_screen.dart';
import '../features/journal/history_screen.dart';
import '../features/journal/detail_screen.dart';

class AppRouter {
  static Route<dynamic> generate(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/details':
        final ambience = settings.arguments as Ambience;
        return MaterialPageRoute(
          builder: (_) => DetailsScreen(ambience: ambience),
        );
      case '/session':
        return MaterialPageRoute(builder: (_) => const SessionScreen());
      case '/reflection':
        return MaterialPageRoute(builder: (_) => const ReflectionScreen());
      case '/journalHistory':
        return MaterialPageRoute(builder: (_) => const HistoryScreen());
      case '/journalDetail':
        final entry = settings.arguments as JournalEntry;
        return MaterialPageRoute(builder: (_) => DetailScreen(entry: entry));
      default:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
    }
  }
}
