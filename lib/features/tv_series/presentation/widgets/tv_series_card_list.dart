import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton_core/ditonton_core.dart';
import 'package:ditonton_tv_series/ditonton_tv_series.dart';
import 'package:ditonton/features/tv_series/presentation/pages/tv_series_detail_page.dart';
import 'package:flutter/material.dart';

class TVSeriesCard extends StatelessWidget {
  const TVSeriesCard(this.tvSeries, {super.key});

  final TVSeries tvSeries;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            TVSeriesDetailPage.routeName,
            arguments: tvSeries.id,
          );
        },
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Card(
              child: Container(
                margin: const EdgeInsets.only(
                  left: 16 + 80 + 16,
                  bottom: 8,
                  right: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tvSeries.name ?? '-',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: heading6,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(tvSeries.voteAverage?.toStringAsFixed(1) ?? '-'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      tvSeries.overview ?? '-',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 16, bottom: 16),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: CachedNetworkImage(
                  imageUrl: '$baseImageUrl${tvSeries.posterPath}',
                  width: 80,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
