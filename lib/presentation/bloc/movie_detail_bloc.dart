import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';

class MoviesDetailBloc extends Bloc<MoviesDetailEvent, MoviesDetailState> {
  final GetMovieDetail getMoviesDetail;

  MoviesDetailBloc(
    this.getMoviesDetail,
  ) : super(MoviesDetailLoading()) {
    on<FetchDetailMovies>((event, emit) async {
      final id = event.id;
      emit(MoviesDetailLoading());
      final result = await getMoviesDetail.execute(id);
      result.fold(
        (failure) {
          emit(MoviesDetailError(failure.message));
        },
        (data) {
          emit(MoviesDetailLoaded(data));
        },
      );
    });
  }
}

abstract class MoviesDetailEvent extends Equatable {
  const MoviesDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchDetailMovies extends MoviesDetailEvent {
  final int id;

  const FetchDetailMovies(this.id);

  @override
  List<Object> get props => [id];
}

class MoviesDetailState extends Equatable {
  @override
  List<Object> get props => [];
}

class MoviesDetailEmpty extends MoviesDetailState {}

class MoviesDetailLoading extends MoviesDetailState {}

class MoviesDetailLoaded extends MoviesDetailState {
  final MovieDetail result;

  MoviesDetailLoaded(this.result);

  @override
  List<Object> get props => [result];
}

class MoviesDetailError extends MoviesDetailState {
  final String message;

  MoviesDetailError(this.message);

  @override
  List<Object> get props => [message];
}
