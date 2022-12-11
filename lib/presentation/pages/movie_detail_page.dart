import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/presentation/bloc/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_recommendations_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_watchlist_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MovieDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail';

  final int id;
  MovieDetailPage({required this.id});

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MoviesDetailBloc>().add(FetchDetailMovies(widget.id));
      context
          .read<MovieWatchlistBloc>()
          .add(OnLoadWatchlistStatusMovies(widget.id));
      context
          .read<MoviesRecommendationsBloc>()
          .add(FetchRecommendationsMovies(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isAddedToWatchlist = context.select<MovieWatchlistBloc, bool>((bloc) {
      var state = bloc.state;
      if (state is MoviesLoadWatchlist) {
        return state.isWatchlist;
      }
      return false;
    });
    return Scaffold(
      body: BlocBuilder<MoviesDetailBloc, MoviesDetailState>(
          builder: (context, state) {
        if (state is MoviesDetailLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is MoviesDetailLoaded) {
          final movie = state.result;
          return SafeArea(
            child: DetailContent(
              movie: movie,
              isAddedWatchlist: isAddedToWatchlist,
            ),
          );
        } else if (state is MoviesDetailError) {
          return Center(child: Text(state.message));
        } else {
          return Container();
        }
      }),
    );
  }
}

class DetailContent extends StatelessWidget {
  final MovieDetail movie;
  final bool isAddedWatchlist;

  const DetailContent(
      {Key? key, required this.movie, required this.isAddedWatchlist})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
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
                              movie.title,
                              style: kHeading5,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (!isAddedWatchlist) {
                                  context
                                      .read<MovieWatchlistBloc>()
                                      .add(OnSaveWatchlistMovies(movie));
                                } else {
                                  context
                                      .read<MovieWatchlistBloc>()
                                      .add(OnRemoveWatchlistMovies(movie));
                                }

                                String message = "";
                                final state =
                                    BlocProvider.of<MovieWatchlistBloc>(context)
                                        .state;
                                if (state is MoviesLoadWatchlist) {
                                  message = isAddedWatchlist
                                      ? MovieWatchlistBloc
                                          .messageRemoveToWatchlist
                                      : MovieWatchlistBloc
                                          .messageAddedToWatchlist;
                                } else {
                                  message = isAddedWatchlist == false
                                      ? MovieWatchlistBloc
                                          .messageAddedToWatchlist
                                      : MovieWatchlistBloc
                                          .messageRemoveToWatchlist;
                                }

                                if (message ==
                                        MovieWatchlistBloc
                                            .messageAddedToWatchlist ||
                                    message ==
                                        MovieWatchlistBloc
                                            .messageRemoveToWatchlist) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                          content: Text(message),
                                          duration: const Duration(
                                            milliseconds: 500,
                                          )));
                                  BlocProvider.of<MovieWatchlistBloc>(context)
                                      .add(OnLoadWatchlistStatusMovies(
                                          movie.id));
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
                                  Text('Watchlist'),
                                ],
                              ),
                            ),
                            Text(
                              _showGenres(movie.genres),
                            ),
                            Text(
                              _showDuration(movie.runtime),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: movie.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${movie.voteAverage}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              movie.overview,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            BlocBuilder<MoviesRecommendationsBloc,
                                    MoviesRecommendationsState>(
                                builder: (context, state) {
                              if (state is MoviesRecommendationsLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (state is MoviesRecommendationsLoaded) {
                                return SizedBox(
                                  height: 150,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      final movie = state.result[index];
                                      return Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.pushReplacementNamed(
                                              context,
                                              MovieDetailPage.ROUTE_NAME,
                                              arguments: movie.id,
                                            );
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(8),
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  'https://image.tmdb.org/t/p/w500${movie.posterPath}',
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
                              } else if (state is MoviesRecommendationsError) {
                                return Center(child: Text(state.message));
                              } else if (state is MoviesRecommendationsEmpty) {
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
