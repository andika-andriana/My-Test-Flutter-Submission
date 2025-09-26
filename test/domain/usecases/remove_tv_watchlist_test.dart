import 'package:dartz/dartz.dart';
import 'package:ditonton_tv_series/ditonton_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late RemoveTVWatchlist usecase;
  late MockTVSeriesRepository mockRepository;

  setUp(() {
    mockRepository = MockTVSeriesRepository();
    usecase = RemoveTVWatchlist(mockRepository);
  });

  test('should remove tv series from watchlist', () async {
    when(
      mockRepository.removeWatchlist(testTVSeriesDetail),
    ).thenAnswer((_) async => Right('Removed from Watchlist'));

    final result = await usecase.execute(testTVSeriesDetail);

    expect(result, Right('Removed from Watchlist'));
  });
}
