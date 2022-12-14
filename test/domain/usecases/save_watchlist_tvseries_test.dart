import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/save_tvseries_watchlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/tvseries_dummy_objects.dart';
import '../../helpers/tvseries_test_helper.mocks.dart';

void main() {
  late SaveWatchlistTvSeries usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = SaveWatchlistTvSeries(mockTvSeriesRepository);
  });

  test('should save tv series to the repository', () async {
    // arrange
    when(mockTvSeriesRepository.saveWatchlistTvSeries(testTvSeriesDetail))
        .thenAnswer((_) async => Right('Added to Watchlist'));
    // act
    final result = await usecase.execute(testTvSeriesDetail);
    // assert
    verify(mockTvSeriesRepository.saveWatchlistTvSeries(testTvSeriesDetail));
    expect(result, Right('Added to Watchlist'));
  });
}
