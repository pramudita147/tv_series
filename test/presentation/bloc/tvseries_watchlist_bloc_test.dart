import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tvseries.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tvseries_status.dart';
import 'package:ditonton/domain/usecases/remove_tvseries_watchlist.dart';
import 'package:ditonton/domain/usecases/save_tvseries_watchlist.dart';
import 'package:ditonton/presentation/bloc/tvseries_watchlist_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';

import '../../dummy_data/tvseries_dummy_objects.dart';
import 'tvseries_watchlist_bloc_test.mocks.dart';

@GenerateMocks([
  GetWatchlistTvSeries,
  GetWatchListStatusTvSeries,
  SaveWatchlistTvSeries,
  RemoveWatchlistTvSeries
])
void main() {
  late TvWatchlistBloc tvWatchlistBloc;
  late MockGetWatchlistTv mockGetWatchlistTv;
  late MockGetWatchListStatusTv mockGetWatchListStatusTv;
  late MockSaveWatchlistTv mockSaveWatchlistTv;
  late MockRemoveWatchlistTv mockRemoveWatchlistTv;

  setUp(() {
    mockGetWatchlistTv = MockGetWatchlistTv();
    mockGetWatchListStatusTv = MockGetWatchListStatusTv();
    mockSaveWatchlistTv = MockSaveWatchlistTv();
    mockRemoveWatchlistTv = MockRemoveWatchlistTv();
    tvWatchlistBloc = TvWatchlistBloc(mockGetWatchlistTv,
        mockGetWatchListStatusTv, mockSaveWatchlistTv, mockRemoveWatchlistTv);
  });

  const tId = 1;

  test('initial state should be empty', () {
    expect(tvWatchlistBloc.state, TvWatchlistEmpty());
  });

  group("Get Watchlist Tv", () {
    blocTest<TvWatchlistBloc, TvWatchlistState>(
      "Should emit [Loading, Loaded] when data is gotten successfully",
      build: () {
        when(mockGetWatchlistTv.execute())
            .thenAnswer((_) async => Right(testTvSeriesList));
        return tvWatchlistBloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistTv()),
      expect: () => [
        TvWatchlistLoading(),
        TvWatchlistLoaded(testTvSeriesList),
      ],
      verify: (bloc) => verify(mockGetWatchlistTv.execute()),
    );

    blocTest<TvWatchlistBloc, TvWatchlistState>(
      "Should emit [Loading, Error] when get watchlist tv is unsuccessful",
      build: () {
        when(mockGetWatchlistTv.execute())
            .thenAnswer((_) async => Left(ServerFailure("Server Failure")));
        return tvWatchlistBloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistTv()),
      expect: () => [
        TvWatchlistLoading(),
        const TvWatchlistError("Server Failure"),
      ],
      verify: (bloc) => verify(mockGetWatchlistTv.execute()),
    );
  });

  group("Save Watchlist Tv", () {
    blocTest<TvWatchlistBloc, TvWatchlistState>(
      "Should emit [Loading, Loaded] when data is gotten successfully",
      build: () {
        when(mockSaveWatchlistTv.execute(testTvSeriesDetail)).thenAnswer(
            (_) async => const Right(TvWatchlistBloc.messageAddedToWatchlist));
        return tvWatchlistBloc;
      },
      act: (bloc) => bloc.add(OnSaveWatchlistTv(testTvSeriesDetail)),
      expect: () => [
        TvWatchlistLoading(),
        const TvWatchlistMessage(TvWatchlistBloc.messageAddedToWatchlist)
      ],
      verify: (bloc) => verify(mockSaveWatchlistTv.execute(testTvSeriesDetail)),
    );
    blocTest<TvWatchlistBloc, TvWatchlistState>(
      "Should emit [Loading, Error] when save tv is unsuccessful",
      build: () {
        when(mockSaveWatchlistTv.execute(testTvSeriesDetail))
            .thenAnswer((_) async => Left(ServerFailure("Server Failure")));
        return tvWatchlistBloc;
      },
      act: (bloc) => bloc.add(OnSaveWatchlistTv(testTvSeriesDetail)),
      expect: () => [
        TvWatchlistLoading(),
        const TvWatchlistError("Server Failure"),
      ],
      verify: (bloc) => verify(mockSaveWatchlistTv.execute(testTvSeriesDetail)),
    );
  });

  group("Remove Watchlist Tv", () {
    blocTest<TvWatchlistBloc, TvWatchlistState>(
      "Should emit [Loading, Loaded] when data is gotten successfully",
      build: () {
        when(mockRemoveWatchlistTv.execute(testTvSeriesDetail)).thenAnswer(
            (_) async => const Right(TvWatchlistBloc.messageRemoveToWatchlist));
        return tvWatchlistBloc;
      },
      act: (bloc) => bloc.add(OnRemoveWatchlistTv(testTvSeriesDetail)),
      expect: () => [
        TvWatchlistLoading(),
        const TvWatchlistMessage(TvWatchlistBloc.messageRemoveToWatchlist)
      ],
      verify: (bloc) =>
          verify(mockRemoveWatchlistTv.execute(testTvSeriesDetail)),
    );

    blocTest<TvWatchlistBloc, TvWatchlistState>(
      "Should emit [Loading, Error] when remove movie is unsuccessful",
      build: () {
        when(mockRemoveWatchlistTv.execute(testTvSeriesDetail))
            .thenAnswer((_) async => Left(ServerFailure("Server Failure")));
        return tvWatchlistBloc;
      },
      act: (bloc) => bloc.add(OnRemoveWatchlistTv(testTvSeriesDetail)),
      expect: () => [
        TvWatchlistLoading(),
        const TvWatchlistError("Server Failure"),
      ],
      verify: (bloc) =>
          verify(mockRemoveWatchlistTv.execute(testTvSeriesDetail)),
    );
  });

  group("Load Watchlist Movie", () {
    blocTest<TvWatchlistBloc, TvWatchlistState>(
      "Should emit [Loading, Load(true)] when data is gotten successfully",
      build: () {
        when(mockGetWatchListStatusTv.execute(tId))
            .thenAnswer((realInvocation) async => true);
        return tvWatchlistBloc;
      },
      act: (bloc) => bloc.add(const OnLoadWatchlistStatusTv(tId)),
      expect: () => [
        TvWatchlistLoading(),
        const TvLoadWatchlist(true),
      ],
      verify: (bloc) => verify(mockGetWatchListStatusTv.execute(tId)),
    );

    blocTest<TvWatchlistBloc, TvWatchlistState>(
      "Should emit [Loading, Load(false)] when remove movie is unsuccessful",
      build: () {
        when(mockGetWatchListStatusTv.execute(tId))
            .thenAnswer((realInvocation) async => false);
        return tvWatchlistBloc;
      },
      act: (bloc) => bloc.add(const OnLoadWatchlistStatusTv(tId)),
      expect: () => [
        TvWatchlistLoading(),
        const TvLoadWatchlist(false),
      ],
    );
  });
}
