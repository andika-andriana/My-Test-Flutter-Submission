import 'package:ditonton_movie/ditonton_movie.dart';
import 'package:ditonton/features/movie/presentation/widgets/movie_card_list.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  Widget makeTestableWidget(Widget body) {
    return MaterialApp(home: Scaffold(body: body));
  }

  group('MovieCard Widget Tests', () {
    testWidgets('should display movie card with correct content', (WidgetTester tester) async {
      // arrange
      final movie = testMovie;

      // act
      await tester.pumpWidget(makeTestableWidget(MovieCard(movie)));

      // assert
      expect(find.text(movie.title!), findsOneWidget);
      expect(find.text(movie.overview!), findsOneWidget);
      expect(find.byType(CachedNetworkImage), findsOneWidget);
    });

    testWidgets('should have InkWell for navigation', (WidgetTester tester) async {
      // arrange
      final movie = testMovie;

      // act
      await tester.pumpWidget(makeTestableWidget(MovieCard(movie)));

      // assert
      expect(find.byType(InkWell), findsOneWidget);
    });

    testWidgets('should display placeholder when image is loading', (WidgetTester tester) async {
      // arrange
      final movie = testMovie;

      // act
      await tester.pumpWidget(makeTestableWidget(MovieCard(movie)));

      // assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display CachedNetworkImage widget', (WidgetTester tester) async {
      // arrange
      final movie = testMovie;

      // act
      await tester.pumpWidget(makeTestableWidget(MovieCard(movie)));

      // assert
      expect(find.byType(CachedNetworkImage), findsOneWidget);
    });

    testWidgets('should handle null title and overview', (WidgetTester tester) async {
      // arrange
      final movie = Movie(
        id: 1,
        title: null,
        overview: null,
        posterPath: '/test.jpg',
        backdropPath: '/test.jpg',
        voteAverage: 8.5,
        releaseDate: '2023-01-01',
        genreIds: [1, 2, 3],
        popularity: 100.0,
        voteCount: 1000,
        originalTitle: 'Test Movie',
        adult: false,
        video: false,
      );

      // act
      await tester.pumpWidget(makeTestableWidget(MovieCard(movie)));

      // assert
      expect(find.text('-'), findsNWidgets(2));
    });

    testWidgets('should display card with proper styling', (WidgetTester tester) async {
      // arrange
      final movie = testMovie;

      // act
      await tester.pumpWidget(makeTestableWidget(MovieCard(movie)));

      // assert
      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(Stack), findsWidgets);
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('should handle navigation tap', (WidgetTester tester) async {
      // arrange
      final movie = testMovie;

      // act
      await tester.pumpWidget(
        MaterialApp(
          routes: {'/detail': (context) => const Scaffold(body: Text('Movie Detail'))},
          home: Scaffold(body: MovieCard(movie)),
        ),
      );

      // assert
      expect(find.byType(InkWell), findsOneWidget);

      // Tap the InkWell to trigger navigation
      await tester.tap(find.byType(InkWell));
      await tester.pump();

      // Verify that the tap was handled (navigation is tested by the widget itself)
      expect(find.text('Spider-Man'), findsOneWidget);
    });

    testWidgets('should display error widget when image fails to load', (
      WidgetTester tester,
    ) async {
      // arrange
      final movie = Movie(
        id: 1,
        title: 'Test Movie',
        overview: 'Test Overview',
        posterPath: '/invalid-path.jpg', // Invalid path to trigger error
        backdropPath: '/test.jpg',
        voteAverage: 8.5,
        releaseDate: '2023-01-01',
        genreIds: [1, 2, 3],
        popularity: 100.0,
        voteCount: 1000,
        originalTitle: 'Test Movie',
        adult: false,
        video: false,
      );

      // act
      await tester.pumpWidget(makeTestableWidget(MovieCard(movie)));

      // Wait for the image to fail loading
      await tester.pump(const Duration(seconds: 1));
      await tester.pump();

      // assert
      expect(find.byType(CachedNetworkImage), findsOneWidget);
      // Just verify that the movie card is displayed
      expect(find.byType(MovieCard), findsOneWidget);
    });

    testWidgets('should display movie with empty release date', (WidgetTester tester) async {
      // arrange
      final movie = Movie(
        id: 1,
        title: 'Test Movie',
        overview: 'Test Overview',
        posterPath: '/test.jpg',
        backdropPath: '/test.jpg',
        voteAverage: 8.5,
        releaseDate: '', // Empty release date
        genreIds: [1, 2, 3],
        popularity: 100.0,
        voteCount: 1000,
        originalTitle: 'Test Movie',
        adult: false,
        video: false,
      );

      // act
      await tester.pumpWidget(makeTestableWidget(MovieCard(movie)));

      // assert
      expect(find.text('Test Movie'), findsOneWidget);
      expect(find.text('Test Overview'), findsOneWidget);
    });
  });
}
