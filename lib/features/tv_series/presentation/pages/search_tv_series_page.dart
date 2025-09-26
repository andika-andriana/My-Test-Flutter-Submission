import 'package:ditonton_core/ditonton_core.dart';
import 'package:ditonton_tv_series/ditonton_tv_series.dart';
import 'package:ditonton/presentation/bloc/common/list_state.dart';
import 'package:ditonton/features/tv_series/presentation/widgets/tv_series_card_list.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/tv_series_search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchTVSeriesPage extends StatelessWidget {
  static const routeName = '/search-tv-series';

  const SearchTVSeriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onSubmitted: (query) {
                context.read<TVSeriesSearchCubit>().search(query);
              },
              decoration: const InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            const SizedBox(height: 16),
            Text('Search Result', style: heading6),
            const SizedBox(height: 8),
            Expanded(
              child: BlocBuilder<TVSeriesSearchCubit, ListState<TVSeries>>(
                builder: (context, state) {
                  if (state.status == RequestState.loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.status == RequestState.loaded) {
                    if (state.items.isEmpty) {
                      return const Center(child: Text('No results found'));
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: state.items.length,
                      itemBuilder: (_, index) {
                        final tv = state.items[index];
                        return TVSeriesCard(tv);
                      },
                    );
                  } else if (state.status == RequestState.error) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
