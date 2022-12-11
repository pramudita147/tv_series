import 'package:ditonton/presentation/bloc/tvseries_now_playing_bloc.dart';
import 'package:ditonton/presentation/widgets/tvseries_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayingTvSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/playing-tv';

  @override
  _PlayingTvSeriesPageState createState() => _PlayingTvSeriesPageState();
}

class _PlayingTvSeriesPageState extends State<PlayingTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<TvNowPlayingBloc>().add(FetchNowPlayingTv()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Playing Tv Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TvNowPlayingBloc, TvNowPlayingState>(
          builder: (context, state) {
            if (state is TvNowPlayingLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TvNowPlayingLoaded) {
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
      ),
    );
  }
}
