import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton_core/ditonton_core.dart';
import 'package:ditonton_movie/ditonton_movie.dart';
import 'package:ditonton/features/movie/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/features/movie/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/features/movie/presentation/pages/search_page.dart';
import 'package:ditonton/features/movie/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/presentation/widgets/app_drawer.dart';
import 'package:ditonton/presentation/bloc/common/list_state.dart';
import 'package:ditonton/common/widgets/section_heading.dart';
import 'package:ditonton/features/movie/presentation/bloc/now_playing_movies_cubit.dart';
import 'package:ditonton/features/movie/presentation/bloc/popular_movies_cubit.dart';
import 'package:ditonton/features/movie/presentation/bloc/top_rated_movies_cubit.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeMoviePage extends StatefulWidget {
  static const routeName = homeMovieRoute;

  const HomeMoviePage({super.key});

  @override
  State<HomeMoviePage> createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        // Log page view event
        _logPageView('movies_home');

        context.read<NowPlayingMoviesCubit>().fetchNowPlaying();
        context.read<PopularMoviesCubit>().fetchPopular();
        context.read<TopRatedMoviesCubit>().fetchTopRated();
      }
    });
  }

  /// Logs a page view event to Firebase Analytics
  Future<void> _logPageView(String pageName) async {
    if (Firebase.apps.isNotEmpty) {
      await FirebaseAnalytics.instance.logEvent(
        name: 'page_view',
        parameters: {'page_name': pageName, 'timestamp': DateTime.now().millisecondsSinceEpoch},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(current: DrawerSection.movies),
      appBar: AppBar(
        title: const Text('Ditonton'),
        actions: [
          IconButton(
            onPressed: () async {
              // Log search button click event
              if (Firebase.apps.isNotEmpty) {
                await FirebaseAnalytics.instance.logEvent(
                  name: 'search_clicked',
                  parameters: {
                    'page_name': 'movies_home',
                    'search_type': 'movies',
                    'timestamp': DateTime.now().millisecondsSinceEpoch,
                  },
                );
              }
              if (context.mounted) {
                Navigator.pushNamed(context, SearchPage.routeName);
              }
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Now Playing', style: heading6),
              BlocBuilder<NowPlayingMoviesCubit, ListState<Movie>>(
                builder: (context, state) {
                  if (state.status == RequestState.loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.status == RequestState.loaded) {
                    return MovieList(state.items);
                  } else if (state.status == RequestState.error) {
                    return Text(state.message);
                  }
                  return const SizedBox();
                },
              ),
              SectionHeading(
                title: 'Popular',
                onTap: () async {
                  // Log popular movies section click event
                  if (Firebase.apps.isNotEmpty) {
                    await FirebaseAnalytics.instance.logEvent(
                      name: 'section_clicked',
                      parameters: {
                        'section_name': 'popular_movies',
                        'page_name': 'movies_home',
                        'timestamp': DateTime.now().millisecondsSinceEpoch,
                      },
                    );
                  }
                  if (context.mounted) {
                    Navigator.pushNamed(context, PopularMoviesPage.routeName);
                  }
                },
              ),
              BlocBuilder<PopularMoviesCubit, ListState<Movie>>(
                builder: (context, state) {
                  if (state.status == RequestState.loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.status == RequestState.loaded) {
                    return MovieList(state.items);
                  } else if (state.status == RequestState.error) {
                    return Text(state.message);
                  }
                  return const SizedBox();
                },
              ),
              SectionHeading(
                title: 'Top Rated',
                onTap: () async {
                  // Log top rated movies section click event
                  if (Firebase.apps.isNotEmpty) {
                    await FirebaseAnalytics.instance.logEvent(
                      name: 'section_clicked',
                      parameters: {
                        'section_name': 'top_rated_movies',
                        'page_name': 'movies_home',
                        'timestamp': DateTime.now().millisecondsSinceEpoch,
                      },
                    );
                  }
                  if (context.mounted) {
                    Navigator.pushNamed(context, TopRatedMoviesPage.routeName);
                  }
                },
              ),
              BlocBuilder<TopRatedMoviesCubit, ListState<Movie>>(
                builder: (context, state) {
                  if (state.status == RequestState.loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.status == RequestState.loaded) {
                    return MovieList(state.items);
                  } else if (state.status == RequestState.error) {
                    return Text(state.message);
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MovieList extends StatelessWidget {
  const MovieList(this.movies, {super.key});

  final List<Movie> movies;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () async {
                // Log movie item click event
                if (Firebase.apps.isNotEmpty) {
                  await FirebaseAnalytics.instance.logEvent(
                    name: 'movie_clicked',
                    parameters: {
                      'movie_id': movie.id,
                      'movie_title': movie.title ?? 'Unknown',
                      'page_name': 'movies_home',
                      'section': 'now_playing',
                      'timestamp': DateTime.now().millisecondsSinceEpoch,
                    },
                  );
                }
                if (context.mounted) {
                  Navigator.pushNamed(context, MovieDetailPage.routeName, arguments: movie.id);
                }
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$baseImageUrl${movie.posterPath}',
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}
