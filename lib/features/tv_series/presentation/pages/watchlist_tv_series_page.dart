import 'package:ditonton_core/ditonton_core.dart';
import 'package:ditonton_tv_series/ditonton_tv_series.dart';
import 'package:ditonton/presentation/bloc/common/list_state.dart';
import 'package:ditonton/features/tv_series/presentation/widgets/tv_series_card_list.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/watchlist_tv_series_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistTVSeriesPage extends StatefulWidget {
  static const routeName = '/watchlist-tv-series';

  const WatchlistTVSeriesPage({super.key});

  @override
  State<WatchlistTVSeriesPage> createState() => _WatchlistTVSeriesPageState();
}

class _WatchlistTVSeriesPageState extends State<WatchlistTVSeriesPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<WatchlistTVSeriesCubit>().fetchWatchlist();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    context.read<WatchlistTVSeriesCubit>().fetchWatchlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Watchlist TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<WatchlistTVSeriesCubit, ListState<TVSeries>>(
          builder: (context, state) {
            if (state.status == RequestState.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.status == RequestState.loaded) {
              if (state.items.isEmpty) {
                return const Center(child: Text('Watchlist is empty'));
              }
              return ListView.builder(
                itemCount: state.items.length,
                itemBuilder: (_, index) {
                  final tv = state.items[index];
                  return TVSeriesCard(tv);
                },
              );
            } else if (state.status == RequestState.error) {
              return Center(key: const Key('error_message'), child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
