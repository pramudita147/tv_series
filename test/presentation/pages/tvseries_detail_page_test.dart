import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ditonton/presentation/bloc/tvseries_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tvseries_recommendations_bloc.dart';
import 'package:ditonton/presentation/bloc/tvseries_watchlist_bloc.dart';
import 'package:ditonton/presentation/pages/tvseries_detail_page.dart';
import '../../dummy_data/tvseries_dummy_objects.dart';
import '../../helpers/test_tv_bloc_helper.dart';

void main() {
  late TvDetailBlocHelper tvDetailBlocHelper;
  late TvRecommendationsBlocHelper tvRecommendationsBlocHelper;
  late TvWatchlistBlocHelper tvWatchlistBlocHelper;

  setUp(() {
    registerFallbackValue(TvDetailStateHelper());
    registerFallbackValue(TvDetailEventHelper());
    tvDetailBlocHelper = TvDetailBlocHelper();

    registerFallbackValue(TvRecommendationsStateHelper());
    registerFallbackValue(TvRecommendationsEventHelper());
    tvRecommendationsBlocHelper = TvRecommendationsBlocHelper();

    registerFallbackValue(TvWatchlistStateHelper());
    registerFallbackValue(TvWatchlistEventHelper());
    tvWatchlistBlocHelper = TvWatchlistBlocHelper();
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TvDetailBloc>(
          create: (_) => tvDetailBlocHelper,
        ),
        BlocProvider<TvRecommendationsBloc>(
          create: (_) => tvRecommendationsBlocHelper,
        ),
        BlocProvider<TvWatchlistBloc>(
          create: (_) => tvWatchlistBlocHelper,
        ),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
    'Page should display center progress bar when loading',
    ((WidgetTester tester) async {
      when(() => tvDetailBlocHelper.state).thenReturn(TvDetailLoading());
      when(() => tvRecommendationsBlocHelper.state)
          .thenReturn(TvRecommendationsLoading());
      when(() => tvWatchlistBlocHelper.state).thenReturn(TvWatchlistLoading());

      final circularProgressIndicator = find.byType(CircularProgressIndicator);

      await tester.pumpWidget(
        makeTestableWidget(
          TvSeriesDetailPage(
            id: 1,
          ),
        ),
      );

      await tester.pump();

      expect(circularProgressIndicator, findsOneWidget);
    }),
  );

  testWidgets(
      'Watchlist button should display add icon when tv not added to watchlist',
      (WidgetTester tester) async {
    when(() => tvDetailBlocHelper.state).thenReturn(
      TvDetailLoaded(testTvSeriesDetail),
    );
    when(() => tvRecommendationsBlocHelper.state).thenReturn(
      TvRecommendationsLoaded(testTvSeriesList),
    );
    when(() => tvWatchlistBlocHelper.state).thenReturn(
      const TvLoadWatchlist(false),
    );

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(makeTestableWidget(TvSeriesDetailPage(id: 1)));

    await tester.pump();

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when tv is added to wathclist',
      (WidgetTester tester) async {
    when(() => tvDetailBlocHelper.state).thenReturn(
      TvDetailLoaded(testTvSeriesDetail),
    );
    when(() => tvRecommendationsBlocHelper.state).thenReturn(
      TvRecommendationsLoaded(testTvSeriesList),
    );
    when(() => tvWatchlistBlocHelper.state).thenReturn(
      const TvLoadWatchlist(true),
    );

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(makeTestableWidget(TvSeriesDetailPage(id: 1)));

    await tester.pump();

    expect(watchlistButtonIcon, findsOneWidget);
  });
}
