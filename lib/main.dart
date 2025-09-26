import 'package:ditonton_core/ditonton_core.dart';
import 'package:ditonton/firebase_options.dart';
import 'dart:ui' as ui;
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ditonton/features/movie/presentation/bloc/movie_detail_cubit.dart';
import 'package:ditonton/features/movie/presentation/bloc/movie_search_cubit.dart';
import 'package:ditonton/features/movie/presentation/bloc/now_playing_movies_cubit.dart';
import 'package:ditonton/features/movie/presentation/bloc/popular_movies_cubit.dart';
import 'package:ditonton/features/movie/presentation/bloc/top_rated_movies_cubit.dart';
import 'package:ditonton/features/movie/presentation/bloc/watchlist_movies_cubit.dart';
import 'package:ditonton/features/movie/presentation/pages/home_movie_page.dart';
import 'package:ditonton/features/movie/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/features/movie/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/features/movie/presentation/pages/search_page.dart';
import 'package:ditonton/features/movie/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/features/movie/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/on_the_air_tv_series_cubit.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/popular_tv_series_cubit.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/top_rated_tv_series_cubit.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/tv_series_detail_cubit.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/tv_series_search_cubit.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/watchlist_tv_series_cubit.dart';
import 'package:ditonton/features/tv_series/presentation/pages/home_tv_series_page.dart';
import 'package:ditonton/features/tv_series/presentation/pages/popular_tv_series_page.dart';
import 'package:ditonton/features/tv_series/presentation/pages/search_tv_series_page.dart';
import 'package:ditonton/features/tv_series/presentation/pages/top_rated_tv_series_page.dart';
import 'package:ditonton/features/tv_series/presentation/pages/tv_series_detail_page.dart';
import 'package:ditonton/features/tv_series/presentation/pages/watchlist_tv_series_page.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/injection.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load(fileName: ".env");
  
  await _configureFirebase();
  await di.init();
  runApp(const MyApp());
}

Future<void> _configureFirebase() async {
  if (!DefaultFirebaseOptions.isConfigured) {
    debugPrint('Firebase not configured. Skipping initialization.');
    return;
  }

  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    // Log app open event
    await FirebaseAnalytics.instance.logAppOpen();

    // Log custom app start event with additional parameters
    await FirebaseAnalytics.instance.logEvent(
      name: 'app_started',
      parameters: {
        'app_version': '1.0.0',
        'platform': defaultTargetPlatform.name,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );

    // Set user properties for better analytics
    await FirebaseAnalytics.instance.setUserProperty(name: 'app_version', value: '1.0.0');

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    ui.PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  } catch (error, stackTrace) {
    debugPrint('Firebase initialization failed: $error');
    debugPrintStack(stackTrace: stackTrace);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.locator<NowPlayingMoviesCubit>()),
        BlocProvider(create: (_) => di.locator<PopularMoviesCubit>()),
        BlocProvider(create: (_) => di.locator<TopRatedMoviesCubit>()),
        BlocProvider(create: (_) => di.locator<MovieDetailCubit>()),
        BlocProvider(create: (_) => di.locator<MovieSearchCubit>()),
        BlocProvider(create: (_) => di.locator<WatchlistMoviesCubit>()),
        BlocProvider(create: (_) => di.locator<OnTheAirTVSeriesCubit>()),
        BlocProvider(create: (_) => di.locator<PopularTVSeriesCubit>()),
        BlocProvider(create: (_) => di.locator<TopRatedTVSeriesCubit>()),
        BlocProvider(create: (_) => di.locator<TVSeriesDetailCubit>()),
        BlocProvider(create: (_) => di.locator<TVSeriesSearchCubit>()),
        BlocProvider(create: (_) => di.locator<WatchlistTVSeriesCubit>()),
      ],
      child: MaterialApp(
        title: 'Ditonton',
        theme: ThemeData.dark().copyWith(
          colorScheme: colorScheme,
          primaryColor: richBlack,
          scaffoldBackgroundColor: richBlack,
          textTheme: textTheme,
          drawerTheme: drawerTheme,
        ),
        home: const HomeMoviePage(),
        navigatorObservers: [
          routeObserver,
          if (Firebase.apps.isNotEmpty)
            FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
        ],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case HomeMoviePage.routeName:
              return MaterialPageRoute(builder: (_) => const HomeMoviePage());
            case HomeTVSeriesPage.routeName:
              return MaterialPageRoute(builder: (_) => const HomeTVSeriesPage());
            case PopularMoviesPage.routeName:
              return CupertinoPageRoute(
                builder: (_) => const PopularMoviesPage());
            case PopularTVSeriesPage.routeName:
              return CupertinoPageRoute(
                builder: (_) => const PopularTVSeriesPage());
            case TopRatedMoviesPage.routeName:
              return CupertinoPageRoute(builder: (_) => const TopRatedMoviesPage());
            case TopRatedTVSeriesPage.routeName:
              return CupertinoPageRoute(builder: (_) => const TopRatedTVSeriesPage());
            case MovieDetailPage.routeName:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case TVSeriesDetailPage.routeName:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TVSeriesDetailPage(id: id),
                settings: settings,
              );
            case SearchPage.routeName:
              return CupertinoPageRoute(builder: (_) => const SearchPage());
            case SearchTVSeriesPage.routeName:
              return CupertinoPageRoute(
                builder: (_) => const SearchTVSeriesPage());
            case WatchlistMoviesPage.routeName:
              return MaterialPageRoute(
                builder: (_) => const WatchlistMoviesPage());
            case WatchlistTVSeriesPage.routeName:
              return MaterialPageRoute(builder: (_) => const WatchlistTVSeriesPage());
            case AboutPage.routeName:
              return MaterialPageRoute(builder: (_) => const AboutPage());
            default:
              return MaterialPageRoute(
                builder: (_) {
                  return const Scaffold(body: Center(child: Text('Page not found :(')));
                },
              );
          }
        },
      ),
    );
  }
}
