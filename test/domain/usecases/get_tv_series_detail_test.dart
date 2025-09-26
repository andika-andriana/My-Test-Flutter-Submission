import 'package:dartz/dartz.dart';
import 'package:ditonton_tv_series/ditonton_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTVSeriesDetail usecase;
  late MockTVSeriesRepository mockRepository;

  setUp(() {
    mockRepository = MockTVSeriesRepository();
    usecase = GetTVSeriesDetail(mockRepository);
  });

  const tId = 1;

  test('should get tv series detail from repository', () async {
    when(
      mockRepository.getTVSeriesDetail(tId),
    ).thenAnswer((_) async => Right(testTVSeriesDetail));

    final result = await usecase.execute(tId);

    expect(result, Right(testTVSeriesDetail));
  });
}
