import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tvseries.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tvseries.dart';
import 'package:flutter/foundation.dart';

class PlayingTvSeriesNotifier extends ChangeNotifier {
  final GetNowPlayingTvSeries getNowPlayingTvSeries;

  PlayingTvSeriesNotifier(this.getNowPlayingTvSeries);

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<TvSeries> _tvseries = [];
  List<TvSeries> get tvseries => _tvseries;

  String _message = '';
  String get message => _message;

  Future<void> fetchPlayingTvSeries() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getNowPlayingTvSeries.execute();

    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
      (tvseriesData) {
        _tvseries = tvseriesData;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
