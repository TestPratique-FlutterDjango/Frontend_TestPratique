import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:publications_app/core/uscases/usecase.dart';
import '../../../../core/error/failures.dart';
import '../entities/company.dart';
import '../repositories/company_repository.dart';

class UpdateCompanyUseCase implements UseCase<Company, UpdateCompanyParams> {

  UpdateCompanyUseCase(this.repository);
  final CompanyRepository repository;

  @override
  Future<Either<Failure, Company>> call(UpdateCompanyParams params) async {
    return  repository.updateCompany(
      id: params.id,
      name: params.name,
      address: params.address,
      phone: params.phone,
      email: params.email,
      description: params.description,
      website: params.website,
      isActive: params.isActive,
    );
  }
}

class UpdateCompanyParams extends Equatable {

  const UpdateCompanyParams({
    required this.id,
    required this.name,
    required this.address,
    this.phone,
    this.email,
    this.description,
    this.website,
    this.isActive,
  });
  final int id;
  final String name;
  final String address;
  final String? phone;
  final String? email;
  final String? description;
  final String? website;
  final bool? isActive;

  @override
  List<Object?> get props => [
        id,
        name,
        address,
        phone,
        email,
        description,
        website,
        isActive,
      ];
}