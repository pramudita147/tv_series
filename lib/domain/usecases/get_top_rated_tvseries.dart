import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tvseries.dart';
import 'package:ditonton/domain/repositories/tvseries_repository.dart';

class GetTopRatedTvSeries {
  final TvSeriesRepository tvSeriesrepository;

  GetTopRatedTvSeries(this.tvSeriesrepository);

  Future<Either<Failure, List<TvSeries>>> execute() {
    return tvSeriesrepository.getTopRatedTvSeries();
  }
}
