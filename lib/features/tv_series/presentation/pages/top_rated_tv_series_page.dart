import 'package:ditonton_core/ditonton_core.dart';
import 'package:ditonton_tv_series/ditonton_tv_series.dart';
import 'package:ditonton/presentation/bloc/common/list_state.dart';
import 'package:ditonton/features/tv_series/presentation/widgets/tv_series_card_list.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/top_rated_tv_series_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopRatedTVSeriesPage extends StatefulWidget {
  static const routeName = '/top-rated-tv-series';

  const TopRatedTVSeriesPage({super.key});

  @override
  State<TopRatedTVSeriesPage> createState() => _TopRatedTVSeriesPageState();
}

class _TopRatedTVSeriesPageState extends State<TopRatedTVSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<TopRatedTVSeriesCubit>().fetchTopRated();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Top Rated TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedTVSeriesCubit, ListState<TVSeries>>(
          builder: (context, state) {
            if (state.status == RequestState.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.status == RequestState.loaded) {
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
}
