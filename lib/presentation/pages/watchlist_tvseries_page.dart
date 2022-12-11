import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/bloc/tvseries_watchlist_bloc.dart';
import 'package:ditonton/presentation/widgets/tvseries_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistTvSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-tv';

  @override
  _WatchlistTvSeriesPageState createState() => _WatchlistTvSeriesPageState();
}

class _WatchlistTvSeriesPageState extends State<WatchlistTvSeriesPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<TvWatchlistBloc>().add(FetchWatchlistTv()));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    context.read<TvWatchlistBloc>().add(FetchWatchlistTv());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist TV Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TvWatchlistBloc, TvWatchlistState>(
          builder: (context, state) {
            if (state is TvWatchlistLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TvWatchlistLoaded) {
              final result = state.watchlist;
              return ListView.builder(
                padding: const EdgeInsets.all(8),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final tvseries = result[index];
                  return TvSeriesCard(tvseries);
                },
                itemCount: result.length,
              );
            } else if (state is TvWatchlistError) {
              return Center(child: Text(state.message));
            } else if (state is TvWatchlistEmpty) {
              return Center(child: Text("Watchlist Tv Series Empty"));
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
