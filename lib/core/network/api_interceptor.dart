import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../storage/secure_storage.dart';

class ApiInterceptor extends Interceptor {
  final SecureStorage _secureStorage = SecureStorage();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Get access token from secure storage
    final accessToken = await _secureStorage.getAccessToken();

    // Add Authorization header if token exists
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    super.onRequest(options, handler);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Handle 401 Unauthorized - Token expired
    if (err.response?.statusCode == 401) {
      // Try to refresh token
      final refreshed = await _refreshToken(err.requestOptions);
      
      if (refreshed) {
        // Retry the request with new token
        try {
          final response = await _retry(err.requestOptions);
          return handler.resolve(response);
        } on DioException catch (e) {
          return handler.reject(e);
        }
      } else {
        // Refresh failed - logout user
        await _secureStorage.clearAll();
        return handler.reject(err);
      }
    }

    super.onError(err, handler);
  }

  Future<bool> _refreshToken(RequestOptions requestOptions) async {
    try {
      final refreshToken = await _secureStorage.getRefreshToken();
      
      if (refreshToken == null || refreshToken.isEmpty) {
        return false;
      }

      // Create a new Dio instance to avoid interceptor loop
      final dio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          headers: {
            'Content-Type': ApiConstants.contentType,
            'Accept': ApiConstants.accept,
          },
        ),
      );

      final response = await dio.post(
        ApiConstants.refreshToken,
        data: {'refresh': refreshToken},
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data['access'];
        final newRefreshToken = response.data['refresh'];

        // Save new tokens
        await _secureStorage.saveAccessToken(newAccessToken);
        if (newRefreshToken != null) {
          await _secureStorage.saveRefreshToken(newRefreshToken);
        }

        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  Future<Response> _retry(RequestOptions requestOptions) async {
    // Get new access token
    final newAccessToken = await _secureStorage.getAccessToken();

    // Update request with new token
    requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

    // Create new Dio instance to retry
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        headers: requestOptions.headers,
      ),
    );

    // Retry the request
    final response = await dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: Options(
        method: requestOptions.method,
        headers: requestOptions.headers,
      ),
    );

    return response;
  }
}