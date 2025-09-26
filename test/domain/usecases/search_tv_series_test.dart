import 'package:dartz/dartz.dart';
import 'package:ditonton_tv_series/ditonton_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late SearchTVSeries usecase;
  late MockTVSeriesRepository mockRepository;

  setUp(() {
    mockRepository = MockTVSeriesRepository();
    usecase = SearchTVSeries(mockRepository);
  });

  final tTVSeries = <TVSeries>[];
  const tQuery = 'game of thrones';

  test('should get list of tv series based on search', () async {
    when(
      mockRepository.searchTVSeries(tQuery),
    ).thenAnswer((_) async => Right(tTVSeries));

    final result = await usecase.execute(tQuery);

    expect(result, Right(tTVSeries));
  });
}
