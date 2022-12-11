import 'package:ditonton/presentation/bloc/tvseries_popular_bloc.dart';
import 'package:ditonton/presentation/widgets/tvseries_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularTvSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/popularTv';

  @override
  _PopularTvSeriesPageState createState() => _PopularTvSeriesPageState();
}

class _PopularTvSeriesPageState extends State<PopularTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<TvPopularBloc>().add(FetchPopularTv()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Popular TV Series'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<TvPopularBloc, TvPopularState>(
            builder: (context, state) {
              if (state is TvPopularLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is TvPopularLoaded) {
                final result = state.result;
                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final tvseries = result[index];
                    return TvSeriesCard(tvseries);
                  },
                  itemCount: result.length,
                );
              } else {
                return const Center(
                  child: Text('No Data'),
                );
              }
            },
          ),
        ));
  }
}
