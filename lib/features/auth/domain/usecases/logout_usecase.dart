import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:publications_app/core/uscases/usecase.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class LogoutUseCase implements UseCase<void, LogoutParams> {

  LogoutUseCase(this.repository);
  final AuthRepository repository;

  @override
  Future<Either<Failure, void>> call(LogoutParams params) async {
    return await repository.logout(
      refreshToken: params.refreshToken,
    );
  }
}

class LogoutParams extends Equatable {
  final String refreshToken;

  const LogoutParams({
    required this.refreshToken,
  });

  @override
  List<Object?> get props => [refreshToken];
}