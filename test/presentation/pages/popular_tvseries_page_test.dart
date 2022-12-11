import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ditonton/presentation/bloc/tvseries_popular_bloc.dart';
import 'package:ditonton/presentation/pages/popular_tvseries_page.dart';
import '../../dummy_data/tvseries_dummy_objects.dart';
import '../../helpers/test_tv_bloc_helper.dart';

void main() {
  late TvPopularBlocHelper tvPopularBlocHelper;

  setUp(() {
    registerFallbackValue(TvPopularStateHelper());
    registerFallbackValue(TvPopularEventHelper());
    tvPopularBlocHelper = TvPopularBlocHelper();
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TvPopularBloc>(
          create: (_) => tvPopularBlocHelper,
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
      when(() => tvPopularBlocHelper.state).thenReturn(TvPopularLoading());

      final circularProgressIndicator = find.byType(CircularProgressIndicator);

      await tester.pumpWidget(
        makeTestableWidget(PopularTvSeriesPage()),
      );

      expect(circularProgressIndicator, findsOneWidget);
    }),
  );

  testWidgets(
    'Page should display ListView when data is loaded',
    ((WidgetTester tester) async {
      when(() => tvPopularBlocHelper.state).thenReturn(TvPopularLoading());
      when(() => tvPopularBlocHelper.state)
          .thenReturn(TvPopularLoaded(testTvSeriesList));

      final listview = find.byType(ListView);

      await tester.pumpWidget(
        makeTestableWidget(PopularTvSeriesPage()),
      );

      expect(listview, findsOneWidget);
    }),
  );
}
