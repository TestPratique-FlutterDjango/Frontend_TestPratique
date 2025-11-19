import 'package:dartz/dartz.dart';
import 'package:publications_app/core/uscases/usecase.dart';
import '../../../../core/error/failures.dart';
import '../entities/company.dart';
import '../repositories/company_repository.dart';

class GetCompaniesUseCase implements UseCase<List<Company>, NoParams> {

  GetCompaniesUseCase(this.repository);
  final CompanyRepository repository;

  @override
  Future<Either<Failure, List<Company>>> call(NoParams params) async {
    return  repository.getCompanies();
  }
}