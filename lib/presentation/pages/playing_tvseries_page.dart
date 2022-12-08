import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/playing_tvseries_notifier.dart';
import 'package:ditonton/presentation/widgets/tvseries_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayingTvSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/playing-tv';

  @override
  _PlayingTvSeriesPageState createState() => _PlayingTvSeriesPageState();
}

class _PlayingTvSeriesPageState extends State<PlayingTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<PlayingTvSeriesNotifier>(context, listen: false)
            .fetchPlayingTvSeries());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Playing Tv Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<PlayingTvSeriesNotifier>(
          builder: (context, data, child) {
            if (data.state == RequestState.Loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (data.state == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvserie = data.tvseries[index];
                  return TvSeriesCard(tvserie);
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
