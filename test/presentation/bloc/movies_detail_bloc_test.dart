import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/presentation/bloc/movie_detail_bloc.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movies_detail_bloc_test.mocks.dart';

@GenerateMocks([GetMovieDetail])
void main() {
  late MoviesDetailBloc moviesDetailBloc;
  late MockGetMovieDetail mockGetMovieDetail;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    moviesDetailBloc = MoviesDetailBloc(mockGetMovieDetail);
  });

  const tId = 1;

  test('initial state should be loading', () {
    expect(moviesDetailBloc.state, MoviesDetailLoading());
  });

  blocTest<MoviesDetailBloc, MoviesDetailState>(
    "Should emit [Loading, Loaded] when data is gotten successfully",
    build: () {
      when(mockGetMovieDetail.execute(tId))
          .thenAnswer((_) async => Right(testMovieDetail));
      return moviesDetailBloc;
    },
    act: (bloc) => bloc.add(const FetchDetailMovies(tId)),
    expect: () => [
      MoviesDetailLoading(),
      MoviesDetailLoaded(testMovieDetail),
    ],
    verify: (bloc) => verify(mockGetMovieDetail.execute(tId)),
  );

  blocTest<MoviesDetailBloc, MoviesDetailState>(
    "Should emit [Loading, Error] when get detail movie is unsuccessful",
    build: () {
      when(mockGetMovieDetail.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return moviesDetailBloc;
    },
    act: (bloc) => bloc.add(const FetchDetailMovies(tId)),
    expect: () => [
      MoviesDetailLoading(),
      MoviesDetailError('Server Failure'),
    ],
    verify: (bloc) => verify(mockGetMovieDetail.execute(tId)),
  );
}
