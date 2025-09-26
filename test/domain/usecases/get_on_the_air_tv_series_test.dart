import 'package:dartz/dartz.dart';
import 'package:ditonton_tv_series/ditonton_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetOnTheAirTVSeries usecase;
  late MockTVSeriesRepository mockRepository;

  setUp(() {
    mockRepository = MockTVSeriesRepository();
    usecase = GetOnTheAirTVSeries(mockRepository);
  });

  final tTVSeries = <TVSeries>[];

  test('should get list of tv series from the repository', () async {
    // arrange
    when(
      mockRepository.getOnTheAirTVSeries(),
    ).thenAnswer((_) async => Right(tTVSeries));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(tTVSeries));
  });
}
