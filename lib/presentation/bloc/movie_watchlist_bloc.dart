import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:equatable/equatable.dart';

class MovieWatchlistBloc
    extends Bloc<MovieWatchlistEvent, MovieWatchlistState> {
  final GetWatchlistMovies getWatchlistMovies;
  final GetWatchListStatus getWatchListStatusMovies;
  final SaveWatchlist saveWatchlistMovies;
  final RemoveWatchlist removeWatchlistMovies;

  static const messageAddedToWatchlist = "Added to Watchlist";
  static const messageRemoveToWatchlist = "Removed from Watchlist";

  MovieWatchlistBloc(
    this.getWatchlistMovies,
    this.getWatchListStatusMovies,
    this.saveWatchlistMovies,
    this.removeWatchlistMovies,
  ) : super(MoviesWatchlistEmpty()) {
    // On Watchlist
    on<FetchWatchlistMovies>((event, emit) async {
      emit(MoviesWatchlistLoading());

      final result = await getWatchlistMovies.execute();

      result.fold((failure) => emit(MoviesWatchlistError(failure.message)),
          (data) {
        if (data.isEmpty) {
          emit(MoviesWatchlistEmpty());
        } else {
          emit(MoviesWatchlistLoaded(data));
        }
      });
    });

    // On Load Status
    on<OnLoadWatchlistStatusMovies>((event, emit) async {
      final id = event.id;
      emit(MoviesWatchlistLoading());
      final result = await getWatchListStatusMovies.execute(id);
      emit(MoviesLoadWatchlist(result));
    });

    //  On Save Watchlist
    on<OnSaveWatchlistMovies>((event, emit) async {
      final movie = event.movie;
      emit(MoviesWatchlistLoading());
      final result = await saveWatchlistMovies.execute(movie);
      result.fold(
        (failure) => emit(MoviesWatchlistError(failure.message)),
        (message) => emit(MoviesWatchlistMessage(message)),
      );
    });

    // On Remove Watchlist
    on<OnRemoveWatchlistMovies>((event, emit) async {
      final movie = event.movie;
      emit(MoviesWatchlistLoading());
      final result = await removeWatchlistMovies.execute(movie);
      result.fold(
        (failure) => emit(MoviesWatchlistError(failure.message)),
        (message) => emit(MoviesWatchlistMessage(message)),
      );
    });
  }
}

abstract class MovieWatchlistEvent extends Equatable {
  const MovieWatchlistEvent();

  @override
  List<Object> get props => [];
}

// Watchlist Movie
class FetchWatchlistMovies extends MovieWatchlistEvent {}

// Save Watchlist Movie Event
class OnSaveWatchlistMovies extends MovieWatchlistEvent {
  final MovieDetail movie;

  const OnSaveWatchlistMovies(this.movie);

  @override
  List<Object> get props => [movie];
}

// Remove Watchlist Movie Event
class OnRemoveWatchlistMovies extends MovieWatchlistEvent {
  final MovieDetail movie;

  const OnRemoveWatchlistMovies(this.movie);

  @override
  List<Object> get props => [movie];
}

// Load Watchlist Movie Event
class OnLoadWatchlistStatusMovies extends MovieWatchlistEvent {
  final int id;

  const OnLoadWatchlistStatusMovies(this.id);

  @override
  List<Object> get props => [id];
}

abstract class MovieWatchlistState extends Equatable {
  const MovieWatchlistState();

  @override
  List<Object> get props => [];
}

class MoviesWatchlistEmpty extends MovieWatchlistState {}

class MoviesWatchlistLoading extends MovieWatchlistState {}

class MoviesWatchlistError extends MovieWatchlistState {
  final String message;

  const MoviesWatchlistError(this.message);

  @override
  List<Object> get props => [message];
}

class MoviesWatchlistLoaded extends MovieWatchlistState {
  final List<Movie> watchlist;

  const MoviesWatchlistLoaded(this.watchlist);

  @override
  List<Object> get props => [watchlist];
}

class MoviesWatchlistMessage extends MovieWatchlistState {
  final String message;

  const MoviesWatchlistMessage(this.message);

  @override
  List<Object> get props => [message];
}

class MoviesLoadWatchlist extends MovieWatchlistState {
  final bool isWatchlist;

  const MoviesLoadWatchlist(this.isWatchlist);

  @override
  List<Object> get props => [isWatchlist];
}
