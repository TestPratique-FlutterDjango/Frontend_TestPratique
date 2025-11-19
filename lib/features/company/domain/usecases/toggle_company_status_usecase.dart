import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:publications_app/core/uscases/usecase.dart';
import '../../../../core/error/failures.dart';
import '../entities/company.dart';
import '../repositories/company_repository.dart';

class ToggleCompanyStatusUseCase implements UseCase<Company, ToggleCompanyStatusParams> {

  ToggleCompanyStatusUseCase(this.repository);
  final CompanyRepository repository;

  @override
  Future<Either<Failure, Company>> call(ToggleCompanyStatusParams params) async {
    return repository.toggleCompanyStatus(params.id);
  }
}

class ToggleCompanyStatusParams extends Equatable {

  const ToggleCompanyStatusParams({required this.id});
  final int id;

  @override
  List<Object?> get props => [id];
}