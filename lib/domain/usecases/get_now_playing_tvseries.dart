import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tvseries.dart';
import 'package:ditonton/domain/repositories/tvseries_repository.dart';
import 'package:ditonton/common/failure.dart';

class GetNowPlayingTvSeries {
  final TvSeriesRepository tvSeriesrepository;

  GetNowPlayingTvSeries(this.tvSeriesrepository);

  Future<Either<Failure, List<TvSeries>>> execute() {
    return tvSeriesrepository.getNowPlayingTvSeries();
  }
}
