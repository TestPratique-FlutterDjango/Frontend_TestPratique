import 'package:dartz/dartz.dart';
import 'package:publications_app/core/uscases/usecase.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class GetCurrentUserUseCase implements UseCase<User, NoParams> {

  GetCurrentUserUseCase(this.repository);
  final AuthRepository repository;

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await repository.getCurrentUser();
  }
}