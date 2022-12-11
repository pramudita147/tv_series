import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton/presentation/bloc/movie_detail_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ditonton/presentation/bloc/movie_recommendations_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_watchlist_bloc.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_movies_bloc_helper.dart';

void main() {
  late MovieDetailBlocHelper movieDetailBlocHelper;
  late MovieRecommendationsBlocHelper movieRecommendationsBlocHelper;
  late MovieWatchlistBlocHelper movieWatchlistBlocHelper;

  setUp(() {
    registerFallbackValue(MoviesDetailStateHelper());
    registerFallbackValue(MoviesDetailEventHelper());
    movieDetailBlocHelper = MovieDetailBlocHelper();

    registerFallbackValue(MoviesRecommendationsStateHelper());
    registerFallbackValue(MoviesRecommendationsEventHelper());
    movieRecommendationsBlocHelper = MovieRecommendationsBlocHelper();

    registerFallbackValue(MoviesWatchlistStateHelper());
    registerFallbackValue(MoviesWatchlistEventHelper());
    movieWatchlistBlocHelper = MovieWatchlistBlocHelper();
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MoviesDetailBloc>(
          create: (_) => movieDetailBlocHelper,
        ),
        BlocProvider<MoviesRecommendationsBloc>(
          create: (_) => movieRecommendationsBlocHelper,
        ),
        BlocProvider<MovieWatchlistBloc>(
          create: (_) => movieWatchlistBlocHelper,
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
      when(() => movieDetailBlocHelper.state).thenReturn(MoviesDetailLoading());
      when(() => movieRecommendationsBlocHelper.state)
          .thenReturn(MoviesRecommendationsLoading());
      when(() => movieWatchlistBlocHelper.state)
          .thenReturn(MoviesWatchlistLoading());

      final circularProgressIndicator = find.byType(CircularProgressIndicator);

      await tester.pumpWidget(
        makeTestableWidget(
          MovieDetailPage(
            id: 1,
          ),
        ),
      );

      await tester.pump();

      expect(circularProgressIndicator, findsOneWidget);
    }),
  );

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    when(() => movieDetailBlocHelper.state).thenReturn(
      MoviesDetailLoaded(testMovieDetail),
    );
    when(() => movieRecommendationsBlocHelper.state).thenReturn(
      MoviesRecommendationsLoaded(testMovieList),
    );
    when(() => movieWatchlistBlocHelper.state).thenReturn(
      const MoviesLoadWatchlist(false),
    );

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

    await tester.pump();

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when movie is added to wathclist',
      (WidgetTester tester) async {
    when(() => movieDetailBlocHelper.state).thenReturn(
      MoviesDetailLoaded(testMovieDetail),
    );
    when(() => movieRecommendationsBlocHelper.state).thenReturn(
      MoviesRecommendationsLoaded(testMovieList),
    );
    when(() => movieWatchlistBlocHelper.state).thenReturn(
      const MoviesLoadWatchlist(true),
    );

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

    await tester.pump();

    expect(watchlistButtonIcon, findsOneWidget);
  });
}
