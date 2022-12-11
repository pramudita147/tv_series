import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_tvseries_detail.dart';
import 'package:ditonton/presentation/bloc/tvseries_detail_bloc.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';

import '../../dummy_data/tvseries_dummy_objects.dart';
import 'tvseries_detail_bloc_test.mocks.dart';

@GenerateMocks([GetTvSeriesDetail])
void main() {
  late TvDetailBloc tvDetailBloc;
  late MockGetTvDetail mockGetTvDetail;

  setUp(() {
    mockGetTvDetail = MockGetTvDetail();
    tvDetailBloc = TvDetailBloc(mockGetTvDetail);
  });

  const tId = 1;

  test('initial state should be loading', () {
    expect(tvDetailBloc.state, TvDetailLoading());
  });

  blocTest<TvDetailBloc, TvDetailState>(
    "Should emit [Loading, Loaded] when data is gotten successfully",
    build: () {
      when(mockGetTvDetail.execute(tId))
          .thenAnswer((_) async => Right(testTvSeriesDetail));
      return tvDetailBloc;
    },
    act: (bloc) => bloc.add(const FetchDetailTv(tId)),
    expect: () => [
      TvDetailLoading(),
      TvDetailLoaded(testTvSeriesDetail),
    ],
    verify: (bloc) => verify(mockGetTvDetail.execute(tId)),
  );

  blocTest<TvDetailBloc, TvDetailState>(
    "Should emit [Loading, Error] when get detail movie is unsuccessful",
    build: () {
      when(mockGetTvDetail.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return tvDetailBloc;
    },
    act: (bloc) => bloc.add(const FetchDetailTv(tId)),
    expect: () => [
      TvDetailLoading(),
      TvDetailError('Server Failure'),
    ],
    verify: (bloc) => verify(mockGetTvDetail.execute(tId)),
  );
}
