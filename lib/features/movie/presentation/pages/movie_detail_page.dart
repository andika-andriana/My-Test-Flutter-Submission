import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton_core/ditonton_core.dart';
import 'package:ditonton_movie/ditonton_movie.dart';
import 'package:ditonton/features/movie/presentation/bloc/movie_detail_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieDetailPage extends StatefulWidget {
  static const routeName = '/detail';

  const MovieDetailPage({required this.id, super.key});

  final int id;

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    final movieId = widget.id;
    Future.microtask(() {
      if (mounted) {
        final cubit = context.read<MovieDetailCubit>();
        cubit.fetchDetail(movieId);
        cubit.loadWatchlistStatus(movieId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MovieDetailCubit, MovieDetailState>(
        builder: (context, state) {
          if (state.status == RequestState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == RequestState.loaded && state.movie != null) {
            return SafeArea(
              child: DetailContent(
                movie: state.movie!,
                recommendations: state.recommendations,
                isAddedWatchlist: state.isInWatchlist,
                recommendationStatus: state.recommendationsStatus,
                message: state.message,
              ),
            );
          } else if (state.status == RequestState.error) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  const DetailContent({
    required this.movie,
    required this.recommendations,
    required this.isAddedWatchlist,
    required this.recommendationStatus,
    required this.message,
    super.key,
  });

  final MovieDetail movie;
  final List<Movie> recommendations;
  final bool isAddedWatchlist;
  final RequestState recommendationStatus;
  final String message;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: '$baseImageUrl${movie.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: richBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(movie.title, style: heading5),
                            ElevatedButton(
                              onPressed: () async {
                                final cubit = context.read<MovieDetailCubit>();
                                if (!isAddedWatchlist) {
                                  await cubit.addToWatchlist(movie);
                                } else {
                                  await cubit.removeFromWatchlist(movie);
                                }

                                if (!context.mounted) {
                                  return;
                                }

                                final watchlistMessage = cubit.state.watchlistMessage;

                                if (watchlistMessage ==
                                        MovieDetailCubit.watchlistAddSuccessMessage ||
                                    watchlistMessage ==
                                        MovieDetailCubit.watchlistRemoveSuccessMessage) {
                                  ScaffoldMessenger.of(
                                    context,
                                  ).showSnackBar(SnackBar(content: Text(watchlistMessage)));
                                } else if (watchlistMessage.isNotEmpty) {
                                  showDialog<void>(
                                    context: context,
                                    builder: (dialogContext) =>
                                        AlertDialog(content: Text(watchlistMessage)),
                                  );
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(isAddedWatchlist ? Icons.check : Icons.add),
                                  const SizedBox(width: 8),
                                  const Text('Watchlist'),
                                ],
                              ),
                            ),
                            Text(_showGenres(movie.genres)),
                            Text(_showDuration(movie.runtime)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 16),
                                const SizedBox(width: 4),
                                Text(movie.releaseDate),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.person, size: 16),
                                const SizedBox(width: 4),
                                Text(movie.adult ? 'Adult' : 'Not Adult'),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: movie.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) =>
                                      const Icon(Icons.star, color: mikadoYellow),
                                  itemSize: 24,
                                ),
                                const SizedBox(width: 8),
                                Text(movie.voteAverage.toString()),
                                const SizedBox(width: 12),
                                const Icon(Icons.people, size: 16),
                                const SizedBox(width: 4),
                                Text(movie.voteCount.toString()),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text('Overview', style: heading6),
                            Text(movie.overview),
                            const SizedBox(height: 16),
                            Text('Recommendations', style: heading6),
                            _RecommendationSection(
                              recommendations: recommendations,
                              status: recommendationStatus,
                              errorMessage: message,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(color: Colors.white, height: 4, width: 48),
                    ),
                  ],
                ),
              );
            },
            minChildSize: 0.25,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: richBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    return genres.map((genre) => genre.name).join(', ');
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}

class _RecommendationSection extends StatelessWidget {
  const _RecommendationSection({
    required this.recommendations,
    required this.status,
    required this.errorMessage,
  });

  final List<Movie> recommendations;
  final RequestState status;
  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    if (status == RequestState.loading) {
      return const Center(child: CircularProgressIndicator());
    } else if (status == RequestState.error) {
      return Text(errorMessage);
    } else if (status == RequestState.loaded) {
      return SizedBox(
        height: 150,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: recommendations.length,
          itemBuilder: (context, index) {
            final movie = recommendations[index];
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: InkWell(
                onTap: () {
                  Navigator.pushReplacementNamed(
                    context,
                    MovieDetailPage.routeName,
                    arguments: movie.id,
                  );
                },
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: CachedNetworkImage(
                    imageUrl: '$baseImageUrl${movie.posterPath}',
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

    return const SizedBox.shrink();
  }
}
