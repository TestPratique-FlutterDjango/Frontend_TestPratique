import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  /// Connexion utilisateur
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  /// Inscription utilisateur
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

  /// Deconnexion 
  Future<Either<Failure, void>> logout({
    required String refreshToken,
  });

  /// Obtention de l'utilisateur actuelle
  Future<Either<Failure, User>> getCurrentUser();

  /// Mise à jour du profil utilisateur
  Future<Either<Failure, User>> updateProfile({
    required String firstName,
    required String lastName,
    String? address,
    String? companyName,
    String? cfeNumber,
  });

  /// Changement de mot de passe
  Future<Either<Failure, void>> changePassword({
    required String oldPassword,
    required String newPassword,
    required String newPasswordConfirm,
  });

  /// Vérifie si l'utilisateur est connecté
  Future<bool> isLoggedIn();

  /// Obtention de l'utilisateur en cache
  Future<User?> getCachedUser();
}