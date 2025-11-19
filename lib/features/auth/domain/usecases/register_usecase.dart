import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:publications_app/core/uscases/usecase.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase implements UseCase<User, RegisterParams> {

  RegisterUseCase(this.repository);
  final AuthRepository repository;

  @override
  Future<Either<Failure, User>> call(RegisterParams params) async {
    return await repository.register(
      email: params.email,
      password: params.password,
      passwordConfirm: params.passwordConfirm,
      firstName: params.firstName,
      lastName: params.lastName,
      address: params.address,
      accountType: params.accountType,
      companyName: params.companyName,
      cfeNumber: params.cfeNumber,
    );
  }
}

class RegisterParams extends Equatable {

  const RegisterParams({
    required this.email,
    required this.password,
    required this.passwordConfirm,
    required this.firstName,
    required this.lastName,
    required this.accountType, 
    this.address,
    this.companyName,
    this.cfeNumber,
  });
  final String email;
  final String password;
  final String passwordConfirm;
  final String firstName;
  final String lastName;
  final String? address;
  final String accountType;
  final String? companyName;
  final String? cfeNumber;

  @override
  List<Object?> get props => [
        email,
        password,
        passwordConfirm,
        firstName,
        lastName,
        address,
        accountType,
        companyName,
        cfeNumber,
      ];
}