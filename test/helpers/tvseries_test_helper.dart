import 'package:ditonton/data/datasources/db/tvseries_database_helper.dart';
import 'package:ditonton/data/datasources/tvseries_local_data_source.dart';
import 'package:ditonton/data/datasources/tvseries_remote_data_source.dart';
import 'package:ditonton/domain/repositories/tvseries_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([
  TvSeriesRepository,
  TvSeriesRemoteDataSource,
  TvSeriesLocalDataSource,
  DatabaseHelperTv,
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}
