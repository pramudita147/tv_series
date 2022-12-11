import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:equatable/equatable.dart';

class MoviesPopularBloc extends Bloc<MoviesPopularEvent, MoviesPopularState> {
  final GetPopularMovies getPopularMovies;

  MoviesPopularBloc(this.getPopularMovies) : super(MoviesPopularEmpty()) {
    on<FetchPopularMovies>((event, emit) async {
      emit(MoviesPopularLoading());
      final result = await getPopularMovies.execute();

      result.fold(
        (failure) {
          emit(MoviesPopularError(failure.message));
        },
        (data) {
          if (data.isEmpty) {
            emit(MoviesPopularEmpty());
          } else {
            emit(MoviesPopularLoaded(data));
          }
        },
      );
    });
  }
}

abstract class MoviesPopularEvent extends Equatable {
  const MoviesPopularEvent();

  @override
  List<Object> get props => [];
}

class FetchPopularMovies extends MoviesPopularEvent {}

class MoviesPopularState extends Equatable {
  @override
  List<Object> get props => [];
}

class MoviesPopularEmpty extends MoviesPopularState {}

class MoviesPopularLoading extends MoviesPopularState {}

class MoviesPopularLoaded extends MoviesPopularState {
  final List<Movie> result;

  MoviesPopularLoaded(this.result);

  @override
  List<Object> get props => [result];
}

class MoviesPopularError extends MoviesPopularState {
  final String message;

  MoviesPopularError(this.message);

  @override
  List<Object> get props => [];
}
