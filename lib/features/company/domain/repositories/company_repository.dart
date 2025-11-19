import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/company.dart';

abstract class CompanyRepository {
  /// Get all companies of current user
  Future<Either<Failure, List<Company>>> getCompanies();

  /// Get company by id
  Future<Either<Failure, Company>> getCompanyById(int id);

  /// Create new company
  Future<Either<Failure, Company>> createCompany({
    required String name,
    required String cfeNumber,
    required String address,
    String? phone,
    String? email,
    String? description,
    String? website,
  });

  /// Update company
  Future<Either<Failure, Company>> updateCompany({
    required int id,
    required String name,
    required String address,
    String? phone,
    String? email,
    String? description,
    String? website,
    bool? isActive,
  });

  /// Delete company
  Future<Either<Failure, void>> deleteCompany(int id);

  /// Toggle company status (active/inactive)
  Future<Either<Failure, Company>> toggleCompanyStatus(int id);
}