import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tvseries_detail.dart';
import 'package:ditonton/domain/usecases/get_tvseries_detail.dart';
import 'package:equatable/equatable.dart';

class TvDetailBloc extends Bloc<TvDetailEvent, TvDetailState> {
  final GetTvSeriesDetail getMovieDetail;

  TvDetailBloc(
    this.getMovieDetail,
  ) : super(TvDetailLoading()) {
    on<FetchDetailTv>((event, emit) async {
      final id = event.id;
      emit(TvDetailLoading());
      final result = await getMovieDetail.execute(id);
      result.fold(
        (failure) {
          emit(TvDetailError(failure.message));
        },
        (data) {
          emit(TvDetailLoaded(data));
        },
      );
    });
  }
}

abstract class TvDetailEvent extends Equatable {
  const TvDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchDetailTv extends TvDetailEvent {
  final int id;

  const FetchDetailTv(this.id);

  @override
  List<Object> get props => [id];
}

class TvDetailState extends Equatable {
  @override
  List<Object> get props => [];
}

class TvDetailEmpty extends TvDetailState {}

class TvDetailLoading extends TvDetailState {}

class TvDetailLoaded extends TvDetailState {
  final TvSeriesDetail result;

  TvDetailLoaded(this.result);

  @override
  List<Object> get props => [result];
}

class TvDetailError extends TvDetailState {
  final String message;

  TvDetailError(this.message);

  @override
  List<Object> get props => [message];
}
