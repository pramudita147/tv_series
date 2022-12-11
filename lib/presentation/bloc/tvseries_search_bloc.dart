import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tvseries.dart';
import 'package:ditonton/domain/usecases/search_tvseries.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

class TvSearchBloc extends Bloc<TvSearchEvent, TvSearchState> {
  final SearchTvSeries searchTv;

  TvSearchBloc(this.searchTv) : super(TvSearchEmpty()) {
    on<OnQueryTvChanged>((event, emit) async {
      final query = event.query;

      emit(TvSearchLoading());
      final result = await searchTv.execute(query);

      result.fold(
        (failure) {
          emit(TvSearchError(failure.message));
        },
        (data) {
          if (data.isEmpty) {
            emit(TvSearchEmpty());
          } else {
            emit(TvSearchLoaded(data));
          }
        },
      );
    }, transformer: debounceTv(const Duration(milliseconds: 500)));

    on<ResetTvSearch>(
      (event, emit) async {
        emit(TvSearchEmpty());
      },
    );
  }
}

abstract class TvSearchEvent extends Equatable {
  const TvSearchEvent();

  @override
  List<Object> get props => [];
}

class OnQueryTvChanged extends TvSearchEvent {
  final String query;

  const OnQueryTvChanged(this.query);

  @override
  List<Object> get props => [query];
}

EventTransformer<T> debounceTv<T>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
}

class ResetTvSearch extends TvSearchEvent {}

class TvSearchState extends Equatable {
  @override
  List<Object> get props => [];
}

class TvSearchEmpty extends TvSearchState {}

class TvSearchLoading extends TvSearchState {}

class TvSearchLoaded extends TvSearchState {
  final List<TvSeries> result;

  TvSearchLoaded(this.result);

  @override
  List<Object> get props => [result];
}

class TvSearchError extends TvSearchState {
  final String message;

  TvSearchError(this.message);

  @override
  List<Object> get props => [];
}
