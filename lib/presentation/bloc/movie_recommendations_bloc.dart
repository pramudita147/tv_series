import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:equatable/equatable.dart';

class MoviesRecommendationsBloc
    extends Bloc<MoviesRecommendationsEvent, MoviesRecommendationsState> {
  final GetMovieRecommendations getMovieRecommendations;

  MoviesRecommendationsBloc(
    this.getMovieRecommendations,
  ) : super(MoviesRecommendationsEmpty()) {
    on<FetchRecommendationsMovies>((event, emit) async {
      final id = event.id;
      emit(MoviesRecommendationsLoading());
      final result = await getMovieRecommendations.execute(id);
      result.fold(
        (failure) {
          emit(MoviesRecommendationsError(failure.message));
        },
        (data) {
          emit(MoviesRecommendationsLoaded(data));
        },
      );
    });
  }
}

abstract class MoviesRecommendationsEvent extends Equatable {
  const MoviesRecommendationsEvent();

  @override
  List<Object> get props => [];
}

class FetchRecommendationsMovies extends MoviesRecommendationsEvent {
  final int id;

  const FetchRecommendationsMovies(this.id);

  @override
  List<Object> get props => [id];
}

class MoviesRecommendationsState extends Equatable {
  @override
  List<Object> get props => [];
}

class MoviesRecommendationsEmpty extends MoviesRecommendationsState {}

class MoviesRecommendationsLoading extends MoviesRecommendationsState {}

class MoviesRecommendationsLoaded extends MoviesRecommendationsState {
  final List<Movie> result;

  MoviesRecommendationsLoaded(this.result);

  @override
  List<Object> get props => [result];
}

class MoviesRecommendationsError extends MoviesRecommendationsState {
  final String message;

  MoviesRecommendationsError(this.message);

  @override
  List<Object> get props => [message];
}
