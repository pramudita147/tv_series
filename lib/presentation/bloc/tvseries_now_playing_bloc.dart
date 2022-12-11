import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tvseries.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tvseries.dart';
import 'package:equatable/equatable.dart';

class TvNowPlayingBloc extends Bloc<TvNowPlayingEvent, TvNowPlayingState> {
  final GetNowPlayingTvSeries getNowPlayingTv;

  TvNowPlayingBloc(this.getNowPlayingTv) : super(TvNowPlayingEmpty()) {
    on<FetchNowPlayingTv>((event, emit) async {
      emit(TvNowPlayingLoading());
      final result = await getNowPlayingTv.execute();

      result.fold(
        (failure) {
          emit(TvNowPlayingError(failure.message));
        },
        (data) {
          if (data.isEmpty) {
            emit(TvNowPlayingEmpty());
          } else {
            emit(TvNowPlayingLoaded(data));
          }
        },
      );
    });
  }
}

abstract class TvNowPlayingEvent extends Equatable {
  const TvNowPlayingEvent();

  @override
  List<Object> get props => [];
}

class FetchNowPlayingTv extends TvNowPlayingEvent {}

class TvNowPlayingState extends Equatable {
  @override
  List<Object> get props => [];
}

class TvNowPlayingEmpty extends TvNowPlayingState {}

class TvNowPlayingLoading extends TvNowPlayingState {}

class TvNowPlayingLoaded extends TvNowPlayingState {
  final List<TvSeries> result;

  TvNowPlayingLoaded(this.result);

  @override
  List<Object> get props => [result];
}

class TvNowPlayingError extends TvNowPlayingState {
  final String message;

  TvNowPlayingError(this.message);

  @override
  List<Object> get props => [];
}
