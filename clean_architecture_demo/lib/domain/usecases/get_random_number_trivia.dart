import 'package:clean_architecture_demo/core/error/failures.dart';
import 'package:clean_architecture_demo/core/usecases/usecases.dart';
import 'package:clean_architecture_demo/domain/entities/number_trivia.dart';
import 'package:clean_architecture_demo/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepository repository;

  GetRandomNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) async {
    return await repository.getRandomNumberTrivia();
  }
}
