import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/popular_tvseries_notifier.dart';
import 'package:ditonton/presentation/widgets/tvseries_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecommendationTvSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/recommendationTv';

  @override
  _RecommendationTvSeriesPageState createState() =>
      _RecommendationTvSeriesPageState();
}

class _RecommendationTvSeriesPageState
    extends State<RecommendationTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<PopularTvSeriesNotifier>(context, listen: false)
            .fetchPopularTvSeries());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recommendations TV Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<PopularTvSeriesNotifier>(
          builder: (context, data, child) {
            if (data.state == RequestState.Loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (data.state == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvseries = data.tvseries[index];
                  return TvSeriesCard(tvseries);
                },
                itemCount: data.tvseries.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text(data.message),
              );
            }
          },
        ),
      ),
    );
  }
}
