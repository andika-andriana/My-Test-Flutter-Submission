import 'package:ditonton_tv_series/ditonton_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTVWatchlistStatus usecase;
  late MockTVSeriesRepository mockRepository;

  setUp(() {
    mockRepository = MockTVSeriesRepository();
    usecase = GetTVWatchlistStatus(mockRepository);
  });

  const tId = 1;

  test('should get watchlist status from repository', () async {
    when(mockRepository.isAddedToWatchlist(tId)).thenAnswer((_) async => true);

    final result = await usecase.execute(tId);

    expect(result, true);
  });
}
