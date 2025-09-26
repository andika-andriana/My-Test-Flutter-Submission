import 'package:ditonton_core/ditonton_core.dart';
import 'package:ditonton_tv_series/ditonton_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TVSeriesLocalDataSourceImpl dataSource;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    dataSource = TVSeriesLocalDataSourceImpl(
      databaseHelper: mockDatabaseHelper,
    );
  });

  group('save watchlist tv series', () {
    test(
      'should return success message when insert to database succeeds',
      () async {
        when(
          mockDatabaseHelper.insertTVWatchlist(testTVSeriesTable.toJson()),
        ).thenAnswer((_) async => 1);

        final result = await dataSource.insertWatchlist(testTVSeriesTable);

        expect(result, 'Added to Watchlist');
      },
    );

    test('should throw DatabaseException when insert fails', () async {
      when(
        mockDatabaseHelper.insertTVWatchlist(testTVSeriesTable.toJson()),
      ).thenThrow(Exception('error'));

      final call = dataSource.insertWatchlist(testTVSeriesTable);

      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('remove watchlist tv series', () {
    test('should return success message when remove succeeds', () async {
      when(
        mockDatabaseHelper.removeTVWatchlist(testTVSeriesTable.id),
      ).thenAnswer((_) async => 1);

      final result = await dataSource.removeWatchlist(testTVSeriesTable);

      expect(result, 'Removed from Watchlist');
    });

    test('should throw DatabaseException when remove fails', () async {
      when(
        mockDatabaseHelper.removeTVWatchlist(testTVSeriesTable.id),
      ).thenThrow(Exception('error'));

      final call = dataSource.removeWatchlist(testTVSeriesTable);

      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('get tv series by id', () {
    const tId = 1399;

    test('should return TVSeriesTable when data is found', () async {
      when(
        mockDatabaseHelper.getTVSeriesById(tId),
      ).thenAnswer((_) async => testTVSeriesMap);

      final result = await dataSource.getTVSeriesById(tId);

      expect(result, testTVSeriesTable);
    });

    test('should return null when data is not found', () async {
      when(
        mockDatabaseHelper.getTVSeriesById(tId),
      ).thenAnswer((_) async => null);

      final result = await dataSource.getTVSeriesById(tId);

      expect(result, null);
    });
  });

  group('get watchlist tv series', () {
    test('should return list from database', () async {
      when(
        mockDatabaseHelper.getWatchlistTVSeries(),
      ).thenAnswer((_) async => [testTVSeriesMap]);

      final result = await dataSource.getWatchlistTVSeries();

      expect(result, [testTVSeriesTable]);
    });
  });
}
