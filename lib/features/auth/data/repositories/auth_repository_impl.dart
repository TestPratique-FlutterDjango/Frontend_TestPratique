import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/login_request_model.dart';
import '../models/register_request_model.dart';

class AuthRepositoryImpl implements AuthRepository {

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      final request = LoginRequestModel(
        email: email,
        password: password,
      );

      final response = await remoteDataSource.login(request);

      // Save tokens
      await localDataSource.saveTokens(
        response.tokens.accessToken,
        response.tokens.refreshToken,
      );

      // Cache user
      await localDataSource.cacheUser(response.user);

      return Right(response.user.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.errors.toString(), errors: e.errors));
    } on TimeoutException catch (e) {
      return Left(TimeoutFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String passwordConfirm,
    required String firstName,
    required String lastName,
    required String accountType, String? address,
    String? companyName,
    String? cfeNumber,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      final request = RegisterRequestModel(
        email: email,
        password: password,
        passwordConfirm: passwordConfirm,
        firstName: firstName,
        lastName: lastName,
        address: address,
        accountType: accountType,
        companyName: companyName,
        cfeNumber: cfeNumber,
      );

      final response = await remoteDataSource.register(request);

      // Save tokens
      await localDataSource.saveTokens(
        response.tokens.accessToken,
        response.tokens.refreshToken,
      );

      // Cache user
      await localDataSource.cacheUser(response.user);

      return Right(response.user.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.errors.toString(), errors: e.errors));
    } on TimeoutException catch (e) {
      return Left(TimeoutFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout({
    required String refreshToken,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        await remoteDataSource.logout(refreshToken);
      }

      // Nettoyer les données locales même en cas d'erreur serveur
      await localDataSource.deleteTokens();
      await localDataSource.clearCache();

      return const Right(null);
    } on ServerException catch (e) {
      // En cas d'erreur serveur, on nettoie quand même les données locales
      await localDataSource.deleteTokens();
      await localDataSource.clearCache();
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      // Si une autre erreur se produit, on nettoie quand même les données locales
      await localDataSource.deleteTokens();
      await localDataSource.clearCache();
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    if (!await networkInfo.isConnected) {
      // Tenter de récupérer l'utilisateur en cache
      try {
        final cachedUser = await localDataSource.getCachedUser();
        if (cachedUser != null) {
          return Right(cachedUser.toEntity());
        }
        return const Left(CacheFailure("Pas d'utilisateur en cache"));
      } catch (e) {
        return const Left(CacheFailure("Erreur lors de la récupération de l'utilisateur en cache"));
      }
    }

    try {
      final user = await remoteDataSource.getCurrentUser();
      await localDataSource.cacheUser(user);
      return Right(user.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> updateProfile({
    required String firstName,
    required String lastName,
    String? address,
    String? companyName,
    String? cfeNumber,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('Pas de connexion internet'));
    }

    try {
      final data = {
        'first_name': firstName,
        'last_name': lastName,
        if (address != null) 'address': address,
        if (companyName != null) 'company_name': companyName,
        if (cfeNumber != null) 'cfe_number': cfeNumber,
      };

      final user = await remoteDataSource.updateProfile(data);
      await localDataSource.cacheUser(user);
      return Right(user.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.errors.toString(), errors: e.errors));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String oldPassword,
    required String newPassword,
    required String newPasswordConfirm,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('Pas de connexion internet'));
    }

    try {
      final data = {
        'old_password': oldPassword,
        'new_password': newPassword,
        'new_password_confirm': newPasswordConfirm,
      };

      await remoteDataSource.changePassword(data);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.errors.toString(), errors: e.errors));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return await localDataSource.isLoggedIn();
  }

  @override
  Future<User?> getCachedUser() async {
    try {
      final cachedUser = await localDataSource.getCachedUser();
      return cachedUser?.toEntity();
    } catch (e) {
      return null;
    }
  }
}