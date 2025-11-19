import '../../../../core/error/exceptions.dart';
import '../../../../core/storage/local_storage.dart';
import '../../../../core/storage/secure_storage.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearCache();
  Future<void> saveTokens(String accessToken, String refreshToken);
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> deleteTokens();
  Future<bool> isLoggedIn();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {

  AuthLocalDataSourceImpl({
    required this.localStorage,
    required this.secureStorage,
  });
  final LocalStorage localStorage;
  final SecureStorage secureStorage;

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      await localStorage.saveUserData(user.toJson());
      await localStorage.saveLoginStatus(true);
    } catch (e) {
      throw CacheException(message: "Erreur de mise en cache de l'utilisateur");
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final userData = localStorage.getUserData();
      if (userData != null) {
        return UserModel.fromJson(userData);
      }
      return null;
    } catch (e) {
      throw CacheException(message: "Erreur de récupération de l'utilisateur en cache");
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await localStorage.deleteUserData();
      await localStorage.saveLoginStatus(false);
    } catch (e) {
      throw CacheException(message: 'Erreur de nettoyage du cache');
    }
  }

  @override
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    try {
      await secureStorage.saveTokens(accessToken, refreshToken);
    } catch (e) {
      throw CacheException(message: 'Echec de sauvegarde des tokens');
    }
  }

  @override
  Future<String?> getAccessToken() async {
    try {
      return await secureStorage.getAccessToken();
    } catch (e) {
      throw CacheException(message: "Echec de récupération du token d'accès");
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      return await secureStorage.getRefreshToken();
    } catch (e) {
      throw CacheException(message: 'Echec de récupération du token de rafraîchissement');
    }
  }

  @override
  Future<void> deleteTokens() async {
    try {
      await secureStorage.deleteTokens();
    } catch (e) {
      throw CacheException(message: 'Echec de suppression des tokens');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      return localStorage.isLoggedIn() && await secureStorage.hasToken();
    } catch (e) {
      return false;
    }
  }
}