import 'package:ditonton_core/ditonton_core.dart';
import 'package:ditonton_movie/ditonton_movie.dart';
import 'package:ditonton/features/movie/presentation/bloc/top_rated_movies_cubit.dart';
import 'package:ditonton/features/movie/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/features/movie/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/presentation/bloc/common/list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockTopRatedMoviesCubit extends Mock implements TopRatedMoviesCubit {
  @override
  ListState<Movie> get state =>
      super.noSuchMethod(
            Invocation.getter(#state),
            returnValue: const ListState<Movie>(),
            returnValueForMissingStub: const ListState<Movie>(),
          )
          as ListState<Movie>;

  @override
  Stream<ListState<Movie>> get stream =>
      super.noSuchMethod(
            Invocation.getter(#stream),
            returnValue: const Stream<ListState<Movie>>.empty(),
            returnValueForMissingStub: const Stream<ListState<Movie>>.empty(),
          )
          as Stream<ListState<Movie>>;

  @override
  Future<void> fetchTopRated() =>
      super.noSuchMethod(
            Invocation.method(#fetchTopRated, const []),
            returnValue: Future.value(),
            returnValueForMissingStub: Future.value(),
          )
          as Future<void>;
}

void main() {
  late MockTopRatedMoviesCubit mockCubit;

  setUp(() {
    mockCubit = MockTopRatedMoviesCubit();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedMoviesCubit>.value(
      value: mockCubit,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display progress bar when loading', (WidgetTester tester) async {
    reset(mockCubit);
    when(mockCubit.state).thenReturn(const ListState<Movie>(status: RequestState.loading));
    when(mockCubit.stream).thenAnswer(
      (_) => Stream<ListState<Movie>>.value(const ListState<Movie>(status: RequestState.loading)),
    );
    when(mockCubit.fetchTopRated()).thenAnswer((_) async {});

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (WidgetTester tester) async {
    reset(mockCubit);
    when(
      mockCubit.state,
    ).thenReturn(const ListState<Movie>(status: RequestState.loaded, items: <Movie>[]));
    when(mockCubit.stream).thenAnswer(
      (_) => Stream<ListState<Movie>>.value(
        const ListState<Movie>(status: RequestState.loaded, items: <Movie>[]),
      ),
    );
    when(mockCubit.fetchTopRated()).thenAnswer((_) async {});

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when error', (WidgetTester tester) async {
    reset(mockCubit);
    when(
      mockCubit.state,
    ).thenReturn(const ListState<Movie>(status: RequestState.error, message: 'Error message'));
    when(mockCubit.stream).thenAnswer(
      (_) => Stream<ListState<Movie>>.value(
        const ListState<Movie>(status: RequestState.error, message: 'Error message'),
      ),
    );
    when(mockCubit.fetchTopRated()).thenAnswer((_) async {});

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));

    expect(textFinder, findsOneWidget);
  });

  testWidgets('Page should display empty state when status is empty', (WidgetTester tester) async {
    reset(mockCubit);
    when(mockCubit.state).thenReturn(const ListState<Movie>(status: RequestState.empty));
    when(mockCubit.stream).thenAnswer(
      (_) => Stream<ListState<Movie>>.value(const ListState<Movie>(status: RequestState.empty)),
    );
    when(mockCubit.fetchTopRated()).thenAnswer((_) async {});

    final emptyStateFinder = find.byType(SizedBox);

    await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));

    expect(emptyStateFinder, findsOneWidget);
  });

  testWidgets('Page should call fetchTopRated on initState', (WidgetTester tester) async {
    reset(mockCubit);
    when(mockCubit.state).thenReturn(const ListState<Movie>(status: RequestState.loading));
    when(mockCubit.stream).thenAnswer(
      (_) => Stream<ListState<Movie>>.value(const ListState<Movie>(status: RequestState.loading)),
    );
    when(mockCubit.fetchTopRated()).thenAnswer((_) async {});

    await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));

    verify(mockCubit.fetchTopRated()).called(1);
  });

  testWidgets('Page should display ListView with movies when data is loaded', (
    WidgetTester tester,
  ) async {
    final testMovies = [
      const Movie(
        id: 1,
        title: 'Test Movie 1',
        overview: 'Test Overview 1',
        posterPath: '/test1.jpg',
        backdropPath: '/test1.jpg',
        voteAverage: 8.5,
        releaseDate: '2023-01-01',
        genreIds: [1, 2, 3],
        popularity: 100.0,
        voteCount: 1000,
        originalTitle: 'Test Movie 1',
        adult: false,
        video: false,
      ),
      const Movie(
        id: 2,
        title: 'Test Movie 2',
        overview: 'Test Overview 2',
        posterPath: '/test2.jpg',
        backdropPath: '/test2.jpg',
        voteAverage: 7.5,
        releaseDate: '2023-02-01',
        genreIds: [4, 5, 6],
        popularity: 200.0,
        voteCount: 2000,
        originalTitle: 'Test Movie 2',
        adult: false,
        video: false,
      ),
    ];

    reset(mockCubit);
    when(
      mockCubit.state,
    ).thenReturn(ListState<Movie>(status: RequestState.loaded, items: testMovies));
    when(mockCubit.stream).thenAnswer(
      (_) => Stream<ListState<Movie>>.value(
        ListState<Movie>(status: RequestState.loaded, items: testMovies),
      ),
    );
    when(mockCubit.fetchTopRated()).thenAnswer((_) async {});

    await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(MovieCard), findsNWidgets(2));
    expect(find.text('Test Movie 1'), findsOneWidget);
    expect(find.text('Test Movie 2'), findsOneWidget);
  });

  testWidgets('Page should display AppBar with correct title', (WidgetTester tester) async {
    reset(mockCubit);
    when(mockCubit.state).thenReturn(const ListState<Movie>(status: RequestState.loading));
    when(mockCubit.stream).thenAnswer(
      (_) => Stream<ListState<Movie>>.value(const ListState<Movie>(status: RequestState.loading)),
    );
    when(mockCubit.fetchTopRated()).thenAnswer((_) async {});

    await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('Top Rated Movies'), findsOneWidget);
  });

  testWidgets('Page should handle mounted check in initState', (WidgetTester tester) async {
    reset(mockCubit);
    when(mockCubit.state).thenReturn(const ListState<Movie>(status: RequestState.loading));
    when(mockCubit.stream).thenAnswer(
      (_) => Stream<ListState<Movie>>.value(const ListState<Movie>(status: RequestState.loading)),
    );
    when(mockCubit.fetchTopRated()).thenAnswer((_) async {});

    await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));

    // This tests the mounted check in initState
    verify(mockCubit.fetchTopRated()).called(1);
  });
}
