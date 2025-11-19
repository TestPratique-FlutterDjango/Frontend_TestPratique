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
      throw CacheException(message: 'Failed to cache user data');
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
      throw CacheException(message: 'Failed to get cached user');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await localStorage.deleteUserData();
      await localStorage.saveLoginStatus(false);
    } catch (e) {
      throw CacheException(message: 'Failed to clear cache');
    }
  }

  @override
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    try {
      await secureStorage.saveTokens(accessToken, refreshToken);
    } catch (e) {
      throw CacheException(message: 'Failed to save tokens');
    }
  }

  @override
  Future<String?> getAccessToken() async {
    try {
      return await secureStorage.getAccessToken();
    } catch (e) {
      throw CacheException(message: 'Failed to get access token');
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      return await secureStorage.getRefreshToken();
    } catch (e) {
      throw CacheException(message: 'Failed to get refresh token');
    }
  }

  @override
  Future<void> deleteTokens() async {
    try {
      await secureStorage.deleteTokens();
    } catch (e) {
      throw CacheException(message: 'Failed to delete tokens');
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