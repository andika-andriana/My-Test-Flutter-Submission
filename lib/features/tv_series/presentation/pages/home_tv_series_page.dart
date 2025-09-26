import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton_core/ditonton_core.dart';
import 'package:ditonton_tv_series/ditonton_tv_series.dart';
import 'package:ditonton/presentation/bloc/common/list_state.dart';
import 'package:ditonton/presentation/widgets/app_drawer.dart';
import 'package:ditonton/common/widgets/section_heading.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/on_the_air_tv_series_cubit.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/popular_tv_series_cubit.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/top_rated_tv_series_cubit.dart';
import 'package:ditonton/features/tv_series/presentation/pages/popular_tv_series_page.dart';
import 'package:ditonton/features/tv_series/presentation/pages/search_tv_series_page.dart';
import 'package:ditonton/features/tv_series/presentation/pages/top_rated_tv_series_page.dart';
import 'package:ditonton/features/tv_series/presentation/pages/tv_series_detail_page.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeTVSeriesPage extends StatefulWidget {
  static const routeName = homeTVSeriesRoute;

  const HomeTVSeriesPage({super.key});

  @override
  State<HomeTVSeriesPage> createState() => _HomeTVSeriesPageState();
}

class _HomeTVSeriesPageState extends State<HomeTVSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        // Log page view event
        _logPageView('tv_series_home');

        context.read<OnTheAirTVSeriesCubit>().fetchOnTheAir();
        context.read<PopularTVSeriesCubit>().fetchPopular();
        context.read<TopRatedTVSeriesCubit>().fetchTopRated();
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
      drawer: const AppDrawer(current: DrawerSection.tvSeries),
      appBar: AppBar(
        title: const Text('Ditonton - TV Series'),
        actions: [
          IconButton(
            onPressed: () async {
              // Log search button click event
              if (Firebase.apps.isNotEmpty) {
                await FirebaseAnalytics.instance.logEvent(
                  name: 'search_clicked',
                  parameters: {
                    'page_name': 'tv_series_home',
                    'search_type': 'tv_series',
                    'timestamp': DateTime.now().millisecondsSinceEpoch,
                  },
                );
              }
              if (context.mounted) {
                Navigator.pushNamed(context, SearchTVSeriesPage.routeName);
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
              Text('On The Air', style: heading6),
              BlocBuilder<OnTheAirTVSeriesCubit, ListState<TVSeries>>(
                builder: (context, state) {
                  if (state.status == RequestState.loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.status == RequestState.loaded) {
                    return TVSeriesPosterList(state.items);
                  } else if (state.status == RequestState.error) {
                    return Text(state.message);
                  }
                  return const SizedBox();
                },
              ),
              SectionHeading(
                title: 'Popular',
                onTap: () async {
                  // Log popular TV series section click event
                  if (Firebase.apps.isNotEmpty) {
                    await FirebaseAnalytics.instance.logEvent(
                      name: 'section_clicked',
                      parameters: {
                        'section_name': 'popular_tv_series',
                        'page_name': 'tv_series_home',
                        'timestamp': DateTime.now().millisecondsSinceEpoch,
                      },
                    );
                  }
                  if (context.mounted) {
                    Navigator.pushNamed(context, PopularTVSeriesPage.routeName);
                  }
                },
              ),
              BlocBuilder<PopularTVSeriesCubit, ListState<TVSeries>>(
                builder: (context, state) {
                  if (state.status == RequestState.loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.status == RequestState.loaded) {
                    return TVSeriesPosterList(state.items);
                  } else if (state.status == RequestState.error) {
                    return Text(state.message);
                  }
                  return const SizedBox();
                },
              ),
              SectionHeading(
                title: 'Top Rated',
                onTap: () async {
                  // Log top rated TV series section click event
                  if (Firebase.apps.isNotEmpty) {
                    await FirebaseAnalytics.instance.logEvent(
                      name: 'section_clicked',
                      parameters: {
                        'section_name': 'top_rated_tv_series',
                        'page_name': 'tv_series_home',
                        'timestamp': DateTime.now().millisecondsSinceEpoch,
                      },
                    );
                  }
                  if (context.mounted) {
                    Navigator.pushNamed(context, TopRatedTVSeriesPage.routeName);
                  }
                },
              ),
              BlocBuilder<TopRatedTVSeriesCubit, ListState<TVSeries>>(
                builder: (context, state) {
                  if (state.status == RequestState.loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.status == RequestState.loaded) {
                    return TVSeriesPosterList(state.items);
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

class TVSeriesPosterList extends StatelessWidget {
  const TVSeriesPosterList(this.tvSeries, {super.key});

  final List<TVSeries> tvSeries;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tvSeries.length,
        itemBuilder: (context, index) {
          final series = tvSeries[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () async {
                // Log TV series item click event
                if (Firebase.apps.isNotEmpty) {
                  await FirebaseAnalytics.instance.logEvent(
                    name: 'tv_series_clicked',
                    parameters: {
                      'tv_series_id': series.id,
                      'tv_series_name': series.name ?? 'Unknown',
                      'page_name': 'tv_series_home',
                      'section': 'on_the_air',
                      'timestamp': DateTime.now().millisecondsSinceEpoch,
                    },
                  );
                }
                if (context.mounted) {
                  Navigator.pushNamed(context, TVSeriesDetailPage.routeName, arguments: series.id);
                }
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$baseImageUrl${series.posterPath}',
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
