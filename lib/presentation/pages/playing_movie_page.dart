import 'package:ditonton/presentation/bloc/movie_playing_bloc.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayingMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/playing-movie';

  @override
  _PlayingMoviesPageState createState() => _PlayingMoviesPageState();
}

class _PlayingMoviesPageState extends State<PlayingMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<MoviesNowPlayingBloc>().add(FetchNowPlayingMovies()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Playing Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<MoviesNowPlayingBloc, MoviesNowPlayingState>(
          builder: (context, state) {
            if (state is MoviesNowPlayingLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is MoviesNowPlayingLoaded) {
              final result = state.result;
              return ListView.builder(
                padding: const EdgeInsets.all(8),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final movie = result[index];
                  return MovieCard(movie);
                },
                itemCount: result.length,
              );
            } else if (state is MoviesNowPlayingError) {
              return Center(
                key: const Key("Error Message"),
                child: Text(state.message),
              );
            } else if (state is MoviesNowPlayingEmpty) {
              return const Center(
                child: Text('No Data'),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
