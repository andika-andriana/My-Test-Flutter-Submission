import 'dart:convert';

import 'package:ditonton_core/ditonton_core.dart';
import 'package:ditonton_tv_series/ditonton_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

void main() {
  const apiKey = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const baseUrl = 'https://api.themoviedb.org/3';

  late TVSeriesRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TVSeriesRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get on the air tv series', () {
    final tTVList = TVSeriesResponse.fromJson(
      json.decode(readJson('dummy_data/tv_on_the_air.json')),
    ).tvSeriesList;

    test('should return list when response code is 200', () async {
      when(
        mockHttpClient.get(Uri.parse('$baseUrl/tv/on_the_air?$apiKey')),
      ).thenAnswer(
        (_) async =>
            http.Response(readJson('dummy_data/tv_on_the_air.json'), 200),
      );

      final result = await dataSource.getOnTheAirTVSeries();

      expect(result, tTVList);
    });

    test(
      'should throw ServerException when response code is not 200',
      () async {
        when(
          mockHttpClient.get(Uri.parse('$baseUrl/tv/on_the_air?$apiKey')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));

        final call = dataSource.getOnTheAirTVSeries();

        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get popular tv series', () {
    final tTVList = TVSeriesResponse.fromJson(
      json.decode(readJson('dummy_data/tv_popular.json')),
    ).tvSeriesList;

    test('should return list when response code is 200', () async {
      when(
        mockHttpClient.get(Uri.parse('$baseUrl/tv/popular?$apiKey')),
      ).thenAnswer(
        (_) async => http.Response(readJson('dummy_data/tv_popular.json'), 200),
      );

      final result = await dataSource.getPopularTVSeries();

      expect(result, tTVList);
    });

    test('should throw ServerException on error response', () async {
      when(
        mockHttpClient.get(Uri.parse('$baseUrl/tv/popular?$apiKey')),
      ).thenAnswer((_) async => http.Response('Not Found', 404));

      final call = dataSource.getPopularTVSeries();

      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get top rated tv series', () {
    final tTVList = TVSeriesResponse.fromJson(
      json.decode(readJson('dummy_data/tv_top_rated.json')),
    ).tvSeriesList;

    test('should return list when response code is 200', () async {
      when(
        mockHttpClient.get(Uri.parse('$baseUrl/tv/top_rated?$apiKey')),
      ).thenAnswer(
        (_) async =>
            http.Response(readJson('dummy_data/tv_top_rated.json'), 200),
      );

      final result = await dataSource.getTopRatedTVSeries();

      expect(result, tTVList);
    });

    test('should throw ServerException on error response', () async {
      when(
        mockHttpClient.get(Uri.parse('$baseUrl/tv/top_rated?$apiKey')),
      ).thenAnswer((_) async => http.Response('Not Found', 404));

      final call = dataSource.getTopRatedTVSeries();

      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get tv series detail', () {
    const tId = 1;
    final tTVDetail = TVSeriesDetailResponse.fromJson(
      json.decode(readJson('dummy_data/tv_series_detail.json')),
    );

    test('should return data when response code is 200', () async {
      when(
        mockHttpClient.get(Uri.parse('$baseUrl/tv/$tId?$apiKey')),
      ).thenAnswer(
        (_) async =>
            http.Response(readJson('dummy_data/tv_series_detail.json'), 200),
      );

      final result = await dataSource.getTVSeriesDetail(tId);

      expect(result, tTVDetail);
    });

    test(
      'should throw ServerException when response code is other than 200',
      () async {
        when(
          mockHttpClient.get(Uri.parse('$baseUrl/tv/$tId?$apiKey')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));

        final call = dataSource.getTVSeriesDetail(tId);

        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get recommendations', () {
    final tTVList = TVSeriesResponse.fromJson(
      json.decode(readJson('dummy_data/tv_series_recommendations.json')),
    ).tvSeriesList;
    const tId = 1;

    test('should return list when response code is 200', () async {
      when(
        mockHttpClient.get(
          Uri.parse('$baseUrl/tv/$tId/recommendations?$apiKey'),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          readJson('dummy_data/tv_series_recommendations.json'),
          200,
        ),
      );

      final result = await dataSource.getTVSeriesRecommendations(tId);

      expect(result, tTVList);
    });

    test(
      'should throw ServerException when response code is other than 200',
      () async {
        when(
          mockHttpClient.get(
            Uri.parse('$baseUrl/tv/$tId/recommendations?$apiKey'),
          ),
        ).thenAnswer((_) async => http.Response('Not Found', 404));

        final call = dataSource.getTVSeriesRecommendations(tId);

        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('search tv series', () {
    final tTVList = TVSeriesResponse.fromJson(
      json.decode(readJson('dummy_data/search_game_of_thrones_tv.json')),
    ).tvSeriesList;
    const tQuery = 'game of thrones';

    test('should return list when response code is 200', () async {
      when(
        mockHttpClient.get(
          Uri.parse('$baseUrl/search/tv?$apiKey&query=$tQuery'),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          readJson('dummy_data/search_game_of_thrones_tv.json'),
          200,
        ),
      );

      final result = await dataSource.searchTVSeries(tQuery);

      expect(result, tTVList);
    });

    test(
      'should throw ServerException when response code is not 200',
      () async {
        when(
          mockHttpClient.get(
            Uri.parse('$baseUrl/search/tv?$apiKey&query=$tQuery'),
          ),
        ).thenAnswer((_) async => http.Response('Not Found', 404));

        final call = dataSource.searchTVSeries(tQuery);

        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });
}
