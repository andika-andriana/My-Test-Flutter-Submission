import 'package:ditonton/features/movie/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton/features/tv_series/presentation/pages/watchlist_tv_series_page.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

enum DrawerSection { movies, tvSeries }

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key, required this.current});

  final DrawerSection current;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage('assets/circle-g.png'),
            ),
            accountName: const Text('Ditonton'),
            accountEmail: const Text('ditonton@dicoding.com'),
            decoration: BoxDecoration(color: Colors.grey.shade900),
          ),
          ListTile(
            leading: const Icon(Icons.movie),
            title: const Text('Movies'),
            selected: current == DrawerSection.movies,
            onTap: () async {
              // Log drawer navigation event
              if (Firebase.apps.isNotEmpty) {
                await FirebaseAnalytics.instance.logEvent(
                  name: 'drawer_navigation',
                  parameters: {
                    'destination': 'movies',
                    'current_section': current.name,
                    'timestamp': DateTime.now().millisecondsSinceEpoch,
                  },
                );
              }
              if (context.mounted) {
                Navigator.pop(context);
              }
              if (current != DrawerSection.movies && context.mounted) {
                Navigator.pushReplacementNamed(context, homeMovieRoute);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.tv),
            title: const Text('TV Series'),
            selected: current == DrawerSection.tvSeries,
            onTap: () async {
              // Log drawer navigation event
              if (Firebase.apps.isNotEmpty) {
                await FirebaseAnalytics.instance.logEvent(
                  name: 'drawer_navigation',
                  parameters: {
                    'destination': 'tv_series',
                    'current_section': current.name,
                    'timestamp': DateTime.now().millisecondsSinceEpoch,
                  },
                );
              }
              if (context.mounted) {
                Navigator.pop(context);
              }
              if (current != DrawerSection.tvSeries && context.mounted) {
                Navigator.pushReplacementNamed(context, homeTVSeriesRoute);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.save_alt),
            title: const Text('Watchlist Movies'),
            onTap: () async {
              // Log watchlist access event
              if (Firebase.apps.isNotEmpty) {
                await FirebaseAnalytics.instance.logEvent(
                  name: 'watchlist_accessed',
                  parameters: {
                    'watchlist_type': 'movies',
                    'timestamp': DateTime.now().millisecondsSinceEpoch,
                  },
                );
              }
              if (context.mounted) {
                Navigator.pop(context);
                Navigator.pushNamed(context, WatchlistMoviesPage.routeName);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.bookmark_added_outlined),
            title: const Text('Watchlist TV Series'),
            onTap: () async {
              // Log watchlist access event
              if (Firebase.apps.isNotEmpty) {
                await FirebaseAnalytics.instance.logEvent(
                  name: 'watchlist_accessed',
                  parameters: {
                    'watchlist_type': 'tv_series',
                    'timestamp': DateTime.now().millisecondsSinceEpoch,
                  },
                );
              }
              if (context.mounted) {
                Navigator.pop(context);
                Navigator.pushNamed(context, WatchlistTVSeriesPage.routeName);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            onTap: () async {
              // Log about page access event
              if (Firebase.apps.isNotEmpty) {
                await FirebaseAnalytics.instance.logEvent(
                  name: 'about_accessed',
                  parameters: {'timestamp': DateTime.now().millisecondsSinceEpoch},
                );
              }
              if (context.mounted) {
                Navigator.pop(context);
                Navigator.pushNamed(context, AboutPage.routeName);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.bug_report),
            title: const Text('Test Crashlytics'),
            onTap: () async {
              // Log crashlytics test event
              if (Firebase.apps.isNotEmpty) {
                await FirebaseAnalytics.instance.logEvent(
                  name: 'crashlytics_test_triggered',
                  parameters: {
                    'test_type': 'manual_test_crash',
                    'timestamp': DateTime.now().millisecondsSinceEpoch,
                  },
                );
              }

              if (context.mounted) {
                Navigator.pop(context);

                // Show confirmation dialog
                final shouldTest = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Test Firebase Crashlytics'),
                    content: const Text(
                      'This will trigger a FATAL crash to verify Firebase Crashlytics integration. '
                      'The app will crash and restart, but the crash will be recorded in Firebase Crashlytics Dashboard. '
                      'Make sure you have saved any important work before continuing.\n\n'
                      'Continue?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        style: TextButton.styleFrom(foregroundColor: Colors.red),
                        child: const Text('Test (App will crash)'),
                      ),
                    ],
                  ),
                );

                if (shouldTest == true) {
                  // Trigger test crash
                  _triggerTestCrash();
                }
              }
            },
          ),
        ],
      ),
    );
  }

  /// Triggers a test crash for Firebase Crashlytics verification
  /// This method creates a fatal error that will be recorded in Firebase Crashlytics Dashboard
  void _triggerTestCrash() {
    // Log the test crash event before triggering
    FirebaseAnalytics.instance.logEvent(
      name: 'crashlytics_test_crash_triggered',
      parameters: {
        'error_type': 'manual_test_exception',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'source': 'app_drawer_menu',
      },
    );

    // Set custom keys for better debugging in Crashlytics
    FirebaseCrashlytics.instance.setCustomKey('test_crash_source', 'app_drawer_menu');
    FirebaseCrashlytics.instance.setCustomKey(
      'test_crash_timestamp',
      DateTime.now().toIso8601String(),
    );
    FirebaseCrashlytics.instance.setCustomKey('test_crash_type', 'manual_test');

    // Log a custom message
    FirebaseCrashlytics.instance.log('Manual test crash triggered from app drawer menu');

    // Create a fatal error that will be recorded in Crashlytics Dashboard
    // This will cause the app to crash and be recorded as a fatal error
    throw Exception(
      'Test crash triggered manually from app drawer - Firebase Crashlytics integration test',
    );
  }
}

const homeMovieRoute = '/home';
const homeTVSeriesRoute = '/home-tv-series';
