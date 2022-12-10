import 'package:ditonton/domain/entities/tvseries.dart';
import 'package:ditonton/domain/entities/tvseries_detail.dart';
import 'package:ditonton/domain/usecases/get_tvseries_detail.dart';
import 'package:ditonton/domain/usecases/get_tvseries_recommendations.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tvseries_status.dart';
import 'package:ditonton/domain/usecases/remove_tvseries_watchlist.dart';
import 'package:ditonton/domain/usecases/save_tvseries_watchlist.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TvSeriesDetailNotifier extends ChangeNotifier {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTvSeriesDetail getTvSeriesDetail;
  final GetTvSeriesRecommendations getTvSeriesRecommendations;
  final GetWatchListStatusTvSeries getWatchListStatusTvSeries;
  final SaveWatchlistTvSeries saveWatchlistTvSeries;
  final RemoveWatchlistTvSeries removeWatchlistTvSeries;

  TvSeriesDetailNotifier({
    required this.getTvSeriesDetail,
    required this.getTvSeriesRecommendations,
    required this.getWatchListStatusTvSeries,
    required this.saveWatchlistTvSeries,
    required this.removeWatchlistTvSeries,
  });

  late TvSeriesDetail _tvseries;
  TvSeriesDetail get tvseries => _tvseries;

  RequestState _tvseriesState = RequestState.Empty;
  RequestState get tvseriesState => _tvseriesState;

  List<TvSeries> _tvseriesRecommendations = [];
  List<TvSeries> get tvseriesRecommendations => _tvseriesRecommendations;

  RequestState _recommendationState = RequestState.Empty;
  RequestState get recommendationState => _recommendationState;

  String _message = '';
  String get message => _message;

  bool _isAddedtoWatchlist = false;
  bool get isAddedToWatchlist => _isAddedtoWatchlist;

  Future<void> fetchTvSeriesDetail(int id) async {
    _tvseriesState = RequestState.Loading;
    notifyListeners();
    final detailResult = await getTvSeriesDetail.execute(id);
    final recommendationResult = await getTvSeriesRecommendations.execute(id);
    detailResult.fold(
      (failure) {
        _tvseriesState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvseries) {
        _recommendationState = RequestState.Loading;
        _tvseries = tvseries;
        notifyListeners();
        recommendationResult.fold(
          (failure) {
            _recommendationState = RequestState.Error;
            _message = failure.message;
          },
          (tvserie) {
            _recommendationState = RequestState.Loaded;
            _tvseriesRecommendations = tvserie;
          },
        );
        _tvseriesState = RequestState.Loaded;
        notifyListeners();
      },
    );
  }

  String _watchlistMessage = '';
  String get watchlistMessage => _watchlistMessage;

  Future<void> addWatchlistTvSeries(TvSeriesDetail tvseries) async {
    final result = await saveWatchlistTvSeries.execute(tvseries);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(tvseries.id);
  }

  Future<void> removeFromWatchlistTvSeries(TvSeriesDetail tvseries) async {
    final result = await removeWatchlistTvSeries.execute(tvseries);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(tvseries.id);
  }

  Future<void> loadWatchlistStatus(int id) async {
    final result = await getWatchListStatusTvSeries.execute(id);
    _isAddedtoWatchlist = result;
    notifyListeners();
  }
}
