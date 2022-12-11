// Mocks generated by Mockito 5.3.2 from annotations
// in movies/test/presentation/bloc/movies/movies_detail_bloc/movies_detail_bloc_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:dartz/dartz.dart' as _i3;
import 'package:ditonton/common/failure.dart' as _i6;
import 'package:ditonton/domain/entities/movie_detail.dart' as _i7;
import 'package:ditonton/domain/repositories/movie_repository.dart' as _i2;
import 'package:ditonton/domain/usecases/get_movie_detail.dart' as _i4;
import 'package:mockito/mockito.dart' as _i1;

// ignore: camel_case_types
class FakeMovieRepository_0 extends _i1.SmartFake
    implements _i2.MovieRepository {
  FakeMovieRepository_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

// ignore: camel_case_types
class FakeEither_1<L, R> extends _i1.SmartFake implements _i3.Either<L, R> {
  FakeEither_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [GetMovieDetail].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetMovieDetail extends _i1.Mock implements _i4.GetMovieDetail {
  MockGetMovieDetail() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.Future<_i3.Either<_i6.Failure, _i7.MovieDetail>> execute(int? id) =>
      (super.noSuchMethod(
        Invocation.method(
          #execute,
          [id],
        ),
        returnValue: _i5.Future<_i3.Either<_i6.Failure, _i7.MovieDetail>>.value(
            FakeEither_1<_i6.Failure, _i7.MovieDetail>(
          this,
          Invocation.method(
            #execute,
            [id],
          ),
        )),
      ) as _i5.Future<_i3.Either<_i6.Failure, _i7.MovieDetail>>);
}
