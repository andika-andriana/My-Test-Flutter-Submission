import 'dart:convert';

import 'package:ditonton_core/ditonton_core.dart';
import 'package:ditonton_tv_series/src/data/models/tv_series_detail_model.dart';
import 'package:ditonton_tv_series/src/data/models/tv_series_model.dart';
import 'package:ditonton_tv_series/src/data/models/tv_series_response.dart';
import 'package:http/http.dart' as http;

abstract class TVSeriesRemoteDataSource {
  Future<List<TVSeriesModel>> getOnTheAirTVSeries();
  Future<List<TVSeriesModel>> getPopularTVSeries();
  Future<List<TVSeriesModel>> getTopRatedTVSeries();
  Future<TVSeriesDetailResponse> getTVSeriesDetail(int id);
  Future<List<TVSeriesModel>> getTVSeriesRecommendations(int id);
  Future<List<TVSeriesModel>> searchTVSeries(String query);
}

class TVSeriesRemoteDataSourceImpl implements TVSeriesRemoteDataSource {
  TVSeriesRemoteDataSourceImpl({required this.client});

  static const _apiKey = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  static const _baseUrl = 'https://api.themoviedb.org/3';

  final http.Client client;

  @override
  Future<List<TVSeriesModel>> getOnTheAirTVSeries() async {
    final response = await client.get(
      Uri.parse('$_baseUrl/tv/on_the_air?$_apiKey'),
    );

    if (response.statusCode == 200) {
      return TVSeriesResponse.fromJson(json.decode(response.body)).tvSeriesList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TVSeriesModel>> getPopularTVSeries() async {
    final response = await client.get(
      Uri.parse('$_baseUrl/tv/popular?$_apiKey'),
    );

    if (response.statusCode == 200) {
      return TVSeriesResponse.fromJson(json.decode(response.body)).tvSeriesList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TVSeriesModel>> getTopRatedTVSeries() async {
    final response = await client.get(
      Uri.parse('$_baseUrl/tv/top_rated?$_apiKey'),
    );

    if (response.statusCode == 200) {
      return TVSeriesResponse.fromJson(json.decode(response.body)).tvSeriesList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TVSeriesDetailResponse> getTVSeriesDetail(int id) async {
    final response = await client.get(Uri.parse('$_baseUrl/tv/$id?$_apiKey'));

    if (response.statusCode == 200) {
      return TVSeriesDetailResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TVSeriesModel>> getTVSeriesRecommendations(int id) async {
    final response = await client.get(
      Uri.parse('$_baseUrl/tv/$id/recommendations?$_apiKey'),
    );

    if (response.statusCode == 200) {
      return TVSeriesResponse.fromJson(json.decode(response.body)).tvSeriesList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TVSeriesModel>> searchTVSeries(String query) async {
    final response = await client.get(
      Uri.parse('$_baseUrl/search/tv?$_apiKey&query=$query'),
    );

    if (response.statusCode == 200) {
      return TVSeriesResponse.fromJson(json.decode(response.body)).tvSeriesList;
    } else {
      throw ServerException();
    }
  }
}
