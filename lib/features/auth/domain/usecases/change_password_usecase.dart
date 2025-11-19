import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:publications_app/core/uscases/usecase.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class ChangePasswordUseCase implements UseCase<void, ChangePasswordParams> {

  ChangePasswordUseCase(this.repository);
  final AuthRepository repository;

  @override
  Future<Either<Failure, void>> call(ChangePasswordParams params) async {
    return  repository.changePassword(
      oldPassword: params.oldPassword,
      newPassword: params.newPassword,
      newPasswordConfirm: params.newPasswordConfirm,
    );
  }
}

class ChangePasswordParams extends Equatable {

  const ChangePasswordParams({
    required this.oldPassword,
    required this.newPassword,
    required this.newPasswordConfirm,
  });
  final String oldPassword;
  final String newPassword;
  final String newPasswordConfirm;

  @override
  List<Object?> get props => [
        oldPassword,
        newPassword,
        newPasswordConfirm,
      ];
}