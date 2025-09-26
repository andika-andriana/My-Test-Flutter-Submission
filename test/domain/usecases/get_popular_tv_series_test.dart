import 'package:dartz/dartz.dart';
import 'package:ditonton_tv_series/ditonton_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetPopularTVSeries usecase;
  late MockTVSeriesRepository mockRepository;

  setUp(() {
    mockRepository = MockTVSeriesRepository();
    usecase = GetPopularTVSeries(mockRepository);
  });

  final tTVSeries = <TVSeries>[];

  test('should get list of tv series from the repository', () async {
    when(
      mockRepository.getPopularTVSeries(),
    ).thenAnswer((_) async => Right(tTVSeries));

    final result = await usecase.execute();

    expect(result, Right(tTVSeries));
  });
}
