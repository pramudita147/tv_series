import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tvseries.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tvseries.dart';
import 'package:equatable/equatable.dart';

class TvTopRatedBloc extends Bloc<TvTopRatedEvent, TvTopRatedState> {
  final GetTopRatedTvSeries getTopRatedTv;

  TvTopRatedBloc(this.getTopRatedTv) : super(TvTopRatedEmpty()) {
    on<FetchTopRatedTv>((event, emit) async {
      emit(TvTopRatedLoading());
      final result = await getTopRatedTv.execute();

      result.fold(
        (failure) {
          emit(TvTopRatedError(failure.message));
        },
        (data) {
          if (data.isEmpty) {
            emit(TvTopRatedEmpty());
          } else {
            emit(TvTopRatedLoaded(data));
          }
        },
      );
    });
  }
}

abstract class TvTopRatedEvent extends Equatable {
  const TvTopRatedEvent();

  @override
  List<Object> get props => [];
}

class FetchTopRatedTv extends TvTopRatedEvent {}

class TvTopRatedState extends Equatable {
  @override
  List<Object> get props => [];
}

class TvTopRatedEmpty extends TvTopRatedState {}

class TvTopRatedLoading extends TvTopRatedState {}

class TvTopRatedLoaded extends TvTopRatedState {
  final List<TvSeries> result;

  TvTopRatedLoaded(this.result);

  @override
  List<Object> get props => [result];
}

class TvTopRatedError extends TvTopRatedState {
  final String message;

  TvTopRatedError(this.message);

  @override
  List<Object> get props => [];
}
