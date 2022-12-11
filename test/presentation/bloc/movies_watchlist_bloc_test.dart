import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/movie_watchlist_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movies_watchlist_bloc_test.mocks.dart';

@GenerateMocks(
    [GetWatchlistMovies, GetWatchListStatus, SaveWatchlist, RemoveWatchlist])
void main() {
  late MovieWatchlistBloc movieWatchlistBloc;
  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late MockGetWatchListStatusMovies mockGetWatchListStatusMovies;
  late MockSaveWatchlistMovies mockSaveWatchlistMovies;
  late MockRemoveWatchlistMovies mockRemoveWatchlistMovies;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    mockGetWatchListStatusMovies = MockGetWatchListStatusMovies();
    mockSaveWatchlistMovies = MockSaveWatchlistMovies();
    mockRemoveWatchlistMovies = MockRemoveWatchlistMovies();
    movieWatchlistBloc = MovieWatchlistBloc(
        mockGetWatchlistMovies,
        mockGetWatchListStatusMovies,
        mockSaveWatchlistMovies,
        mockRemoveWatchlistMovies);
  });

  const tId = 1;

  test('initial state should be empty', () {
    expect(movieWatchlistBloc.state, MoviesWatchlistEmpty());
  });

  group("Get Watchlist Movies", () {
    blocTest<MovieWatchlistBloc, MovieWatchlistState>(
      "Should emit [Loading, Loaded] when data is gotten successfully",
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Right(testMovieList));
        return movieWatchlistBloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistMovies()),
      expect: () => [
        MoviesWatchlistLoading(),
        MoviesWatchlistLoaded(testMovieList),
      ],
      verify: (bloc) => verify(mockGetWatchlistMovies.execute()),
    );

    blocTest<MovieWatchlistBloc, MovieWatchlistState>(
      "Should emit [Loading, Error] when get watchlist movie is unsuccessful",
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure("Server Failure")));
        return movieWatchlistBloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistMovies()),
      expect: () => [
        MoviesWatchlistLoading(),
        const MoviesWatchlistError("Server Failure"),
      ],
      verify: (bloc) => verify(mockGetWatchlistMovies.execute()),
    );
  });

  group("Save Watchlist Movie", () {
    blocTest<MovieWatchlistBloc, MovieWatchlistState>(
      "Should emit [Loading, Loaded] when data is gotten successfully",
      build: () {
        when(mockSaveWatchlistMovies.execute(testMovieDetail)).thenAnswer(
            (_) async =>
                const Right(MovieWatchlistBloc.messageAddedToWatchlist));
        return movieWatchlistBloc;
      },
      act: (bloc) => bloc.add(OnSaveWatchlistMovies(testMovieDetail)),
      expect: () => [
        MoviesWatchlistLoading(),
        const MoviesWatchlistMessage(MovieWatchlistBloc.messageAddedToWatchlist)
      ],
      verify: (bloc) =>
          verify(mockSaveWatchlistMovies.execute(testMovieDetail)),
    );
    blocTest<MovieWatchlistBloc, MovieWatchlistState>(
      "Should emit [Loading, Error] when save movie is unsuccessful",
      build: () {
        when(mockSaveWatchlistMovies.execute(testMovieDetail))
            .thenAnswer((_) async => Left(ServerFailure("Server Failure")));
        return movieWatchlistBloc;
      },
      act: (bloc) => bloc.add(OnSaveWatchlistMovies(testMovieDetail)),
      expect: () => [
        MoviesWatchlistLoading(),
        const MoviesWatchlistError("Server Failure"),
      ],
      verify: (bloc) =>
          verify(mockSaveWatchlistMovies.execute(testMovieDetail)),
    );
  });

  group("Remove Watchlist Movie", () {
    blocTest<MovieWatchlistBloc, MovieWatchlistState>(
      "Should emit [Loading, Loaded] when data is gotten successfully",
      build: () {
        when(mockRemoveWatchlistMovies.execute(testMovieDetail)).thenAnswer(
            (_) async =>
                const Right(MovieWatchlistBloc.messageRemoveToWatchlist));
        return movieWatchlistBloc;
      },
      act: (bloc) => bloc.add(OnRemoveWatchlistMovies(testMovieDetail)),
      expect: () => [
        MoviesWatchlistLoading(),
        const MoviesWatchlistMessage(
            MovieWatchlistBloc.messageRemoveToWatchlist)
      ],
      verify: (bloc) =>
          verify(mockRemoveWatchlistMovies.execute(testMovieDetail)),
    );

    blocTest<MovieWatchlistBloc, MovieWatchlistState>(
      "Should emit [Loading, Error] when remove movie is unsuccessful",
      build: () {
        when(mockRemoveWatchlistMovies.execute(testMovieDetail))
            .thenAnswer((_) async => Left(ServerFailure("Server Failure")));
        return movieWatchlistBloc;
      },
      act: (bloc) => bloc.add(OnRemoveWatchlistMovies(testMovieDetail)),
      expect: () => [
        MoviesWatchlistLoading(),
        const MoviesWatchlistError("Server Failure"),
      ],
      verify: (bloc) =>
          verify(mockRemoveWatchlistMovies.execute(testMovieDetail)),
    );
  });

  group("Load Watchlist Movie", () {
    blocTest<MovieWatchlistBloc, MovieWatchlistState>(
      "Should emit [Loading, Load(true)] when data is gotten successfully",
      build: () {
        when(mockGetWatchListStatusMovies.execute(tId))
            .thenAnswer((realInvocation) async => true);
        return movieWatchlistBloc;
      },
      act: (bloc) => bloc.add(const OnLoadWatchlistStatusMovies(tId)),
      expect: () => [
        MoviesWatchlistLoading(),
        const MoviesLoadWatchlist(true),
      ],
      verify: (bloc) => verify(mockGetWatchListStatusMovies.execute(tId)),
    );

    blocTest<MovieWatchlistBloc, MovieWatchlistState>(
      "Should emit [Loading, Load(false)] when remove movie is unsuccessful",
      build: () {
        when(mockGetWatchListStatusMovies.execute(tId))
            .thenAnswer((realInvocation) async => false);
        return movieWatchlistBloc;
      },
      act: (bloc) => bloc.add(const OnLoadWatchlistStatusMovies(tId)),
      expect: () => [
        MoviesWatchlistLoading(),
        const MoviesLoadWatchlist(false),
      ],
    );
  });
}
