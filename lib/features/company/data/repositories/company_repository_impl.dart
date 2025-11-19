import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/company.dart';
import '../../domain/repositories/company_repository.dart';
import '../datasources/company_remote_datasource.dart';

class CompanyRepositoryImpl implements CompanyRepository {

  CompanyRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });
  final CompanyRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, List<Company>>> getCompanies() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('Pas de connexion Internet'));
    }

    try {
      final companies = await remoteDataSource.getCompanies();
      return Right(companies.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on TimeoutException catch (e) {
      return Left(TimeoutFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Company>> getCompanyById(int id) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('Pas de connexion Internet'));
    }

    try {
      final company = await remoteDataSource.getCompanyById(id);
      return Right(company.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Company>> createCompany({
    required String name,
    required String cfeNumber,
    required String address,
    String? phone,
    String? email,
    String? description,
    String? website,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('Pas de connexion Internet'));
    }

    try {
      final data = {
        'name': name,
        'cfe_number': cfeNumber,
        'address': address,
        if (phone != null && phone.isNotEmpty) 'phone': phone,
        if (email != null && email.isNotEmpty) 'email': email,
        if (description != null && description.isNotEmpty)
          'description': description,
        if (website != null && website.isNotEmpty) 'website': website,
      };

      final company = await remoteDataSource.createCompany(data);
      return Right(company.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.errors.toString(), errors: e.errors));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Company>> updateCompany({
    required int id,
    required String name,
    required String address,
    String? phone,
    String? email,
    String? description,
    String? website,
    bool? isActive,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('Pas de connexion Internet'));
    }

    try {
      final data = {
        'name': name,
        'address': address,
        if (phone != null) 'phone': phone,
        if (email != null) 'email': email,
        if (description != null) 'description': description,
        if (website != null) 'website': website,
        if (isActive != null) 'is_active': isActive,
      };

      final company = await remoteDataSource.updateCompany(id, data);
      return Right(company.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.errors.toString(), errors: e.errors));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCompany(int id) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('Pas de connexion Internet'));
    }

    try {
      await remoteDataSource.deleteCompany(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Company>> toggleCompanyStatus(int id) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('Pas de connexion Internet'));
    }

    try {
      final company = await remoteDataSource.toggleCompanyStatus(id);
      return Right(company.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}