import 'package:ditonton_core/ditonton_core.dart';
import 'package:ditonton_movie/ditonton_movie.dart';
import 'package:ditonton_tv_series/ditonton_tv_series.dart';
import 'package:ditonton/features/movie/presentation/bloc/movie_detail_cubit.dart';
import 'package:ditonton/features/movie/presentation/bloc/movie_search_cubit.dart';
import 'package:ditonton/features/movie/presentation/bloc/now_playing_movies_cubit.dart';
import 'package:ditonton/features/movie/presentation/bloc/popular_movies_cubit.dart';
import 'package:ditonton/features/movie/presentation/bloc/top_rated_movies_cubit.dart';
import 'package:ditonton/features/movie/presentation/bloc/watchlist_movies_cubit.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/on_the_air_tv_series_cubit.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/popular_tv_series_cubit.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/top_rated_tv_series_cubit.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/tv_series_detail_cubit.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/tv_series_search_cubit.dart';
import 'package:ditonton/features/tv_series/presentation/bloc/watchlist_tv_series_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final locator = GetIt.instance;

Future<void> init() async {
  // cubit
  locator.registerFactory(() => NowPlayingMoviesCubit(locator()));
  locator.registerFactory(() => PopularMoviesCubit(locator()));
  locator.registerFactory(() => TopRatedMoviesCubit(locator()));
  locator.registerFactory(
    () =>
        MovieDetailCubit(locator(), locator(), locator(), locator(), locator()),
  );
  locator.registerFactory(() => MovieSearchCubit(locator()));
  locator.registerFactory(() => WatchlistMoviesCubit(locator()));
  locator.registerFactory(() => OnTheAirTVSeriesCubit(locator()));
  locator.registerFactory(() => PopularTVSeriesCubit(locator()));
  locator.registerFactory(() => TopRatedTVSeriesCubit(locator()));
  locator.registerFactory(
    () => TVSeriesDetailCubit(
      locator(),
      locator(),
      locator(),
      locator(),
      locator(),
    ),
  );
  locator.registerFactory(() => TVSeriesSearchCubit(locator()));
  locator.registerFactory(() => WatchlistTVSeriesCubit(locator()));

  // use case
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));
  locator.registerLazySingleton(() => GetOnTheAirTVSeries(locator()));
  locator.registerLazySingleton(() => GetPopularTVSeries(locator()));
  locator.registerLazySingleton(() => GetTopRatedTVSeries(locator()));
  locator.registerLazySingleton(() => GetTVSeriesDetail(locator()));
  locator.registerLazySingleton(() => GetTVSeriesRecommendations(locator()));
  locator.registerLazySingleton(() => SearchTVSeries(locator()));
  locator.registerLazySingleton(() => GetTVWatchlistStatus(locator()));
  locator.registerLazySingleton(() => SaveTVWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveTVWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistTVSeries(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
  locator.registerLazySingleton<TVSeriesRepository>(
    () => TVSeriesRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(client: locator()),
  );
  locator.registerLazySingleton<MovieLocalDataSource>(
    () => MovieLocalDataSourceImpl(databaseHelper: locator()),
  );
  locator.registerLazySingleton<TVSeriesRemoteDataSource>(
    () => TVSeriesRemoteDataSourceImpl(client: locator()),
  );
  locator.registerLazySingleton<TVSeriesLocalDataSource>(
    () => TVSeriesLocalDataSourceImpl(databaseHelper: locator()),
  );

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // external
  final client = await SslPinningManager.createHttpClient();
  locator.registerLazySingleton<http.Client>(() => client);
}
