import 'package:ditonton_core/ditonton_core.dart';
import 'package:ditonton_movie/ditonton_movie.dart';
import 'package:ditonton_tv_series/ditonton_tv_series.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks(
  [
    MovieRepository,
    MovieRemoteDataSource,
    MovieLocalDataSource,
    TVSeriesRepository,
    TVSeriesRemoteDataSource,
    TVSeriesLocalDataSource,
    DatabaseHelper,
    GetNowPlayingMovies,
    GetPopularMovies,
    GetTopRatedMovies,
    GetMovieDetail,
    GetMovieRecommendations,
    GetWatchListStatus,
    SaveWatchlist,
    RemoveWatchlist,
    GetWatchlistMovies,
    SearchMovies,
    GetOnTheAirTVSeries,
    GetPopularTVSeries,
    GetTopRatedTVSeries,
    GetTVSeriesDetail,
    GetTVSeriesRecommendations,
    GetTVWatchlistStatus,
    SaveTVWatchlist,
    RemoveTVWatchlist,
    GetWatchlistTVSeries,
    SearchTVSeries,
  ],
  customMocks: [MockSpec<http.Client>(as: #MockHttpClient)],
)
void main() {}
