import 'package:ditonton_core/ditonton_core.dart';
import 'package:ditonton_movie/ditonton_movie.dart';
import 'package:ditonton/presentation/bloc/common/list_state.dart';
import 'package:ditonton/features/movie/presentation/bloc/top_rated_movies_cubit.dart';
import 'package:ditonton/features/movie/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopRatedMoviesPage extends StatefulWidget {
  static const routeName = '/top-rated-movie';

  const TopRatedMoviesPage({super.key});

  @override
  State<TopRatedMoviesPage> createState() => _TopRatedMoviesPageState();
}

class _TopRatedMoviesPageState extends State<TopRatedMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<TopRatedMoviesCubit>().fetchTopRated();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Top Rated Movies')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedMoviesCubit, ListState<Movie>>(
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
