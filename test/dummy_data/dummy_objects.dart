import 'package:ditonton_core/ditonton_core.dart';
import 'package:ditonton_movie/ditonton_movie.dart';
import 'package:ditonton_tv_series/ditonton_tv_series.dart';

final testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final testMovieList = [testMovie];

final testMovieDetail = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  runtime: 120,
  title: 'title',
  voteAverage: 1,
  voteCount: 1,
);

final testWatchlistMovie = Movie.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieTable = MovieTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
};

final testTVSeries = TVSeries(
  backdropPath: '/path1.jpg',
  genreIds: [10765, 18],
  id: 1399,
  name: 'Game of Thrones',
  originCountry: ['US'],
  originalLanguage: 'en',
  originalName: 'Game of Thrones',
  overview:
      'Nine noble families fight for control over the lands of Westeros. ',
  popularity: 500.123,
  posterPath: '/poster1.jpg',
  voteAverage: 8.3,
  voteCount: 12000,
  firstAirDate: '2011-04-17',
);

final testTVSeriesList = [testTVSeries];

final testTVSeriesDetail = TVSeriesDetail(
  backdropPath: '/path1.jpg',
  genres: [Genre(id: 10765, name: 'Sci-Fi & Fantasy')],
  id: 1399,
  name: 'Game of Thrones',
  originalName: 'Game of Thrones',
  overview: 'Nine noble families fight for control over the lands of Westeros.',
  posterPath: '/poster1.jpg',
  voteAverage: 8.3,
  voteCount: 12000,
  firstAirDate: '2011-04-17',
  lastAirDate: '2019-05-19',
  numberOfSeasons: 8,
  numberOfEpisodes: 73,
  episodeRunTime: [60],
  seasons: const [
    Season(
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

final testWatchlistTVSeries = TVSeries.watchlist(
  id: 1399,
  overview: 'Nine noble families fight for control over the lands of Westeros.',
  posterPath: '/poster1.jpg',
  name: 'Game of Thrones',
);

final testTVSeriesTable = TVSeriesTable(
  id: 1399,
  name: 'Game of Thrones',
  posterPath: '/poster1.jpg',
  overview: 'Nine noble families fight for control over the lands of Westeros.',
);

final testTVSeriesMap = {
  'id': 1399,
  'title': 'Game of Thrones',
  'posterPath': '/poster1.jpg',
  'overview':
      'Nine noble families fight for control over the lands of Westeros.',
};
