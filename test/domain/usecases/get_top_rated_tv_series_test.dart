import 'package:dartz/dartz.dart';
import 'package:ditonton_tv_series/ditonton_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTopRatedTVSeries usecase;
  late MockTVSeriesRepository mockRepository;

  setUp(() {
    mockRepository = MockTVSeriesRepository();
    usecase = GetTopRatedTVSeries(mockRepository);
  });

  final tTVSeries = <TVSeries>[];

  test('should get list of tv series from repository', () async {
    when(
      mockRepository.getTopRatedTVSeries(),
    ).thenAnswer((_) async => Right(tTVSeries));

    final result = await usecase.execute();

    expect(result, Right(tTVSeries));
  });
}
