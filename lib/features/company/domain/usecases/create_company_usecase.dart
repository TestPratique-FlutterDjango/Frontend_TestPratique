import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:publications_app/core/uscases/usecase.dart';
import '../../../../core/error/failures.dart';
import '../entities/company.dart';
import '../repositories/company_repository.dart';

class CreateCompanyUseCase implements UseCase<Company, CreateCompanyParams> {

  CreateCompanyUseCase(this.repository);
  final CompanyRepository repository;

  @override
  Future<Either<Failure, Company>> call(CreateCompanyParams params) async {
    return  repository.createCompany(
      name: params.name,
      cfeNumber: params.cfeNumber,
      address: params.address,
      phone: params.phone,
      email: params.email,
      description: params.description,
      website: params.website,
    );
  }
}

class CreateCompanyParams extends Equatable {

  const CreateCompanyParams({
    required this.name,
    required this.cfeNumber,
    required this.address,
    this.phone,
    this.email,
    this.description,
    this.website,
  });
  final String name;
  final String cfeNumber;
  final String address;
  final String? phone;
  final String? email;
  final String? description;
  final String? website;

  @override
  List<Object?> get props => [
        name,
        cfeNumber,
        address,
        phone,
        email,
        description,
        website,
      ];
}