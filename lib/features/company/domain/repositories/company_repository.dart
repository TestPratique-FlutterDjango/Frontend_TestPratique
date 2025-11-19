import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/company.dart';

abstract class CompanyRepository {
  /// Obtention pour la liste des entreprises
  Future<Either<Failure, List<Company>>> getCompanies();

  /// Obtention d'une entreprise par son ID
  Future<Either<Failure, Company>> getCompanyById(int id);

  /// Création d'une entreprise
  Future<Either<Failure, Company>> createCompany({
    required String name,
    required String cfeNumber,
    required String address,
    String? phone,
    String? email,
    String? description,
    String? website,
  });

  /// Mise à jour d'une entreprise
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

  /// Suppression d'une entreprise
  Future<Either<Failure, void>> deleteCompany(int id);

  /// Basculer le statut actif/inactif d'une entreprise
  Future<Either<Failure, Company>> toggleCompanyStatus(int id);
}