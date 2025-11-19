import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:publications_app/core/uscases/usecase.dart';
import '../../../../core/error/failures.dart';
import '../repositories/company_repository.dart';

class DeleteCompanyUseCase implements UseCase<void, DeleteCompanyParams> {

  DeleteCompanyUseCase(this.repository);
  final CompanyRepository repository;

  @override
  Future<Either<Failure, void>> call(DeleteCompanyParams params) async {
    return  repository.deleteCompany(params.id);
  }
}

class DeleteCompanyParams extends Equatable {

  const DeleteCompanyParams({required this.id});
  final int id;

  @override
  List<Object?> get props => [id];
}