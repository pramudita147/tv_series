import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ditonton/presentation/bloc/tvseries_top_rated_bloc.dart';
import 'package:ditonton/presentation/pages/top_rated_tvseries_page.dart';
import '../../dummy_data/tvseries_dummy_objects.dart';
import '../../helpers/test_tv_bloc_helper.dart';

void main() {
  late TvTopRatedBlocHelper tvTopRatedBlocHelper;

  setUp(() {
    registerFallbackValue(TvTopRatedStateHelper());
    registerFallbackValue(TvTopRatedEventHelper());
    tvTopRatedBlocHelper = TvTopRatedBlocHelper();
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TvTopRatedBloc>(
          create: (_) => tvTopRatedBlocHelper,
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
      when(() => tvTopRatedBlocHelper.state).thenReturn(TvTopRatedLoading());

      final circularProgressIndicator = find.byType(CircularProgressIndicator);

      await tester.pumpWidget(
        makeTestableWidget(TopRatedTvSeriesPage()),
      );

      expect(circularProgressIndicator, findsOneWidget);
    }),
  );

  testWidgets(
    'Page should display ListView when data is loaded',
    ((WidgetTester tester) async {
      when(() => tvTopRatedBlocHelper.state).thenReturn(TvTopRatedLoading());
      when(() => tvTopRatedBlocHelper.state)
          .thenReturn(TvTopRatedLoaded(testTvSeriesList));

      final listview = find.byType(ListView);

      await tester.pumpWidget(
        makeTestableWidget(TopRatedTvSeriesPage()),
      );

      expect(listview, findsOneWidget);
    }),
  );
}
