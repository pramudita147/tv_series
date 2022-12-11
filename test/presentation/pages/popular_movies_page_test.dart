import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ditonton/presentation/bloc/movie_popular_bloc.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_movies_bloc_helper.dart';

void main() {
  late MoviesPopularBlocHelper moviesPopularBlocHelper;

  setUp(() {
    registerFallbackValue(MoviesPopularStateHelper());
    registerFallbackValue(MoviesPopularEventHelper());
    moviesPopularBlocHelper = MoviesPopularBlocHelper();
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MoviesPopularBloc>(
          create: (_) => moviesPopularBlocHelper,
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
      when(() => moviesPopularBlocHelper.state)
          .thenReturn(MoviesPopularLoading());

      final circularProgressIndicator = find.byType(CircularProgressIndicator);

      await tester.pumpWidget(
        makeTestableWidget(PopularMoviesPage()),
      );

      expect(circularProgressIndicator, findsOneWidget);
    }),
  );

  testWidgets(
    'Page should display ListView when data is loaded',
    ((WidgetTester tester) async {
      when(() => moviesPopularBlocHelper.state)
          .thenReturn(MoviesPopularLoading());
      when(() => moviesPopularBlocHelper.state)
          .thenReturn(MoviesPopularLoaded(testMovieList));

      final listview = find.byType(ListView);

      await tester.pumpWidget(
        makeTestableWidget(PopularMoviesPage()),
      );

      expect(listview, findsOneWidget);
    }),
  );

  testWidgets(
    'Page should display text with message when Error',
    ((WidgetTester tester) async {
      when(() => moviesPopularBlocHelper.state)
          .thenReturn(MoviesPopularLoading());
      when(() => moviesPopularBlocHelper.state)
          .thenReturn(MoviesPopularError("Error Message"));

      final key = find.byKey(Key('Error Message'));

      await tester.pumpWidget(
        makeTestableWidget(PopularMoviesPage()),
      );

      expect(key, findsOneWidget);
    }),
  );
}
