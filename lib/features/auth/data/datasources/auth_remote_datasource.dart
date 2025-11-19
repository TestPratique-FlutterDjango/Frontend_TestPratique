import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/auth_response_model.dart';
import '../models/login_request_model.dart';
import '../models/register_request_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login(LoginRequestModel request);
  Future<AuthResponseModel> register(RegisterRequestModel request);
  Future<void> logout(String refreshToken);
  Future<UserModel> getCurrentUser();
  Future<UserModel> updateProfile(Map<String, dynamic> data);
  Future<void> changePassword(Map<String, dynamic> data);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {

  AuthRemoteDataSourceImpl({required this.dioClient});
  final DioClient dioClient;

  @override
  Future<AuthResponseModel> login(LoginRequestModel request) async {
    try {
      final response = await dioClient.post(
        ApiConstants.login,
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return AuthResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.data['error'] ?? 'Login failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<AuthResponseModel> register(RegisterRequestModel request) async {
    try {
      final response = await dioClient.post(
        ApiConstants.register,
        data: request.toJson(),
      );

      if (response.statusCode == 201) {
        return AuthResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.data['error'] ?? 'Registration failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<void> logout(String refreshToken) async {
    try {
      final response = await dioClient.post(
        ApiConstants.logout,
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode != 200) {
        throw ServerException(
          message: response.data['error'] ?? 'Logout failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await dioClient.get(ApiConstants.profile);

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.data['error'] ?? 'Failed to get user profile',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<UserModel> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await dioClient.patch(
        ApiConstants.profile,
        data: data,
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['user']);
      } else {
        throw ServerException(
          message: response.data['error'] ?? 'Failed to update profile',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<void> changePassword(Map<String, dynamic> data) async {
    try {
      final response = await dioClient.post(
        ApiConstants.changePassword,
        data: data,
      );

      if (response.statusCode != 200) {
        throw ServerException(
          message: response.data['error'] ?? 'Failed to change password',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(message: 'Connection timeout');

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final errorMessage = e.response?.data?['error'] ?? 
                           e.response?.data?['detail'] ?? 
                           'Server error';

        if (statusCode == 401) {
          return UnauthorizedException(message: errorMessage);
        } else if (statusCode == 400) {
          if (e.response?.data is Map) {
            return ValidationException(
              errors: e.response!.data as Map<String, dynamic>,
            );
          }
          return ServerException(
            message: errorMessage,
            statusCode: statusCode,
          );
        } else if (statusCode == 404) {
          return NotFoundException(message: errorMessage);
        } else {
          return ServerException(
            message: errorMessage,
            statusCode: statusCode,
          );
        }

      case DioExceptionType.connectionError:
        return NetworkException(
          message: 'No internet connection',
        );

      case DioExceptionType.cancel:
        return ServerException(message: 'Request cancelled');

      default:
        return ServerException(
          message: e.message ?? 'Unknown error occurred',
        );
    }
  }
}