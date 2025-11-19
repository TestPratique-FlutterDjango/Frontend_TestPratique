import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  /// Login user with email and password
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  /// Register new user
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String passwordConfirm,
    required String firstName,
    required String lastName,
    required String accountType, 
    String? address,
    String? companyName,
    String? cfeNumber,
  });

  /// Logout current user
  Future<Either<Failure, void>> logout({
    required String refreshToken,
  });

  /// Get current user profile
  Future<Either<Failure, User>> getCurrentUser();

  /// Update user profile
  Future<Either<Failure, User>> updateProfile({
    required String firstName,
    required String lastName,
    String? address,
    String? companyName,
    String? cfeNumber,
  });

  /// Change password
  Future<Either<Failure, void>> changePassword({
    required String oldPassword,
    required String newPassword,
    required String newPasswordConfirm,
  });

  /// Check if user is logged in
  Future<bool> isLoggedIn();

  /// Get cached user
  Future<User?> getCachedUser();
}