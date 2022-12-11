import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/tvseries_detail.dart';
import 'package:ditonton/presentation/bloc/tvseries_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tvseries_watchlist_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../bloc/tvseries_recommendations_bloc.dart';

class TvSeriesDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detailTv';

  final int id;
  TvSeriesDetailPage({required this.id});

  @override
  _TvSeriesDetailPageState createState() => _TvSeriesDetailPageState();
}

class _TvSeriesDetailPageState extends State<TvSeriesDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TvDetailBloc>().add(FetchDetailTv(widget.id));
      context.read<TvWatchlistBloc>().add(OnLoadWatchlistStatusTv(widget.id));
      context
          .read<TvRecommendationsBloc>()
          .add(FetchRecommendationsTv(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isAddedToWatchlist = context.select<TvWatchlistBloc, bool>((bloc) {
      var state = bloc.state;
      if (state is TvLoadWatchlist) {
        return state.isWatchlist;
      }
      return false;
    });
    return Scaffold(
      body: BlocBuilder<TvDetailBloc, TvDetailState>(builder: (context, state) {
        if (state is TvDetailLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is TvDetailLoaded) {
          final tvseries = state.result;
          return SafeArea(
            child: DetailContent(
              tvseries: tvseries,
              isAddedWatchlist: isAddedToWatchlist,
            ),
          );
        } else if (state is TvDetailError) {
          return Center(child: Text(state.message));
        } else {
          return Container();
        }
      }),
    );
  }
}

class DetailContent extends StatelessWidget {
  final TvSeriesDetail tvseries;
  final bool isAddedWatchlist;

  const DetailContent(
      {Key? key, required this.tvseries, required this.isAddedWatchlist})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${tvseries.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tvseries.name,
                              style: kHeading5,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (!isAddedWatchlist) {
                                  context
                                      .read<TvWatchlistBloc>()
                                      .add(OnSaveWatchlistTv(tvseries));
                                } else {
                                  context
                                      .read<TvWatchlistBloc>()
                                      .add(OnRemoveWatchlistTv(tvseries));
                                }

                                String message = "";
                                final state =
                                    BlocProvider.of<TvWatchlistBloc>(context)
                                        .state;
                                if (state is TvLoadWatchlist) {
                                  message = isAddedWatchlist
                                      ? TvWatchlistBloc.messageRemoveToWatchlist
                                      : TvWatchlistBloc.messageAddedToWatchlist;
                                } else {
                                  message = isAddedWatchlist == false
                                      ? TvWatchlistBloc.messageAddedToWatchlist
                                      : TvWatchlistBloc
                                          .messageRemoveToWatchlist;
                                }

                                if (message ==
                                        TvWatchlistBloc
                                            .messageAddedToWatchlist ||
                                    message ==
                                        TvWatchlistBloc
                                            .messageRemoveToWatchlist) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                          content: Text(message),
                                          duration: const Duration(
                                            milliseconds: 500,
                                          )));
                                  BlocProvider.of<TvWatchlistBloc>(context).add(
                                      OnLoadWatchlistStatusTv(tvseries.id));
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Text(message),
                                        );
                                      });
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  isAddedWatchlist
                                      ? Icon(Icons.check)
                                      : Icon(Icons.add),
                                  Text('Watchlist TV Series'),
                                ],
                              ),
                            ),
                            Text(
                              _showGenres(tvseries.genres),
                            ),
                            SizedBox(height: 10),
                            Text('Seasons : ${tvseries.numberOfSeasons}'),
                            Text('Episodes : ${tvseries.numberOfEpisodes}'),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tvseries.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${tvseries.voteAverage}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              tvseries.overview,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            BlocBuilder<TvRecommendationsBloc,
                                    TvRecommendationsState>(
                                builder: (context, state) {
                              if (state is TvRecommendationsLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (state is TvRecommendationsLoaded) {
                                return SizedBox(
                                  height: 150,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      final tvseries = state.result[index];
                                      return Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.pushReplacementNamed(
                                              context,
                                              TvSeriesDetailPage.ROUTE_NAME,
                                              arguments: tvseries.id,
                                            );
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(8),
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  'https://image.tmdb.org/t/p/w500${tvseries.posterPath}',
                                              placeholder: (context, url) =>
                                                  const Center(
                                                child: SizedBox(
                                                    width: 100,
                                                    height: 100,
                                                    child:
                                                        CircularProgressIndicator()),
                                              ),
                                              errorWidget: (context, url,
                                                      error) =>
                                                  const Center(
                                                      child: SizedBox(
                                                          width: 100,
                                                          height: 100,
                                                          child: Icon(
                                                              Icons.error))),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    itemCount: state.result.length,
                                  ),
                                );
                              } else if (state is TvRecommendationsError) {
                                return Center(child: Text(state.message));
                              } else if (state is TvRecommendationsEmpty) {
                                return const Center(
                                  child: Text('No Data'),
                                );
                              } else {
                                return Container();
                              }
                            }),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String getFormattedDurationFromList(List<int> episodeRunTime) =>
      episodeRunTime.map((runtime) => _showDuration(runtime)).join(", ");

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
