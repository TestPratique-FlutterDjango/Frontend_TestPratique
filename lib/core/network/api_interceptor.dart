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
    // Acquerir le token d'acces
    final accessToken = await _secureStorage.getAccessToken();

    // Ajouter le token d'acces aux en-tetes de la requete
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
    // Gerer les erreurs 401 (Unauthorized)
    if (err.response?.statusCode == 401) {
      // Tenter de rafraichir le token
      final refreshed = await _refreshToken(err.requestOptions);
      
      if (refreshed) {
        // Tenter de renvoyer la requete originale
        try {
          final response = await _retry(err.requestOptions);
          return handler.resolve(response);
        } on DioException catch (e) {
          return handler.reject(e);
        }
      } else {
        // Echec du rafraichissement du token, deconnexion de l'utilisateur
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

      // creer une instance Dio pour rafraichir le token
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

        // Sauver les nouveaux tokens
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
    // Obtenir le nouveau token d'acces
    final newAccessToken = await _secureStorage.getAccessToken();

    // Mettre a jour les en-tetes de la requete originale
    requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

    // Creer une instance Dio pour renvoyer la requete
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        headers: requestOptions.headers,
      ),
    );

    // Renvoyer la requete originale
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