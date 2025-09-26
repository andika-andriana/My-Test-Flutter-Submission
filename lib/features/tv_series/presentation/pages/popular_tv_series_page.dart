import 'package:ditonton_core/ditonton_core.dart';
import 'package:ditonton_tv_series/ditonton_tv_series.dart';
import 'package:ditonton/presentation/bloc/common/list_state.dart';
import 'package:ditonton/features/tv_series/presentation/widgets/tv_series_card_list.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/popular_tv_series_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularTVSeriesPage extends StatefulWidget {
  static const routeName = '/popular-tv-series';

  const PopularTVSeriesPage({super.key});

  @override
  State<PopularTVSeriesPage> createState() => _PopularTVSeriesPageState();
}

class _PopularTVSeriesPageState extends State<PopularTVSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<PopularTVSeriesCubit>().fetchPopular();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Popular TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularTVSeriesCubit, ListState<TVSeries>>(
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
              return Center(
                key: const Key('error_message'),
                child: Text(state.message),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
