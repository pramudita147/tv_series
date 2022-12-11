import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:equatable/equatable.dart';

class MoviesNowPlayingBloc
    extends Bloc<MoviesNowPlayingEvent, MoviesNowPlayingState> {
  final GetNowPlayingMovies getNowPlayingMovies;

  MoviesNowPlayingBloc(this.getNowPlayingMovies)
      : super(MoviesNowPlayingEmpty()) {
    on<FetchNowPlayingMovies>((event, emit) async {
      emit(MoviesNowPlayingLoading());
      final result = await getNowPlayingMovies.execute();

      result.fold(
        (failure) {
          emit(MoviesNowPlayingError(failure.message));
        },
        (data) {
          if (data.isEmpty) {
            emit(MoviesNowPlayingEmpty());
          } else {
            emit(MoviesNowPlayingLoaded(data));
          }
        },
      );
    });
  }
}

abstract class MoviesNowPlayingEvent extends Equatable {
  const MoviesNowPlayingEvent();

  @override
  List<Object> get props => [];
}

class FetchNowPlayingMovies extends MoviesNowPlayingEvent {}

class MoviesNowPlayingState extends Equatable {
  @override
  List<Object> get props => [];
}

class MoviesNowPlayingEmpty extends MoviesNowPlayingState {}

class MoviesNowPlayingLoading extends MoviesNowPlayingState {}

class MoviesNowPlayingLoaded extends MoviesNowPlayingState {
  final List<Movie> result;

  MoviesNowPlayingLoaded(this.result);

  @override
  List<Object> get props => [result];
}

class MoviesNowPlayingError extends MoviesNowPlayingState {
  final String message;

  MoviesNowPlayingError(this.message);

  @override
  List<Object> get props => [];
}
