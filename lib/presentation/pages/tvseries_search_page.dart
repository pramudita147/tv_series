import 'package:ditonton/common/constants.dart';
import 'package:ditonton/presentation/bloc/tvseries_search_bloc.dart';
import 'package:ditonton/presentation/widgets/tvseries_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TvSeriesSearchPage extends StatelessWidget {
  static const ROUTE_NAME = '/searchTv';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search TV Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onSubmitted: (query) {
                context.read<TvSearchBloc>().add(OnQueryTvChanged(query));
              },
              decoration: InputDecoration(
                hintText: 'Search Tv Series',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            SizedBox(height: 16),
            Text(
              'Search Result',
              style: kHeading6,
            ),
            BlocBuilder<TvSearchBloc, TvSearchState>(
              builder: (context, state) {
                if (state is TvSearchLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is TvSearchLoaded) {
                  final result = state.result;
                  return Expanded(
                      child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final tvseries = result[index];
                      return TvSeriesCard(tvseries);
                    },
                    itemCount: result.length,
                  ));
                } else if (state is TvSearchError) {
                  return Center(child: Text(state.message));
                } else {
                  return Center(
                    child: Text('Tv Series Not Found'),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
