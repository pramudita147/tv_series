import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tvseries.dart';
import 'package:ditonton/domain/usecases/get_popular_tvseries.dart';
import 'package:equatable/equatable.dart';

class TvPopularBloc extends Bloc<TvPopularEvent, TvPopularState> {
  final GetPopularTvSeries getPopularTv;

  TvPopularBloc(this.getPopularTv) : super(TvPopularEmpty()) {
    on<FetchPopularTv>((event, emit) async {
      emit(TvPopularLoading());
      final result = await getPopularTv.execute();

      result.fold(
        (failure) {
          emit(TvPopularError(failure.message));
        },
        (data) {
          if (data.isEmpty) {
            emit(TvPopularEmpty());
          } else {
            emit(TvPopularLoaded(data));
          }
        },
      );
    });
  }
}

abstract class TvPopularEvent extends Equatable {
  const TvPopularEvent();

  @override
  List<Object> get props => [];
}

class FetchPopularTv extends TvPopularEvent {}

class TvPopularState extends Equatable {
  @override
  List<Object> get props => [];
}

class TvPopularEmpty extends TvPopularState {}

class TvPopularLoading extends TvPopularState {}

class TvPopularLoaded extends TvPopularState {
  final List<TvSeries> result;

  TvPopularLoaded(this.result);

  @override
  List<Object> get props => [result];
}

class TvPopularError extends TvPopularState {
  final String message;

  TvPopularError(this.message);

  @override
  List<Object> get props => [];
}
