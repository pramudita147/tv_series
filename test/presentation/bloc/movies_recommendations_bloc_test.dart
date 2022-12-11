import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/presentation/bloc/movie_recommendations_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movies_recommendations_bloc_test.mocks.dart';

@GenerateMocks([GetMovieRecommendations])
void main() {
  late MoviesRecommendationsBloc moviesRecommendationsBloc;
  late MockGetMovieRecommendations mockGetRecommendationsMovies;

  setUp(() {
    mockGetRecommendationsMovies = MockGetMovieRecommendations();
    moviesRecommendationsBloc =
        MoviesRecommendationsBloc(mockGetRecommendationsMovies);
  });

  const tId = 1;

  test('initial state should be empty', () {
    expect(moviesRecommendationsBloc.state, MoviesRecommendationsEmpty());
  });

  blocTest<MoviesRecommendationsBloc, MoviesRecommendationsState>(
    'Should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockGetRecommendationsMovies.execute(tId))
          .thenAnswer((_) async => Right(testMovieList));
      return moviesRecommendationsBloc;
    },
    act: (bloc) => bloc.add(const FetchRecommendationsMovies(tId)),
    expect: () => [
      MoviesRecommendationsLoading(),
      MoviesRecommendationsLoaded(testMovieList),
    ],
    verify: (bloc) {
      verify(mockGetRecommendationsMovies.execute(tId));
    },
  );

  blocTest<MoviesRecommendationsBloc, MoviesRecommendationsState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockGetRecommendationsMovies.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return moviesRecommendationsBloc;
    },
    act: (bloc) => bloc.add(const FetchRecommendationsMovies(tId)),
    expect: () => [
      MoviesRecommendationsLoading(),
      MoviesRecommendationsError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetRecommendationsMovies.execute(tId));
    },
  );
}
