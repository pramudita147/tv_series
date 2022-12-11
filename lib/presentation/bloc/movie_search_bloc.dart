import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

class MoviesSearchBloc extends Bloc<MoviesSearchEvent, MoviesSearchState> {
  final SearchMovies searchMovies;

  MoviesSearchBloc(this.searchMovies) : super(MoviesSearchEmpty()) {
    on<OnQueryMoviesChanged>((event, emit) async {
      final query = event.query;

      emit(MoviesSearchLoading());
      final result = await searchMovies.execute(query);

      result.fold(
        (failure) {
          emit(MoviesSearchError(failure.message));
        },
        (data) {
          if (data.isEmpty) {
            emit(MoviesSearchEmpty());
          } else {
            emit(MoviesSearchLoaded(data));
          }
        },
      );
    }, transformer: debounceMovies(const Duration(milliseconds: 500)));

    on<ResetMoviesSearch>(
      (event, emit) async {
        emit(MoviesSearchEmpty());
      },
    );
  }
}

abstract class MoviesSearchEvent extends Equatable {
  const MoviesSearchEvent();

  @override
  List<Object> get props => [];
}

class OnQueryMoviesChanged extends MoviesSearchEvent {
  final String query;

  const OnQueryMoviesChanged(this.query);

  @override
  List<Object> get props => [query];
}

EventTransformer<T> debounceMovies<T>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
}

class ResetMoviesSearch extends MoviesSearchEvent {}

class MoviesSearchState extends Equatable {
  @override
  List<Object> get props => [];
}

class MoviesSearchEmpty extends MoviesSearchState {}

class MoviesSearchLoading extends MoviesSearchState {}

class MoviesSearchLoaded extends MoviesSearchState {
  final List<Movie> result;

  MoviesSearchLoaded(this.result);

  @override
  List<Object> get props => [result];
}

class MoviesSearchError extends MoviesSearchState {
  final String message;

  MoviesSearchError(this.message);

  @override
  List<Object> get props => [];
}
