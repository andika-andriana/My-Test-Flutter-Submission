import 'package:ditonton_core/ditonton_core.dart';
import 'package:ditonton_movie/ditonton_movie.dart';
import 'package:ditonton/presentation/bloc/common/list_state.dart';
import 'package:ditonton/features/movie/presentation/bloc/movie_search_cubit.dart';
import 'package:ditonton/features/movie/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatelessWidget {
  static const routeName = '/search';

  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onSubmitted: (query) {
                context.read<MovieSearchCubit>().search(query);
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
            BlocBuilder<MovieSearchCubit, ListState<Movie>>(
              builder: (context, state) {
                if (state.status == RequestState.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.status == RequestState.loaded) {
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (_, index) {
                        final movie = state.items[index];
                        return MovieCard(movie);
                      },
                      itemCount: state.items.length,
                    ),
                  );
                } else if (state.status == RequestState.error) {
                  return Expanded(child: Text(state.message));
                }

                return const Expanded(child: SizedBox());
              },
            ),
          ],
        ),
      ),
    );
  }
}
