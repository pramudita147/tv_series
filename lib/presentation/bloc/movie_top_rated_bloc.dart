import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:equatable/equatable.dart';

class MoviesTopRatedBloc
    extends Bloc<MoviesTopRatedEvent, MoviesTopRatedState> {
  final GetTopRatedMovies getTopRatedMovies;

  MoviesTopRatedBloc(this.getTopRatedMovies) : super(MoviesTopRatedEmpty()) {
    on<FetchTopRatedMovies>((event, emit) async {
      emit(MoviesTopRatedLoading());
      final result = await getTopRatedMovies.execute();

      result.fold(
        (failure) {
          emit(MoviesTopRatedError(failure.message));
        },
        (data) {
          if (data.isEmpty) {
            emit(MoviesTopRatedEmpty());
          } else {
            emit(MoviesTopRatedLoaded(data));
          }
        },
      );
    });
  }
}

abstract class MoviesTopRatedEvent extends Equatable {
  const MoviesTopRatedEvent();

  @override
  List<Object> get props => [];
}

class FetchTopRatedMovies extends MoviesTopRatedEvent {}

class MoviesTopRatedState extends Equatable {
  @override
  List<Object> get props => [];
}

class MoviesTopRatedEmpty extends MoviesTopRatedState {}

class MoviesTopRatedLoading extends MoviesTopRatedState {}

class MoviesTopRatedLoaded extends MoviesTopRatedState {
  final List<Movie> result;

  MoviesTopRatedLoaded(this.result);

  @override
  List<Object> get props => [result];
}

class MoviesTopRatedError extends MoviesTopRatedState {
  final String message;

  MoviesTopRatedError(this.message);

  @override
  List<Object> get props => [];
}
