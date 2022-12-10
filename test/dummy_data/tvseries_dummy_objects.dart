import 'package:ditonton/data/models/tvseries_table.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/tvseries.dart';
import 'package:ditonton/domain/entities/tvseries_detail.dart';

final testTvSeries = TvSeries(
  backdropPath: '/8gsbbKCDI3CrQg0UExFoUjRUmHM.jpg',
  genreIds: [10765, 9648, 35],
  id: 119051,
  originalName: 'Wednesday',
  overview:
      'Wednesday Addams is sent to Nevermore Academy, a bizarre boarding school where she attempts to master her psychic powers, stop a monstrous killing spree of the town citizens, and solve the supernatural mystery that affected her family 25 years ago — all while navigating her new relationships.',
  popularity: 7753.37,
  posterPath: '/9PFonBhy4cQy7Jz20NpMygczOkv.jpg',
  name: 'Wednesday',
  voteAverage: 8.8,
  voteCount: 2369,
);

final testTvSeriesList = [testTvSeries];

final testTvSeriesDetail = TvSeriesDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  homepage: "https://google.com",
  id: 1,
  originalName: 'originalName',
  overview: 'overview',
  popularity: 1,
  episodeRunTime: [1, 2, 3],
  firstAirDate: 'firstAirDate',
  lastAirDate: 'lastAirDate',
  numberOfEpisodes: 1,
  numberOfSeasons: 1,
  inProduction: false,
  languages: ["en"],
  type: 'type',
  posterPath: 'posterPath',
  status: 'Status',
  tagline: 'Tagline',
  name: 'name',
  voteAverage: 1,
  voteCount: 1,
);

final testWatchlistTvSeries = TvSeries.watchlist(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTvSeriesTable = TvSeriesTable(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTvSeriesMap = {
  'id': 1,
  'name': 'name',
  'posterPath': 'posterPath',
  'overview': 'overview',
};
