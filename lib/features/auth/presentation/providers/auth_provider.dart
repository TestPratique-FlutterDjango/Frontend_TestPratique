import 'package:flutter/foundation.dart';
import 'package:publications_app/core/uscases/usecase.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/change_password_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthProvider extends ChangeNotifier {

  AuthProvider({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
    required this.updateProfileUseCase,
    required this.changePasswordUseCase,
  });
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final ChangePasswordUseCase changePasswordUseCase;

  AuthStatus _status = AuthStatus.initial;
  User? _user;
  String? _errorMessage;
  bool _isLoading = false;

  // Getters
  AuthStatus get status => _status;
  User? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  // Connexion
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    final params = LoginParams(
      email: email,
      password: password,
    );

    final result = await loginUseCase(params);

    return result.fold(
      (failure) {
        _setError(getFailureMessage(failure));
        _setLoading(false);
        return false;
      },
      (user) {
        _user = user;
        _status = AuthStatus.authenticated;
        _setLoading(false);
        notifyListeners();
        return true;
      },
    );
  }

  // Inscription
  Future<bool> register({
    required String email,
    required String password,
    required String passwordConfirm,
    required String firstName,
    required String lastName,
    required String accountType, 
    String? address,
    String? companyName,
    String? cfeNumber,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    final params = RegisterParams(
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

    final result = await registerUseCase(params);

    return result.fold(
      (failure) {
        _setError(getFailureMessage(failure));
        _setLoading(false);
        return false;
      },
      (user) {
        _user = user;
        _status = AuthStatus.authenticated;
        _setLoading(false);
        notifyListeners();
        return true;
      },
    );
  }

  // Deconnexion
  Future<bool> logout(String refreshToken) async {
    _setLoading(true);
    _errorMessage = null;

    final params = LogoutParams(refreshToken: refreshToken);
    final result = await logoutUseCase(params);

    return result.fold(
      (failure) {
        // Si la deconnexion échoue, on nettoie quand même l'état local
        _user = null;
        _status = AuthStatus.unauthenticated;
        _setLoading(false);
        notifyListeners();
        return true;
      },
      (_) {
        _user = null;
        _status = AuthStatus.unauthenticated;
        _setLoading(false);
        notifyListeners();
        return true;
      },
    );
  }

  // Obtention de l'utilisateur actuelle
  Future<bool> getCurrentUser() async {
    _setLoading(true);
    _errorMessage = null;

    final result = await getCurrentUserUseCase(const NoParams());

    return result.fold(
      (failure) {
        _status = AuthStatus.unauthenticated;
        _setLoading(false);
        return false;
      },
      (user) {
        _user = user;
        _status = AuthStatus.authenticated;
        _setLoading(false);
        notifyListeners();
        return true;
      },
    );
  }

  // Mise à jour du profil
  Future<bool> updateProfile({
    required String firstName,
    required String lastName,
    String? address,
    String? companyName,
    String? cfeNumber,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    final params = UpdateProfileParams(
      firstName: firstName,
      lastName: lastName,
      address: address,
      companyName: companyName,
      cfeNumber: cfeNumber,
    );

    final result = await updateProfileUseCase(params);

    return result.fold(
      (failure) {
        _setError(getFailureMessage(failure));
        _setLoading(false);
        return false;
      },
      (user) {
        _user = user;
        _setLoading(false);
        notifyListeners();
        return true;
      },
    );
  }

  // Changer le mot de passe
  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
    required String newPasswordConfirm,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    final params = ChangePasswordParams(
      oldPassword: oldPassword,
      newPassword: newPassword,
      newPasswordConfirm: newPasswordConfirm,
    );

    final result = await changePasswordUseCase(params);

    return result.fold(
      (failure) {
        _setError(getFailureMessage(failure));
        _setLoading(false);
        return false;
      },
      (_) {
        _setLoading(false);
        notifyListeners();
        return true;
      },
    );
  }

  // Methode de support
  void _setLoading(bool value) {
    _isLoading = value;
    if (value) {
      _status = AuthStatus.loading;
    }
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _status = AuthStatus.error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}