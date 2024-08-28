import 'package:clean_architecture_demo/core/error/exceptions.dart';
import 'package:clean_architecture_demo/core/error/failures.dart';
import 'package:clean_architecture_demo/core/network/network_info.dart';
import 'package:clean_architecture_demo/data/data_sources/number_trivia_local_data_source.dart';
import 'package:clean_architecture_demo/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_demo/domain/entities/number_trivia.dart';
import 'package:clean_architecture_demo/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';

typedef _ConcreteOrRandomChooser = Future<NumberTrivia> Function();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number) async {
    return await _getTrivia(() {
      return remoteDataSource.getConcreteNumberTrivia(number);
    });
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(() {
      return remoteDataSource.getRandomNumberTrivia();
    });
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(_ConcreteOrRandomChooser getConcreteOrRandom) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await getConcreteOrRandom();

        /// TODO => Solve this code :down
        //localDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
