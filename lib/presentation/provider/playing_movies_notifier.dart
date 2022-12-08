import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:flutter/foundation.dart';

class PlayingMoviesNotifier extends ChangeNotifier {
  final GetNowPlayingMovies getPlayingMovies;

  PlayingMoviesNotifier(this.getPlayingMovies);

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<Movie> _movies = [];
  List<Movie> get movies => _movies;

  String _message = '';
  String get message => _message;

  Future<void> fetchPlayingMovies() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getPlayingMovies.execute();

    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
      (moviesData) {
        _movies = moviesData;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
