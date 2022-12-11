import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ditonton/presentation/bloc/movie_top_rated_bloc.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_movies_bloc_helper.dart';

void main() {
  late MoviesTopRatedBlocHelper moviesTopRatedBlocHelper;

  setUp(() {
    registerFallbackValue(MoviesTopRatedStateHelper());
    registerFallbackValue(MoviesTopRatedEventHelper());
    moviesTopRatedBlocHelper = MoviesTopRatedBlocHelper();
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MoviesTopRatedBloc>(
          create: (_) => moviesTopRatedBlocHelper,
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
      when(() => moviesTopRatedBlocHelper.state)
          .thenReturn(MoviesTopRatedLoading());

      final circularProgressIndicator = find.byType(CircularProgressIndicator);

      await tester.pumpWidget(
        makeTestableWidget(TopRatedMoviesPage()),
      );

      expect(circularProgressIndicator, findsOneWidget);
    }),
  );

  testWidgets(
    'Page should display ListView when data is loaded',
    ((WidgetTester tester) async {
      when(() => moviesTopRatedBlocHelper.state)
          .thenReturn(MoviesTopRatedLoading());
      when(() => moviesTopRatedBlocHelper.state)
          .thenReturn(MoviesTopRatedLoaded(testMovieList));

      final listview = find.byType(ListView);

      await tester.pumpWidget(
        makeTestableWidget(TopRatedMoviesPage()),
      );

      expect(listview, findsOneWidget);
    }),
  );

  testWidgets(
    'Page should display text with message when Error',
    ((WidgetTester tester) async {
      when(() => moviesTopRatedBlocHelper.state)
          .thenReturn(MoviesTopRatedLoading());
      when(() => moviesTopRatedBlocHelper.state)
          .thenReturn(MoviesTopRatedError("Error Message"));

      final key = find.byKey(Key('Error Message'));

      await tester.pumpWidget(
        makeTestableWidget(TopRatedMoviesPage()),
      );

      expect(key, findsOneWidget);
    }),
  );
}
