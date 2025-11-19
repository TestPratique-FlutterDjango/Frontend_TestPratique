import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:publications_app/core/uscases/usecase.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class UpdateProfileUseCase implements UseCase<User, UpdateProfileParams> {

  UpdateProfileUseCase(this.repository);
  final AuthRepository repository;

  @override
  Future<Either<Failure, User>> call(UpdateProfileParams params) async {
    return await repository.updateProfile(
      firstName: params.firstName,
      lastName: params.lastName,
      address: params.address,
      companyName: params.companyName,
      cfeNumber: params.cfeNumber,
    );
  }
}

class UpdateProfileParams extends Equatable {
  final String firstName;
  final String lastName;
  final String? address;
  final String? companyName;
  final String? cfeNumber;

  const UpdateProfileParams({
    required this.firstName,
    required this.lastName,
    this.address,
    this.companyName,
    this.cfeNumber,
  });

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        address,
        companyName,
        cfeNumber,
      ];
}