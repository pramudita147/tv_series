import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tvseries.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/tvseries_dummy_objects.dart';
import '../../helpers/tvseries_test_helper.mocks.dart';

void main() {
  late GetWatchlistTvSeries usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = GetWatchlistTvSeries(mockTvSeriesRepository);
  });

  test('should get list of tv series from the repository', () async {
    // arrange
    when(mockTvSeriesRepository.getWatchlistTvSeries())
        .thenAnswer((_) async => Right(testTvSeriesList));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(testTvSeriesList));
  });
}
