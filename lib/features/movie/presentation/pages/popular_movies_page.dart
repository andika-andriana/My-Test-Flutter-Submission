import 'package:ditonton_core/ditonton_core.dart';
import 'package:ditonton_movie/ditonton_movie.dart';
import 'package:ditonton/presentation/bloc/common/list_state.dart';
import 'package:ditonton/features/movie/presentation/bloc/popular_movies_cubit.dart';
import 'package:ditonton/features/movie/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularMoviesPage extends StatefulWidget {
  static const routeName = '/popular-movie';

  const PopularMoviesPage({super.key});

  @override
  State<PopularMoviesPage> createState() => _PopularMoviesPageState();
}

class _PopularMoviesPageState extends State<PopularMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<PopularMoviesCubit>().fetchPopular();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Popular Movies')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularMoviesCubit, ListState<Movie>>(
          builder: (context, state) {
            if (state.status == RequestState.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.status == RequestState.loaded) {
              return ListView.builder(
                itemBuilder: (_, index) {
                  final movie = state.items[index];
                  return MovieCard(movie);
                },
                itemCount: state.items.length,
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
