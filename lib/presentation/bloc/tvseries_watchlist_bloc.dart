import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tvseries.dart';
import 'package:ditonton/domain/entities/tvseries_detail.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tvseries.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tvseries_status.dart';
import 'package:ditonton/domain/usecases/remove_tvseries_watchlist.dart';
import 'package:ditonton/domain/usecases/save_tvseries_watchlist.dart';
import 'package:equatable/equatable.dart';

class TvWatchlistBloc extends Bloc<TvWatchlistEvent, TvWatchlistState> {
  final GetWatchlistTvSeries _getWatchlistTv;
  final GetWatchListStatusTvSeries _getWatchListStatusTv;
  final SaveWatchlistTvSeries _saveWatchlistTv;
  final RemoveWatchlistTvSeries _removeWatchlistTv;

  static const messageAddedToWatchlist = "Added to Watchlist";
  static const messageRemoveToWatchlist = "Removed from Watchlist";

  TvWatchlistBloc(
    this._getWatchlistTv,
    this._getWatchListStatusTv,
    this._saveWatchlistTv,
    this._removeWatchlistTv,
  ) : super(TvWatchlistEmpty()) {
    // On Watchlist
    on<FetchWatchlistTv>((event, emit) async {
      emit(TvWatchlistLoading());

      final result = await _getWatchlistTv.execute();

      result.fold((failure) => emit(TvWatchlistError(failure.message)), (data) {
        if (data.isEmpty) {
          emit(TvWatchlistEmpty());
        } else {
          emit(TvWatchlistLoaded(data));
        }
      });
    });

    on<OnLoadWatchlistStatusTv>((event, emit) async {
      final id = event.id;
      emit(TvWatchlistLoading());
      final result = await _getWatchListStatusTv.execute(id);
      emit(TvLoadWatchlist(result));
    });

    on<OnSaveWatchlistTv>((event, emit) async {
      final movie = event.tv;
      emit(TvWatchlistLoading());
      final result = await _saveWatchlistTv.execute(movie);
      result.fold(
        (failure) => emit(TvWatchlistError(failure.message)),
        (message) => emit(TvWatchlistMessage(message)),
      );
    });

    on<OnRemoveWatchlistTv>((event, emit) async {
      final movie = event.tv;
      emit(TvWatchlistLoading());
      final result = await _removeWatchlistTv.execute(movie);
      result.fold(
        (failure) => emit(TvWatchlistError(failure.message)),
        (message) => emit(TvWatchlistMessage(message)),
      );
    });
  }
}

abstract class TvWatchlistEvent extends Equatable {
  const TvWatchlistEvent();

  @override
  List<Object> get props => [];
}

// Watchlist Movie
class FetchWatchlistTv extends TvWatchlistEvent {}

class OnSaveWatchlistTv extends TvWatchlistEvent {
  final TvSeriesDetail tv;

  const OnSaveWatchlistTv(this.tv);

  @override
  List<Object> get props => [tv];
}

class OnRemoveWatchlistTv extends TvWatchlistEvent {
  final TvSeriesDetail tv;

  const OnRemoveWatchlistTv(this.tv);

  @override
  List<Object> get props => [tv];
}

class OnLoadWatchlistStatusTv extends TvWatchlistEvent {
  final int id;

  const OnLoadWatchlistStatusTv(this.id);

  @override
  List<Object> get props => [id];
}

abstract class TvWatchlistState extends Equatable {
  const TvWatchlistState();

  @override
  List<Object> get props => [];
}

class TvWatchlistEmpty extends TvWatchlistState {}

class TvWatchlistLoading extends TvWatchlistState {}

class TvWatchlistError extends TvWatchlistState {
  final String message;

  const TvWatchlistError(this.message);

  @override
  List<Object> get props => [message];
}

class TvWatchlistLoaded extends TvWatchlistState {
  final List<TvSeries> watchlist;

  const TvWatchlistLoaded(this.watchlist);

  @override
  List<Object> get props => [watchlist];
}

class TvWatchlistMessage extends TvWatchlistState {
  final String message;

  const TvWatchlistMessage(this.message);

  @override
  List<Object> get props => [message];
}

class TvLoadWatchlist extends TvWatchlistState {
  final bool isWatchlist;

  const TvLoadWatchlist(this.isWatchlist);

  @override
  List<Object> get props => [isWatchlist];
}
