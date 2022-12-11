import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tvseries.dart';
import 'package:ditonton/domain/usecases/get_tvseries_recommendations.dart';
import 'package:equatable/equatable.dart';

class TvRecommendationsBloc
    extends Bloc<TvRecommendationsEvent, TvRecommendationsState> {
  final GetTvSeriesRecommendations getTvRecommendations;

  TvRecommendationsBloc(
    this.getTvRecommendations,
  ) : super(TvRecommendationsEmpty()) {
    on<FetchRecommendationsTv>((event, emit) async {
      final id = event.id;
      emit(TvRecommendationsLoading());
      final result = await getTvRecommendations.execute(id);
      result.fold(
        (failure) {
          emit(TvRecommendationsError(failure.message));
        },
        (data) {
          emit(TvRecommendationsLoaded(data));
        },
      );
    });
  }
}

abstract class TvRecommendationsEvent extends Equatable {
  const TvRecommendationsEvent();

  @override
  List<Object> get props => [];
}

class FetchRecommendationsTv extends TvRecommendationsEvent {
  final int id;

  const FetchRecommendationsTv(this.id);

  @override
  List<Object> get props => [id];
}

class TvRecommendationsState extends Equatable {
  @override
  List<Object> get props => [];
}

class TvRecommendationsEmpty extends TvRecommendationsState {}

class TvRecommendationsLoading extends TvRecommendationsState {}

class TvRecommendationsLoaded extends TvRecommendationsState {
  final List<TvSeries> result;

  TvRecommendationsLoaded(this.result);

  @override
  List<Object> get props => [result];
}

class TvRecommendationsError extends TvRecommendationsState {
  final String message;

  TvRecommendationsError(this.message);

  @override
  List<Object> get props => [message];
}
