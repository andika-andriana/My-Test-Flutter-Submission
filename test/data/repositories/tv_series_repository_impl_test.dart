import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton_core/ditonton_core.dart';
import 'package:ditonton_tv_series/ditonton_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TVSeriesRepositoryImpl repository;
  late MockTVSeriesRemoteDataSource mockRemoteDataSource;
  late MockTVSeriesLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockTVSeriesRemoteDataSource();
    mockLocalDataSource = MockTVSeriesLocalDataSource();
    repository = TVSeriesRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  final tTVModel = TVSeriesModel(
    backdropPath: '/path1.jpg',
    firstAirDate: '2011-04-17',
    genreIds: [10765, 18],
    id: 1399,
    name: 'Game of Thrones',
    originCountry: const ['US'],
    originalLanguage: 'en',
    originalName: 'Game of Thrones',
    overview:
        'Nine noble families fight for control over the lands of Westeros.',
    popularity: 500.123,
    posterPath: '/poster1.jpg',
    voteAverage: 8.3,
    voteCount: 12000,
  );

  final tTv = TVSeries(
    backdropPath: '/path1.jpg',
    genreIds: [10765, 18],
    id: 1399,
    name: 'Game of Thrones',
    originCountry: const ['US'],
    originalLanguage: 'en',
    originalName: 'Game of Thrones',
    overview:
        'Nine noble families fight for control over the lands of Westeros.',
    popularity: 500.123,
    posterPath: '/poster1.jpg',
    voteAverage: 8.3,
    voteCount: 12000,
    firstAirDate: '2011-04-17',
  );

  final tTVModelList = <TVSeriesModel>[tTVModel];
  final tTVList = <TVSeries>[tTv];

  final tTVSeriesDetailResponse = TVSeriesDetailResponse(
    backdropPath: '/path1.jpg',
    genres: [GenreModel(id: 10765, name: 'Sci-Fi & Fantasy')],
    id: 1399,
    name: 'Game of Thrones',
    originalName: 'Game of Thrones',
    overview:
        'Nine noble families fight for control over the lands of Westeros.',
    posterPath: '/poster1.jpg',
    voteAverage: 8.3,
    voteCount: 12000,
    firstAirDate: '2011-04-17',
    lastAirDate: '2019-05-19',
    numberOfSeasons: 8,
    numberOfEpisodes: 73,
    episodeRunTime: const [60],
    seasons: const [
      SeasonModel(
        airDate: '2011-04-17',
        episodeCount: 10,
        id: 1,
        name: 'Season 1',
        overview: 'Winter is coming.',
        posterPath: '/season1.jpg',
        seasonNumber: 1,
      ),
    ],
    homepage: 'https://www.hbo.com/game-of-thrones',
    inProduction: false,
    tagline: 'Winter Is Coming.',
  );

  group('On The Air TV Series', () {
    test('should return remote data when call succeeds', () async {
      when(
        mockRemoteDataSource.getOnTheAirTVSeries(),
      ).thenAnswer((_) async => tTVModelList);

      final result = await repository.getOnTheAirTVSeries();

      verify(mockRemoteDataSource.getOnTheAirTVSeries());
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTVList);
    });

    test('should return server failure when call unsuccessful', () async {
      when(
        mockRemoteDataSource.getOnTheAirTVSeries(),
      ).thenThrow(ServerException());

      final result = await repository.getOnTheAirTVSeries();

      verify(mockRemoteDataSource.getOnTheAirTVSeries());
      expect(result, Left(ServerFailure('')));
    });

    test(
      'should return connection failure when network error occurs',
      () async {
        when(
          mockRemoteDataSource.getOnTheAirTVSeries(),
        ).thenThrow(SocketException('Failed to connect to the network'));

        final result = await repository.getOnTheAirTVSeries();

        verify(mockRemoteDataSource.getOnTheAirTVSeries());
        expect(
          result,
          Left(ConnectionFailure('Failed to connect to the network')),
        );
      },
    );
  });

  group('Popular TV Series', () {
    test('should return tv list when call succeeds', () async {
      when(
        mockRemoteDataSource.getPopularTVSeries(),
      ).thenAnswer((_) async => tTVModelList);

      final result = await repository.getPopularTVSeries();

      final resultList = result.getOrElse(() => []);
      expect(resultList, tTVList);
    });

    test('should return server failure when call unsuccessful', () async {
      when(
        mockRemoteDataSource.getPopularTVSeries(),
      ).thenThrow(ServerException());

      final result = await repository.getPopularTVSeries();

      expect(result, Left(ServerFailure('')));
    });

    test('should return connection failure on network issue', () async {
      when(
        mockRemoteDataSource.getPopularTVSeries(),
      ).thenThrow(SocketException('Failed to connect to the network'));

      final result = await repository.getPopularTVSeries();

      expect(
        result,
        Left(ConnectionFailure('Failed to connect to the network')),
      );
    });
  });

  group('Top Rated TV Series', () {
    test('should return tv list when call succeeds', () async {
      when(
        mockRemoteDataSource.getTopRatedTVSeries(),
      ).thenAnswer((_) async => tTVModelList);

      final result = await repository.getTopRatedTVSeries();

      final resultList = result.getOrElse(() => []);
      expect(resultList, tTVList);
    });

    test('should return server failure when call unsuccessful', () async {
      when(
        mockRemoteDataSource.getTopRatedTVSeries(),
      ).thenThrow(ServerException());

      final result = await repository.getTopRatedTVSeries();

      expect(result, Left(ServerFailure('')));
    });

    test('should return connection failure on network issue', () async {
      when(
        mockRemoteDataSource.getTopRatedTVSeries(),
      ).thenThrow(SocketException('Failed to connect to the network'));

      final result = await repository.getTopRatedTVSeries();

      expect(
        result,
        Left(ConnectionFailure('Failed to connect to the network')),
      );
    });
  });

  group('Get Tv Series Detail', () {
    const tId = 1;

    test('should return tv detail data when call succeeds', () async {
      when(
        mockRemoteDataSource.getTVSeriesDetail(tId),
      ).thenAnswer((_) async => tTVSeriesDetailResponse);

      final result = await repository.getTVSeriesDetail(tId);

      expect(result, Right(tTVSeriesDetailResponse.toEntity()));
    });

    test('should return Server Failure when call unsuccessful', () async {
      when(
        mockRemoteDataSource.getTVSeriesDetail(tId),
      ).thenThrow(ServerException());

      final result = await repository.getTVSeriesDetail(tId);

      expect(result, Left(ServerFailure('')));
    });

    test('should return Connection Failure when network error', () async {
      when(
        mockRemoteDataSource.getTVSeriesDetail(tId),
      ).thenThrow(SocketException('Failed to connect to the network'));

      final result = await repository.getTVSeriesDetail(tId);

      expect(
        result,
        Left(ConnectionFailure('Failed to connect to the network')),
      );
    });
  });

  group('Get Tv Series Recommendations', () {
    const tId = 1;

    test('should return data when call succeeds', () async {
      when(
        mockRemoteDataSource.getTVSeriesRecommendations(tId),
      ).thenAnswer((_) async => tTVModelList);

      final result = await repository.getTVSeriesRecommendations(tId);

      final resultList = result.getOrElse(() => []);
      expect(resultList, tTVList);
    });

    test('should return server failure when call unsuccessful', () async {
      when(
        mockRemoteDataSource.getTVSeriesRecommendations(tId),
      ).thenThrow(ServerException());

      final result = await repository.getTVSeriesRecommendations(tId);

      expect(result, Left(ServerFailure('')));
    });

    test('should return connection failure when network issue', () async {
      when(
        mockRemoteDataSource.getTVSeriesRecommendations(tId),
      ).thenThrow(SocketException('Failed to connect to the network'));

      final result = await repository.getTVSeriesRecommendations(tId);

      expect(
        result,
        Left(ConnectionFailure('Failed to connect to the network')),
      );
    });
  });

  group('Search Tv Series', () {
    const tQuery = 'game of thrones';

    test('should return data when call succeeds', () async {
      when(
        mockRemoteDataSource.searchTVSeries(tQuery),
      ).thenAnswer((_) async => tTVModelList);

      final result = await repository.searchTVSeries(tQuery);

      final resultList = result.getOrElse(() => []);
      expect(resultList, tTVList);
    });

    test('should return server failure when call unsuccessful', () async {
      when(
        mockRemoteDataSource.searchTVSeries(tQuery),
      ).thenThrow(ServerException());

      final result = await repository.searchTVSeries(tQuery);

      expect(result, Left(ServerFailure('')));
    });

    test('should return connection failure on network issue', () async {
      when(
        mockRemoteDataSource.searchTVSeries(tQuery),
      ).thenThrow(SocketException('Failed to connect to the network'));

      final result = await repository.searchTVSeries(tQuery);

      expect(
        result,
        Left(ConnectionFailure('Failed to connect to the network')),
      );
    });
  });

  group('Save Watchlist', () {
    test('should call local data source to save', () async {
      when(
        mockLocalDataSource.insertWatchlist(testTVSeriesTable),
      ).thenAnswer((_) async => 'Added to Watchlist');

      final result = await repository.saveWatchlist(testTVSeriesDetail);

      expect(result, Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when save fails', () async {
      when(
        mockLocalDataSource.insertWatchlist(testTVSeriesTable),
      ).thenThrow(DatabaseException('Failed to add watchlist'));

      final result = await repository.saveWatchlist(testTVSeriesDetail);

      expect(result, Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('Remove Watchlist', () {
    test('should call local data source to remove', () async {
      when(
        mockLocalDataSource.removeWatchlist(testTVSeriesTable),
      ).thenAnswer((_) async => 'Removed from Watchlist');

      final result = await repository.removeWatchlist(testTVSeriesDetail);

      expect(result, Right('Removed from Watchlist'));
    });

    test('should return DatabaseFailure when remove fails', () async {
      when(
        mockLocalDataSource.removeWatchlist(testTVSeriesTable),
      ).thenThrow(DatabaseException('Failed to remove watchlist'));

      final result = await repository.removeWatchlist(testTVSeriesDetail);

      expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('Get Watchlist Status', () {
    const tId = 1399;

    test('should return watchlist status', () async {
      when(
        mockLocalDataSource.getTVSeriesById(tId),
      ).thenAnswer((_) async => null);

      final result = await repository.isAddedToWatchlist(tId);

      expect(result, false);
    });
  });

  group('Get Watchlist Tv Series', () {
    test('should return list of watchlist', () async {
      when(
        mockLocalDataSource.getWatchlistTVSeries(),
      ).thenAnswer((_) async => [testTVSeriesTable]);

      final result = await repository.getWatchlistTVSeries();

      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistTVSeries]);
    });
  });
}
