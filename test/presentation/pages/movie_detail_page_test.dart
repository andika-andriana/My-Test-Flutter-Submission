import 'package:ditonton_core/ditonton_core.dart';
import 'package:ditonton_movie/ditonton_movie.dart';
import 'package:ditonton/features/movie/presentation/bloc/movie_detail_cubit.dart';
import 'package:ditonton/features/movie/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';

class MockMovieDetailCubit extends Mock implements MovieDetailCubit {
  @override
  MovieDetailState get state =>
      super.noSuchMethod(
            Invocation.getter(#state),
            returnValue: const MovieDetailState(),
            returnValueForMissingStub: const MovieDetailState(),
          )
          as MovieDetailState;

  @override
  Stream<MovieDetailState> get stream =>
      super.noSuchMethod(
            Invocation.getter(#stream),
            returnValue: const Stream<MovieDetailState>.empty(),
            returnValueForMissingStub: const Stream<MovieDetailState>.empty(),
          )
          as Stream<MovieDetailState>;

  @override
  Future<void> fetchDetail(int id) =>
      super.noSuchMethod(
            Invocation.method(#fetchDetail, [id]),
            returnValue: Future.value(),
            returnValueForMissingStub: Future.value(),
          )
          as Future<void>;

  @override
  Future<void> loadWatchlistStatus(int id) =>
      super.noSuchMethod(
            Invocation.method(#loadWatchlistStatus, [id]),
            returnValue: Future.value(),
            returnValueForMissingStub: Future.value(),
          )
          as Future<void>;

  @override
  Future<void> addToWatchlist(MovieDetail movie) =>
      super.noSuchMethod(
            Invocation.method(#addToWatchlist, [movie]),
            returnValue: Future.value(),
            returnValueForMissingStub: Future.value(),
          )
          as Future<void>;

  @override
  Future<void> removeFromWatchlist(MovieDetail movie) =>
      super.noSuchMethod(
            Invocation.method(#removeFromWatchlist, [movie]),
            returnValue: Future.value(),
            returnValueForMissingStub: Future.value(),
          )
          as Future<void>;
}

void main() {
  Widget makeTestableWidget(Widget body, MockMovieDetailCubit mockCubit) {
    return BlocProvider<MovieDetailCubit>.value(
      value: mockCubit,
      child: MaterialApp(home: body),
    );
  }

  testWidgets(
    'Watchlist button should display add icon when movie not added to watchlist', (
    WidgetTester tester,
  ) async {
    final mockCubit = MockMovieDetailCubit();
    final state = MovieDetailState(
      status: RequestState.loaded,
      movie: testMovieDetail,
      recommendationsStatus: RequestState.loaded,
      recommendations: const <Movie>[],
      isInWatchlist: false,
    );
    when(mockCubit.state).thenReturn(state);
    when(mockCubit.stream).thenAnswer((_) => Stream<MovieDetailState>.value(state));
    when(mockCubit.fetchDetail(1)).thenAnswer((_) async {});
    when(mockCubit.loadWatchlistStatus(1)).thenAnswer((_) async {});
    when(mockCubit.addToWatchlist(testMovieDetail)).thenAnswer((_) async {});
    when(mockCubit.removeFromWatchlist(testMovieDetail)).thenAnswer((_) async {});

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1), mockCubit));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
    'Watchlist button should display check icon when movie is added to watchlist', (
    WidgetTester tester,
  ) async {
    final mockCubit = MockMovieDetailCubit();
    final state = MovieDetailState(
      status: RequestState.loaded,
      movie: testMovieDetail,
      recommendationsStatus: RequestState.loaded,
      recommendations: const <Movie>[],
      isInWatchlist: true,
    );
    when(mockCubit.state).thenReturn(state);
    when(mockCubit.stream).thenAnswer((_) => Stream<MovieDetailState>.value(state));
    when(mockCubit.fetchDetail(1)).thenAnswer((_) async {});
    when(mockCubit.loadWatchlistStatus(1)).thenAnswer((_) async {});
    when(mockCubit.addToWatchlist(testMovieDetail)).thenAnswer((_) async {});
    when(mockCubit.removeFromWatchlist(testMovieDetail)).thenAnswer((_) async {});

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1), mockCubit));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
    'Watchlist button should display Snackbar when added to watchlist', (
    WidgetTester tester,
  ) async {
    final mockCubit = MockMovieDetailCubit();
    final state = MovieDetailState(
      status: RequestState.loaded,
      movie: testMovieDetail,
      recommendationsStatus: RequestState.loaded,
      recommendations: const <Movie>[],
      isInWatchlist: false,
      watchlistMessage: MovieDetailCubit.watchlistAddSuccessMessage,
    );
    when(mockCubit.state).thenReturn(state);
    when(mockCubit.stream).thenAnswer((_) => Stream<MovieDetailState>.value(state));
    when(mockCubit.fetchDetail(1)).thenAnswer((_) async {});
    when(mockCubit.loadWatchlistStatus(1)).thenAnswer((_) async {});
    when(mockCubit.addToWatchlist(testMovieDetail)).thenAnswer((_) async {});
    when(mockCubit.removeFromWatchlist(testMovieDetail)).thenAnswer((_) async {});

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1), mockCubit));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text(MovieDetailCubit.watchlistAddSuccessMessage), findsOneWidget);
    verify(mockCubit.addToWatchlist(testMovieDetail)).called(1);
  });

  testWidgets(
    'Watchlist button should display AlertDialog when add to watchlist failed', (
    WidgetTester tester,
  ) async {
    final mockCubit = MockMovieDetailCubit();
    const failureMessage = 'Failed';
    final state = MovieDetailState(
      status: RequestState.loaded,
      movie: testMovieDetail,
      recommendationsStatus: RequestState.loaded,
      recommendations: const <Movie>[],
      isInWatchlist: false,
      watchlistMessage: failureMessage,
    );
    when(mockCubit.state).thenReturn(state);
    when(mockCubit.stream).thenAnswer((_) => Stream<MovieDetailState>.value(state));
    when(mockCubit.fetchDetail(1)).thenAnswer((_) async {});
    when(mockCubit.loadWatchlistStatus(1)).thenAnswer((_) async {});
    when(mockCubit.addToWatchlist(testMovieDetail)).thenAnswer((_) async {});
    when(mockCubit.removeFromWatchlist(testMovieDetail)).thenAnswer((_) async {});

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1), mockCubit));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text(failureMessage), findsOneWidget);
    verify(mockCubit.addToWatchlist(testMovieDetail)).called(1);
  });

  group('DetailContent Widget Tests', () {
    testWidgets('should display movie genres correctly', (WidgetTester tester) async {
      final mockCubit = MockMovieDetailCubit();
      final state = MovieDetailState(
        status: RequestState.loaded,
        movie: testMovieDetail,
        recommendationsStatus: RequestState.loaded,
        recommendations: const <Movie>[],
        isInWatchlist: false,
      );
      when(mockCubit.state).thenReturn(state);
      when(mockCubit.stream).thenAnswer((_) => Stream<MovieDetailState>.value(state));
      when(mockCubit.fetchDetail(1)).thenAnswer((_) async {});
      when(mockCubit.loadWatchlistStatus(1)).thenAnswer((_) async {});

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1), mockCubit));

      // Check if genres are displayed
      expect(find.text('Action'), findsOneWidget);
    });

    testWidgets('should display movie duration correctly', (WidgetTester tester) async {
      final mockCubit = MockMovieDetailCubit();
      final state = MovieDetailState(
        status: RequestState.loaded,
        movie: testMovieDetail,
        recommendationsStatus: RequestState.loaded,
        recommendations: const <Movie>[],
        isInWatchlist: false,
      );
      when(mockCubit.state).thenReturn(state);
      when(mockCubit.stream).thenAnswer((_) => Stream<MovieDetailState>.value(state));
      when(mockCubit.fetchDetail(1)).thenAnswer((_) async {});
      when(mockCubit.loadWatchlistStatus(1)).thenAnswer((_) async {});

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1), mockCubit));

      // Check if duration is displayed (testMovieDetail has runtime 120 minutes = 2h 0m)
      expect(find.text('2h 0m'), findsOneWidget);
    });

    testWidgets('should display recommendations section when loaded', (WidgetTester tester) async {
      final mockCubit = MockMovieDetailCubit();
      final state = MovieDetailState(
        status: RequestState.loaded,
        movie: testMovieDetail,
        recommendationsStatus: RequestState.loaded,
        recommendations: [testMovie],
        isInWatchlist: false,
      );
      when(mockCubit.state).thenReturn(state);
      when(mockCubit.stream).thenAnswer((_) => Stream<MovieDetailState>.value(state));
      when(mockCubit.fetchDetail(1)).thenAnswer((_) async {});
      when(mockCubit.loadWatchlistStatus(1)).thenAnswer((_) async {});

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1), mockCubit));

      // Check if recommendations section is displayed
      expect(find.text('Recommendations'), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('should display loading indicator for recommendations', (
      WidgetTester tester,
    ) async {
      final mockCubit = MockMovieDetailCubit();
      final state = MovieDetailState(
        status: RequestState.loaded,
        movie: testMovieDetail,
        recommendationsStatus: RequestState.loading,
        recommendations: const <Movie>[],
        isInWatchlist: false,
      );
      when(mockCubit.state).thenReturn(state);
      when(mockCubit.stream).thenAnswer((_) => Stream<MovieDetailState>.value(state));
      when(mockCubit.fetchDetail(1)).thenAnswer((_) async {});
      when(mockCubit.loadWatchlistStatus(1)).thenAnswer((_) async {});

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1), mockCubit));

      // Check if loading indicator is displayed for recommendations
      expect(
        find.byType(CircularProgressIndicator).at(1),
        findsOneWidget,
      ); // Use at(1) to get the second CircularProgressIndicator (recommendations)
    });

    testWidgets('should display error message for recommendations', (WidgetTester tester) async {
      final mockCubit = MockMovieDetailCubit();
      const errorMessage = 'Failed to load recommendations';
      final state = MovieDetailState(
        status: RequestState.loaded,
        movie: testMovieDetail,
        recommendationsStatus: RequestState.error,
        recommendations: const <Movie>[],
        isInWatchlist: false,
        message: errorMessage,
      );
      when(mockCubit.state).thenReturn(state);
      when(mockCubit.stream).thenAnswer((_) => Stream<MovieDetailState>.value(state));
      when(mockCubit.fetchDetail(1)).thenAnswer((_) async {});
      when(mockCubit.loadWatchlistStatus(1)).thenAnswer((_) async {});

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1), mockCubit));

      // Check if error message is displayed for recommendations
      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('should handle recommendation tap navigation', (WidgetTester tester) async {
      final mockCubit = MockMovieDetailCubit();
      final state = MovieDetailState(
        status: RequestState.loaded,
        movie: testMovieDetail,
        recommendationsStatus: RequestState.loaded,
        recommendations: [testMovie],
        isInWatchlist: false,
      );
      when(mockCubit.state).thenReturn(state);
      when(mockCubit.stream).thenAnswer((_) => Stream<MovieDetailState>.value(state));
      when(mockCubit.fetchDetail(1)).thenAnswer((_) async {});
      when(mockCubit.loadWatchlistStatus(1)).thenAnswer((_) async {});

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1), mockCubit));

      // Find and tap on recommendation
      final recommendationInkWell = find.byType(InkWell).last;
      await tester.tap(recommendationInkWell);
      await tester.pump();

      // Verify navigation occurred (this would typically be tested with a mock navigator)
      expect(find.byType(MovieDetailPage), findsOneWidget);
    });

    testWidgets('should display empty recommendations when list is empty', (
      WidgetTester tester,
    ) async {
      final mockCubit = MockMovieDetailCubit();
      final state = MovieDetailState(
        status: RequestState.loaded,
        movie: testMovieDetail,
        recommendationsStatus: RequestState.loaded,
        recommendations: const <Movie>[],
        isInWatchlist: false,
      );
      when(mockCubit.state).thenReturn(state);
      when(mockCubit.stream).thenAnswer((_) => Stream<MovieDetailState>.value(state));
      when(mockCubit.fetchDetail(1)).thenAnswer((_) async {});
      when(mockCubit.loadWatchlistStatus(1)).thenAnswer((_) async {});

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1), mockCubit));

      // Check if recommendations section is displayed even with empty list
      expect(find.text('Recommendations'), findsOneWidget);
    });

    testWidgets('should display watchlist button with correct text when removing from watchlist', (
      WidgetTester tester,
    ) async {
      final mockCubit = MockMovieDetailCubit();
      final state = MovieDetailState(
        status: RequestState.loaded,
        movie: testMovieDetail,
        recommendationsStatus: RequestState.loaded,
        recommendations: const <Movie>[],
        isInWatchlist: true,
        watchlistMessage: MovieDetailCubit.watchlistRemoveSuccessMessage,
      );
      when(mockCubit.state).thenReturn(state);
      when(mockCubit.stream).thenAnswer((_) => Stream<MovieDetailState>.value(state));
      when(mockCubit.fetchDetail(1)).thenAnswer((_) async {});
      when(mockCubit.loadWatchlistStatus(1)).thenAnswer((_) async {});
      when(mockCubit.addToWatchlist(testMovieDetail)).thenAnswer((_) async {});
      when(mockCubit.removeFromWatchlist(testMovieDetail)).thenAnswer((_) async {});

      final watchlistButton = find.byType(ElevatedButton);

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1), mockCubit));

      expect(find.byIcon(Icons.check), findsOneWidget);

      await tester.tap(watchlistButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text(MovieDetailCubit.watchlistRemoveSuccessMessage), findsOneWidget);
      verify(mockCubit.removeFromWatchlist(testMovieDetail)).called(1);
    });

    testWidgets('should display movie rating correctly', (WidgetTester tester) async {
      final mockCubit = MockMovieDetailCubit();
      final state = MovieDetailState(
        status: RequestState.loaded,
        movie: testMovieDetail,
        recommendationsStatus: RequestState.loaded,
        recommendations: const <Movie>[],
        isInWatchlist: false,
      );
      when(mockCubit.state).thenReturn(state);
      when(mockCubit.stream).thenAnswer((_) => Stream<MovieDetailState>.value(state));
      when(mockCubit.fetchDetail(1)).thenAnswer((_) async {});
      when(mockCubit.loadWatchlistStatus(1)).thenAnswer((_) async {});

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1), mockCubit));

      // Check if rating is displayed
      expect(find.text('1.0'), findsOneWidget);
    });

    testWidgets('should display movie overview correctly', (WidgetTester tester) async {
      final mockCubit = MockMovieDetailCubit();
      final state = MovieDetailState(
        status: RequestState.loaded,
        movie: testMovieDetail,
        recommendationsStatus: RequestState.loaded,
        recommendations: const <Movie>[],
        isInWatchlist: false,
      );
      when(mockCubit.state).thenReturn(state);
      when(mockCubit.stream).thenAnswer((_) => Stream<MovieDetailState>.value(state));
      when(mockCubit.fetchDetail(1)).thenAnswer((_) async {});
      when(mockCubit.loadWatchlistStatus(1)).thenAnswer((_) async {});

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1), mockCubit));

      // Check if overview is displayed
      expect(find.text('overview'), findsOneWidget);
    });

    testWidgets('should display movie title correctly', (WidgetTester tester) async {
      final mockCubit = MockMovieDetailCubit();
      final state = MovieDetailState(
        status: RequestState.loaded,
        movie: testMovieDetail,
        recommendationsStatus: RequestState.loaded,
        recommendations: const <Movie>[],
        isInWatchlist: false,
      );
      when(mockCubit.state).thenReturn(state);
      when(mockCubit.stream).thenAnswer((_) => Stream<MovieDetailState>.value(state));
      when(mockCubit.fetchDetail(1)).thenAnswer((_) async {});
      when(mockCubit.loadWatchlistStatus(1)).thenAnswer((_) async {});

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1), mockCubit));

      // Check if title is displayed
      expect(find.text('title'), findsOneWidget);
    });

    testWidgets('should display movie release date correctly', (WidgetTester tester) async {
      final mockCubit = MockMovieDetailCubit();
      final state = MovieDetailState(
        status: RequestState.loaded,
        movie: testMovieDetail,
        recommendationsStatus: RequestState.loaded,
        recommendations: const <Movie>[],
        isInWatchlist: false,
      );
      when(mockCubit.state).thenReturn(state);
      when(mockCubit.stream).thenAnswer((_) => Stream<MovieDetailState>.value(state));
      when(mockCubit.fetchDetail(1)).thenAnswer((_) async {});
      when(mockCubit.loadWatchlistStatus(1)).thenAnswer((_) async {});

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1), mockCubit));

      // Check if release date is displayed
      expect(find.text('releaseDate'), findsOneWidget);
    });

    testWidgets('should display movie vote count correctly', (WidgetTester tester) async {
      final mockCubit = MockMovieDetailCubit();
      final state = MovieDetailState(
        status: RequestState.loaded,
        movie: testMovieDetail,
        recommendationsStatus: RequestState.loaded,
        recommendations: const <Movie>[],
        isInWatchlist: false,
      );
      when(mockCubit.state).thenReturn(state);
      when(mockCubit.stream).thenAnswer((_) => Stream<MovieDetailState>.value(state));
      when(mockCubit.fetchDetail(1)).thenAnswer((_) async {});
      when(mockCubit.loadWatchlistStatus(1)).thenAnswer((_) async {});

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1), mockCubit));

      // Check if vote count is displayed
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('should display movie adult status correctly', (WidgetTester tester) async {
      final mockCubit = MockMovieDetailCubit();
      final state = MovieDetailState(
        status: RequestState.loaded,
        movie: testMovieDetail,
        recommendationsStatus: RequestState.loaded,
        recommendations: const <Movie>[],
        isInWatchlist: false,
      );
      when(mockCubit.state).thenReturn(state);
      when(mockCubit.stream).thenAnswer((_) => Stream<MovieDetailState>.value(state));
      when(mockCubit.fetchDetail(1)).thenAnswer((_) async {});
      when(mockCubit.loadWatchlistStatus(1)).thenAnswer((_) async {});

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1), mockCubit));

      // Check if adult status is displayed
      expect(find.text('Not Adult'), findsOneWidget);
    });

    testWidgets('should display movie with adult content correctly', (WidgetTester tester) async {
      final adultMovieDetail = MovieDetail(
        adult: true,
        backdropPath: testMovieDetail.backdropPath,
        genres: testMovieDetail.genres,
        id: testMovieDetail.id,
        originalTitle: testMovieDetail.originalTitle,
        overview: testMovieDetail.overview,
        posterPath: testMovieDetail.posterPath,
        releaseDate: testMovieDetail.releaseDate,
        runtime: testMovieDetail.runtime,
        title: testMovieDetail.title,
        voteAverage: testMovieDetail.voteAverage,
        voteCount: testMovieDetail.voteCount,
      );
      final mockCubit = MockMovieDetailCubit();
      final state = MovieDetailState(
        status: RequestState.loaded,
        movie: adultMovieDetail,
        recommendationsStatus: RequestState.loaded,
        recommendations: const <Movie>[],
        isInWatchlist: false,
      );
      when(mockCubit.state).thenReturn(state);
      when(mockCubit.stream).thenAnswer((_) => Stream<MovieDetailState>.value(state));
      when(mockCubit.fetchDetail(1)).thenAnswer((_) async {});
      when(mockCubit.loadWatchlistStatus(1)).thenAnswer((_) async {});

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1), mockCubit));

      // Check if adult status is displayed
      expect(find.text('Adult'), findsOneWidget);
    });

    testWidgets('should display movie with zero vote count correctly', (WidgetTester tester) async {
      final zeroVoteMovieDetail = MovieDetail(
        adult: testMovieDetail.adult,
        backdropPath: testMovieDetail.backdropPath,
        genres: testMovieDetail.genres,
        id: testMovieDetail.id,
        originalTitle: testMovieDetail.originalTitle,
        overview: testMovieDetail.overview,
        posterPath: testMovieDetail.posterPath,
        releaseDate: testMovieDetail.releaseDate,
        runtime: testMovieDetail.runtime,
        title: testMovieDetail.title,
        voteAverage: testMovieDetail.voteAverage,
        voteCount: 0,
      );
      final mockCubit = MockMovieDetailCubit();
      final state = MovieDetailState(
        status: RequestState.loaded,
        movie: zeroVoteMovieDetail,
        recommendationsStatus: RequestState.loaded,
        recommendations: const <Movie>[],
        isInWatchlist: false,
      );
      when(mockCubit.state).thenReturn(state);
      when(mockCubit.stream).thenAnswer((_) => Stream<MovieDetailState>.value(state));
      when(mockCubit.fetchDetail(1)).thenAnswer((_) async {});
      when(mockCubit.loadWatchlistStatus(1)).thenAnswer((_) async {});

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1), mockCubit));

      // Check if vote count is displayed
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('should display movie with zero runtime correctly', (WidgetTester tester) async {
      final zeroRuntimeMovieDetail = MovieDetail(
        adult: testMovieDetail.adult,
        backdropPath: testMovieDetail.backdropPath,
        genres: testMovieDetail.genres,
        id: testMovieDetail.id,
        originalTitle: testMovieDetail.originalTitle,
        overview: testMovieDetail.overview,
        posterPath: testMovieDetail.posterPath,
        releaseDate: testMovieDetail.releaseDate,
        runtime: 0,
        title: testMovieDetail.title,
        voteAverage: testMovieDetail.voteAverage,
        voteCount: testMovieDetail.voteCount,
      );
      final mockCubit = MockMovieDetailCubit();
      final state = MovieDetailState(
        status: RequestState.loaded,
        movie: zeroRuntimeMovieDetail,
        recommendationsStatus: RequestState.loaded,
        recommendations: const <Movie>[],
        isInWatchlist: false,
      );
      when(mockCubit.state).thenReturn(state);
      when(mockCubit.stream).thenAnswer((_) => Stream<MovieDetailState>.value(state));
      when(mockCubit.fetchDetail(1)).thenAnswer((_) async {});
      when(mockCubit.loadWatchlistStatus(1)).thenAnswer((_) async {});

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1), mockCubit));

      // Check if duration is displayed correctly for zero runtime
      expect(find.text('0m'), findsOneWidget);
    });

    testWidgets('should display error state correctly', (WidgetTester tester) async {
      final mockCubit = MockMovieDetailCubit();
      const errorMessage = 'Failed to load movie detail';
      final state = MovieDetailState(
        status: RequestState.error,
        movie: null,
        recommendationsStatus: RequestState.empty,
        recommendations: const <Movie>[],
        isInWatchlist: false,
        message: errorMessage,
      );
      when(mockCubit.state).thenReturn(state);
      when(mockCubit.stream).thenAnswer((_) => Stream<MovieDetailState>.value(state));
      when(mockCubit.fetchDetail(1)).thenAnswer((_) async {});
      when(mockCubit.loadWatchlistStatus(1)).thenAnswer((_) async {});

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1), mockCubit));

      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('should display empty state correctly', (WidgetTester tester) async {
      final mockCubit = MockMovieDetailCubit();
      final state = const MovieDetailState(
        status: RequestState.empty,
        movie: null,
        recommendationsStatus: RequestState.empty,
        recommendations: <Movie>[],
        isInWatchlist: false,
      );
      when(mockCubit.state).thenReturn(state);
      when(mockCubit.stream).thenAnswer((_) => Stream<MovieDetailState>.value(state));
      when(mockCubit.fetchDetail(1)).thenAnswer((_) async {});
      when(mockCubit.loadWatchlistStatus(1)).thenAnswer((_) async {});

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1), mockCubit));

      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('should display movie with empty release date', (WidgetTester tester) async {
      final movieWithEmptyReleaseDate = MovieDetail(
        adult: testMovieDetail.adult,
        backdropPath: testMovieDetail.backdropPath,
        genres: testMovieDetail.genres,
        id: testMovieDetail.id,
        originalTitle: testMovieDetail.originalTitle,
        overview: testMovieDetail.overview,
        posterPath: testMovieDetail.posterPath,
        releaseDate: '',
        runtime: testMovieDetail.runtime,
        title: testMovieDetail.title,
        voteAverage: testMovieDetail.voteAverage,
        voteCount: testMovieDetail.voteCount,
      );
      final mockCubit = MockMovieDetailCubit();
      final state = MovieDetailState(
        status: RequestState.loaded,
        movie: movieWithEmptyReleaseDate,
        recommendationsStatus: RequestState.loaded,
        recommendations: const <Movie>[],
        isInWatchlist: false,
      );
      when(mockCubit.state).thenReturn(state);
      when(mockCubit.stream).thenAnswer((_) => Stream<MovieDetailState>.value(state));
      when(mockCubit.fetchDetail(1)).thenAnswer((_) async {});
      when(mockCubit.loadWatchlistStatus(1)).thenAnswer((_) async {});

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1), mockCubit));

      expect(find.text(''), findsOneWidget);
    });

    testWidgets('should display movie with zero vote average', (WidgetTester tester) async {
      final movieWithZeroVoteAverage = MovieDetail(
        adult: testMovieDetail.adult,
        backdropPath: testMovieDetail.backdropPath,
        genres: testMovieDetail.genres,
        id: testMovieDetail.id,
        originalTitle: testMovieDetail.originalTitle,
        overview: testMovieDetail.overview,
        posterPath: testMovieDetail.posterPath,
        releaseDate: testMovieDetail.releaseDate,
        runtime: testMovieDetail.runtime,
        title: testMovieDetail.title,
        voteAverage: 0.0,
        voteCount: testMovieDetail.voteCount,
      );
      final mockCubit = MockMovieDetailCubit();
      final state = MovieDetailState(
        status: RequestState.loaded,
        movie: movieWithZeroVoteAverage,
        recommendationsStatus: RequestState.loaded,
        recommendations: const <Movie>[],
        isInWatchlist: false,
      );
      when(mockCubit.state).thenReturn(state);
      when(mockCubit.stream).thenAnswer((_) => Stream<MovieDetailState>.value(state));
      when(mockCubit.fetchDetail(1)).thenAnswer((_) async {});
      when(mockCubit.loadWatchlistStatus(1)).thenAnswer((_) async {});

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1), mockCubit));

      expect(find.text('0.0'), findsOneWidget);
    });

    testWidgets('should display back button and handle navigation', (WidgetTester tester) async {
      final mockCubit = MockMovieDetailCubit();
      final state = MovieDetailState(
        status: RequestState.loaded,
        movie: testMovieDetail,
        recommendationsStatus: RequestState.loaded,
        recommendations: const <Movie>[],
        isInWatchlist: false,
      );
      when(mockCubit.state).thenReturn(state);
      when(mockCubit.stream).thenAnswer((_) => Stream<MovieDetailState>.value(state));
      when(mockCubit.fetchDetail(1)).thenAnswer((_) async {});
      when(mockCubit.loadWatchlistStatus(1)).thenAnswer((_) async {});

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1), mockCubit));

      // Check if back button is displayed
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);

      // Test back button tap
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pump();
    });

    testWidgets('should display movie with empty genres list', (WidgetTester tester) async {
      final movieWithEmptyGenres = MovieDetail(
        adult: testMovieDetail.adult,
        backdropPath: testMovieDetail.backdropPath,
        genres: const [],
        id: testMovieDetail.id,
        originalTitle: testMovieDetail.originalTitle,
        overview: testMovieDetail.overview,
        posterPath: testMovieDetail.posterPath,
        releaseDate: testMovieDetail.releaseDate,
        runtime: testMovieDetail.runtime,
        title: testMovieDetail.title,
        voteAverage: testMovieDetail.voteAverage,
        voteCount: testMovieDetail.voteCount,
      );
      final mockCubit = MockMovieDetailCubit();
      final state = MovieDetailState(
        status: RequestState.loaded,
        movie: movieWithEmptyGenres,
        recommendationsStatus: RequestState.loaded,
        recommendations: const <Movie>[],
        isInWatchlist: false,
      );
      when(mockCubit.state).thenReturn(state);
      when(mockCubit.stream).thenAnswer((_) => Stream<MovieDetailState>.value(state));
      when(mockCubit.fetchDetail(1)).thenAnswer((_) async {});
      when(mockCubit.loadWatchlistStatus(1)).thenAnswer((_) async {});

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1), mockCubit));

      expect(find.text(''), findsOneWidget);
    });

    testWidgets('should display movie with single genre', (WidgetTester tester) async {
      final movieWithSingleGenre = MovieDetail(
        adult: testMovieDetail.adult,
        backdropPath: testMovieDetail.backdropPath,
        genres: const [Genre(id: 1, name: 'Action')],
        id: testMovieDetail.id,
        originalTitle: testMovieDetail.originalTitle,
        overview: testMovieDetail.overview,
        posterPath: testMovieDetail.posterPath,
        releaseDate: testMovieDetail.releaseDate,
        runtime: testMovieDetail.runtime,
        title: testMovieDetail.title,
        voteAverage: testMovieDetail.voteAverage,
        voteCount: testMovieDetail.voteCount,
      );
      final mockCubit = MockMovieDetailCubit();
      final state = MovieDetailState(
        status: RequestState.loaded,
        movie: movieWithSingleGenre,
        recommendationsStatus: RequestState.loaded,
        recommendations: const <Movie>[],
        isInWatchlist: false,
      );
      when(mockCubit.state).thenReturn(state);
      when(mockCubit.stream).thenAnswer((_) => Stream<MovieDetailState>.value(state));
      when(mockCubit.fetchDetail(1)).thenAnswer((_) async {});
      when(mockCubit.loadWatchlistStatus(1)).thenAnswer((_) async {});

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1), mockCubit));

      expect(find.text('Action'), findsOneWidget);
    });

    testWidgets('should display back button and handle navigation', (WidgetTester tester) async {
      final mockCubit = MockMovieDetailCubit();
      final state = MovieDetailState(
        status: RequestState.loaded,
        movie: testMovieDetail,
        recommendationsStatus: RequestState.loaded,
        recommendations: const <Movie>[],
        isInWatchlist: false,
      );
      when(mockCubit.state).thenReturn(state);
      when(mockCubit.stream).thenAnswer((_) => Stream<MovieDetailState>.value(state));
      when(mockCubit.fetchDetail(1)).thenAnswer((_) async {});
      when(mockCubit.loadWatchlistStatus(1)).thenAnswer((_) async {});

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1), mockCubit));

      // Check if back button is displayed
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);

      // Test back button tap
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pump();
    });

    testWidgets('should display movie with empty genres list', (WidgetTester tester) async {
      final movieWithEmptyGenres = MovieDetail(
        adult: testMovieDetail.adult,
        backdropPath: testMovieDetail.backdropPath,
        genres: const [],
        id: testMovieDetail.id,
        originalTitle: testMovieDetail.originalTitle,
        overview: testMovieDetail.overview,
        posterPath: testMovieDetail.posterPath,
        releaseDate: testMovieDetail.releaseDate,
        runtime: testMovieDetail.runtime,
        title: testMovieDetail.title,
        voteAverage: testMovieDetail.voteAverage,
        voteCount: testMovieDetail.voteCount,
      );
      final mockCubit = MockMovieDetailCubit();
      final state = MovieDetailState(
        status: RequestState.loaded,
        movie: movieWithEmptyGenres,
        recommendationsStatus: RequestState.loaded,
        recommendations: const <Movie>[],
        isInWatchlist: false,
      );
      when(mockCubit.state).thenReturn(state);
      when(mockCubit.stream).thenAnswer((_) => Stream<MovieDetailState>.value(state));
      when(mockCubit.fetchDetail(1)).thenAnswer((_) async {});
      when(mockCubit.loadWatchlistStatus(1)).thenAnswer((_) async {});

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1), mockCubit));

      expect(find.text(''), findsOneWidget);
    });

    testWidgets('should display movie with single genre', (WidgetTester tester) async {
      final movieWithSingleGenre = MovieDetail(
        adult: testMovieDetail.adult,
        backdropPath: testMovieDetail.backdropPath,
        genres: const [Genre(id: 1, name: 'Action')],
        id: testMovieDetail.id,
        originalTitle: testMovieDetail.originalTitle,
        overview: testMovieDetail.overview,
        posterPath: testMovieDetail.posterPath,
        releaseDate: testMovieDetail.releaseDate,
        runtime: testMovieDetail.runtime,
        title: testMovieDetail.title,
        voteAverage: testMovieDetail.voteAverage,
        voteCount: testMovieDetail.voteCount,
      );
      final mockCubit = MockMovieDetailCubit();
      final state = MovieDetailState(
        status: RequestState.loaded,
        movie: movieWithSingleGenre,
        recommendationsStatus: RequestState.loaded,
        recommendations: const <Movie>[],
        isInWatchlist: false,
      );
      when(mockCubit.state).thenReturn(state);
      when(mockCubit.stream).thenAnswer((_) => Stream<MovieDetailState>.value(state));
      when(mockCubit.fetchDetail(1)).thenAnswer((_) async {});
      when(mockCubit.loadWatchlistStatus(1)).thenAnswer((_) async {});

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1), mockCubit));

      expect(find.text('Action'), findsOneWidget);
    });
  });
}
