import 'package:dartz/dartz.dart';
import 'package:ditonton_tv_series/ditonton_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late SaveTVWatchlist usecase;
  late MockTVSeriesRepository mockRepository;

  setUp(() {
    mockRepository = MockTVSeriesRepository();
    usecase = SaveTVWatchlist(mockRepository);
  });

  test('should save tv series to repository', () async {
    when(
      mockRepository.saveWatchlist(testTVSeriesDetail),
    ).thenAnswer((_) async => Right('Added to Watchlist'));

    final result = await usecase.execute(testTVSeriesDetail);

    expect(result, Right('Added to Watchlist'));
  });
}
