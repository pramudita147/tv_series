import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton/presentation/bloc/tvseries_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tvseries_now_playing_bloc.dart';
import 'package:ditonton/presentation/bloc/tvseries_popular_bloc.dart';
import 'package:ditonton/presentation/bloc/tvseries_recommendations_bloc.dart';
import 'package:ditonton/presentation/bloc/tvseries_top_rated_bloc.dart';
import 'package:ditonton/presentation/bloc/tvseries_watchlist_bloc.dart';

class TvDetailStateHelper extends Fake implements TvDetailState {}

class TvDetailEventHelper extends Fake implements TvDetailEvent {}

class TvDetailBlocHelper extends MockBloc<TvDetailEvent, TvDetailState>
    implements TvDetailBloc {}

class TvRecommendationsStateHelper extends Fake
    implements TvRecommendationsState {}

class TvRecommendationsEventHelper extends Fake
    implements TvRecommendationsEvent {}

class TvRecommendationsBlocHelper
    extends MockBloc<TvRecommendationsEvent, TvRecommendationsState>
    implements TvRecommendationsBloc {}

class TvWatchlistStateHelper extends Fake implements TvWatchlistState {}

class TvWatchlistEventHelper extends Fake implements TvWatchlistEvent {}

class TvWatchlistBlocHelper extends MockBloc<TvWatchlistEvent, TvWatchlistState>
    implements TvWatchlistBloc {}

class TvNowPlayingStateHelper extends Fake implements TvNowPlayingState {}

class TvNowPlayingEventHelper extends Fake implements TvNowPlayingEvent {}

class TvNowPlayingBlocHelper
    extends MockBloc<TvNowPlayingEvent, TvNowPlayingState>
    implements TvNowPlayingBloc {}

class TvTopRatedStateHelper extends Fake implements TvTopRatedState {}

class TvTopRatedEventHelper extends Fake implements TvTopRatedEvent {}

class TvTopRatedBlocHelper extends MockBloc<TvTopRatedEvent, TvTopRatedState>
    implements TvTopRatedBloc {}

class TvPopularStateHelper extends Fake implements TvPopularState {}

class TvPopularEventHelper extends Fake implements TvPopularEvent {}

class TvPopularBlocHelper extends MockBloc<TvPopularEvent, TvPopularState>
    implements TvPopularBloc {}
