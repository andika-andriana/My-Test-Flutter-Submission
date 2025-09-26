import 'package:dartz/dartz.dart';
import 'package:ditonton_tv_series/ditonton_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTVSeriesRecommendations usecase;
  late MockTVSeriesRepository mockRepository;

  setUp(() {
    mockRepository = MockTVSeriesRepository();
    usecase = GetTVSeriesRecommendations(mockRepository);
  });

  final tTVSeries = <TVSeries>[];
  const tId = 1;

  test('should get list of TV series recommendations', () async {
    when(
      mockRepository.getTVSeriesRecommendations(tId),
    ).thenAnswer((_) async => Right(tTVSeries));

    final result = await usecase.execute(tId);

    expect(result, Right(tTVSeries));
  });
}
