import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton_core/ditonton_core.dart';
import 'package:ditonton_tv_series/ditonton_tv_series.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/tv_series_detail_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TVSeriesDetailPage extends StatefulWidget {
  static const routeName = '/tv-series-detail';

  const TVSeriesDetailPage({super.key, required this.id});

  final int id;

  @override
  State<TVSeriesDetailPage> createState() => _TVSeriesDetailPageState();
}

class _TVSeriesDetailPageState extends State<TVSeriesDetailPage> {
  @override
  void initState() {
    super.initState();
    final tvId = widget.id;
    Future.microtask(() {
      if (mounted) {
        final cubit = context.read<TVSeriesDetailCubit>();
        cubit.fetchDetail(tvId);
        cubit.loadWatchlistStatus(tvId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TVSeriesDetailCubit, TVSeriesDetailState>(
        builder: (context, state) {
          if (state.status == RequestState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == RequestState.loaded && state.tvSeries != null) {
            return SafeArea(
              child: TVDetailContent(
                tvSeries: state.tvSeries!,
                recommendations: state.recommendations,
                isAddedToWatchlist: state.isInWatchlist,
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

class TVDetailContent extends StatelessWidget {
  const TVDetailContent({
    super.key,
    required this.tvSeries,
    required this.recommendations,
    required this.isAddedToWatchlist,
    required this.recommendationStatus,
    required this.message,
  });

  final TVSeriesDetail tvSeries;
  final List<TVSeries> recommendations;
  final bool isAddedToWatchlist;
  final RequestState recommendationStatus;
  final String message;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: '$baseImageUrl${tvSeries.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            minChildSize: 0.25,
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
                            Text(tvSeries.name, style: heading5),
                            const SizedBox(height: 8),
                            _WatchlistButton(
                              isInWatchlist: isAddedToWatchlist,
                              onToggle: () async {
                                final cubit = context.read<TVSeriesDetailCubit>();
                                if (!isAddedToWatchlist) {
                                  await cubit.addToWatchlist(tvSeries);
                                } else {
                                  await cubit.removeFromWatchlist(tvSeries);
                                }
                                if (!context.mounted) return;
                                final watchlistMessage = cubit.state.watchlistMessage;
                                if (watchlistMessage ==
                                        TVSeriesDetailCubit.watchlistAddSuccessMessage ||
                                    watchlistMessage ==
                                        TVSeriesDetailCubit.watchlistRemoveSuccessMessage) {
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
                            ),
                            const SizedBox(height: 8),
                            Text(_showGenres(tvSeries.genres)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 16),
                                const SizedBox(width: 4),
                                Text(tvSeries.firstAirDate ?? '-'),
                                const SizedBox(width: 12),
                                const Icon(Icons.event_available, size: 16),
                                const SizedBox(width: 4),
                                Text('${tvSeries.numberOfSeasons} Seasons'),
                                const SizedBox(width: 12),
                                const Icon(Icons.confirmation_num, size: 16),
                                const SizedBox(width: 4),
                                Text('${tvSeries.numberOfEpisodes} Episodes'),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tvSeries.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) =>
                                      const Icon(Icons.star, color: Colors.amber),
                                  itemSize: 24,
                                ),
                                const SizedBox(width: 8),
                                Text(tvSeries.voteAverage.toString()),
                                const SizedBox(width: 12),
                                const Icon(Icons.people, size: 16),
                                const SizedBox(width: 4),
                                Text(tvSeries.voteCount.toString()),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.movie_creation, size: 16),
                                const SizedBox(width: 4),
                                Text(tvSeries.inProduction ? 'In Production' : 'Not In Production'),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text('Overview', style: heading6),
                            const SizedBox(height: 8),
                            Text(tvSeries.overview),
                            const SizedBox(height: 16),
                            if (tvSeries.seasons.isNotEmpty) ...[
                              Text('Seasons', style: heading6),
                              const SizedBox(height: 8),
                              _SeasonList(seasons: tvSeries.seasons),
                              const SizedBox(height: 16),
                            ],
                            Text('Recommendations', style: heading6),
                            _TVRecommendationSection(
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
                      child: Container(color: Colors.grey.shade300, height: 4, width: 48),
                    ),
                  ],
                ),
              );
            },
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

  String _showGenres(List genres) {
    return genres.map((genre) => genre.name).join(', ');
  }
}

class _WatchlistButton extends StatelessWidget {
  const _WatchlistButton({required this.isInWatchlist, required this.onToggle});

  final bool isInWatchlist;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onToggle,
      icon: Icon(isInWatchlist ? Icons.check : Icons.add),
      label: Text(isInWatchlist ? 'Remove from Watchlist' : 'Add to Watchlist'),
    );
  }
}

class _TVRecommendationSection extends StatelessWidget {
  const _TVRecommendationSection({
    required this.recommendations,
    required this.status,
    required this.errorMessage,
  });

  final List<TVSeries> recommendations;
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
            final tv = recommendations[index];
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: InkWell(
                onTap: () {
                  Navigator.pushReplacementNamed(
                    context,
                    TVSeriesDetailPage.routeName,
                    arguments: tv.id,
                  );
                },
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: CachedNetworkImage(
                    imageUrl: '$baseImageUrl${tv.posterPath}',
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

    return const SizedBox();
  }
}

class _SeasonList extends StatelessWidget {
  const _SeasonList({required this.seasons});

  final List<Season> seasons;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: seasons.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final season = seasons[index];
        return Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: grey),
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: season.posterPath != null
                      ? '$baseImageUrl${season.posterPath}'
                      : 'https://via.placeholder.com/80x120?text=No+Image',
                  width: 70,
                  height: 105,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const SizedBox(
                    width: 70,
                    height: 105,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) =>
                      const SizedBox(width: 70, height: 105, child: Icon(Icons.error)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(season.name, style: heading6),
                    const SizedBox(height: 4),
                    Text('Episodes: ${season.episodeCount}'),
                    if (season.airDate != null) Text('Air Date: ${season.airDate}'),
                    if (season.overview.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(season.overview, maxLines: 3, overflow: TextOverflow.ellipsis),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
