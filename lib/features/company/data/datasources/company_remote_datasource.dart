import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/company_model.dart';

final _logger = Logger(); 
abstract class CompanyRemoteDataSource {
  Future<List<CompanyModel>> getCompanies();
  Future<CompanyModel> getCompanyById(int id);
  Future<CompanyModel> createCompany(Map<String, dynamic> data);
  Future<CompanyModel> updateCompany(int id, Map<String, dynamic> data);
  Future<void> deleteCompany(int id);
  Future<CompanyModel> toggleCompanyStatus(int id);
}

class CompanyRemoteDataSourceImpl implements CompanyRemoteDataSource {

  CompanyRemoteDataSourceImpl({required this.dioClient});
  final DioClient dioClient;

  @override
  Future<List<CompanyModel>> getCompanies() async {
    try {
      final response = await dioClient.get(ApiConstants.companies);

      if (response.statusCode == 200) {
        
        final List<dynamic> data;
        
        if (response.data is Map<String, dynamic> && response.data.containsKey('results')) {
          // Format paginé: {"count": 1, "results": [...]}
          data = response.data['results'] as List<dynamic>;
          _logger.i(' Entreprises récupérées (format paginé): ${data.length} éléments');
        } else if (response.data is List) {
          // Format liste directe: [...]
          data = response.data as List<dynamic>;
          _logger.i(' Entreprises récupérées (format liste): ${data.length} éléments');
        } else {
          _logger.i(' Format de réponse inattendu: ${response.data.runtimeType}');
          throw ServerException(
            message: 'Format de réponse invalide',
            statusCode: response.statusCode,
          );
        }
        
        return data.map((json) => CompanyModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          message: response.data['error'] ?? 'Erreur de récupération des entreprises',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<CompanyModel> getCompanyById(int id) async {
    try {
      final response = await dioClient.get(ApiConstants.companyDetail(id));

      if (response.statusCode == 200) {
        return CompanyModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.data['error'] ?? "Echec de récupération de l'entreprise",
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<CompanyModel> createCompany(Map<String, dynamic> data) async {
    try {
      final response = await dioClient.post(
        ApiConstants.companies,
        data: data,
      );

      if (response.statusCode == 201) {
        return CompanyModel.fromJson(response.data['company']);
      } else {
        throw ServerException(
          message: response.data['error'] ?? "Echec de création de l'entreprise",
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<CompanyModel> updateCompany(int id, Map<String, dynamic> data) async {
    try {
      final response = await dioClient.patch(
        ApiConstants.companyDetail(id),
        data: data,
      );

      if (response.statusCode == 200) {
        return CompanyModel.fromJson(response.data['company']);
      } else {
        throw ServerException(
          message: response.data['error'] ?? "Erreur de mise à jour de l'entreprise",
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<void> deleteCompany(int id) async {
    try {
      final response = await dioClient.delete(ApiConstants.companyDetail(id));

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw ServerException(
          message: response.data['error'] ?? "Echec de suppression de l'entreprise",
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<CompanyModel> toggleCompanyStatus(int id) async {
    try {
      final response = await dioClient.post(
        ApiConstants.toggleCompanyStatus(id),
      );

      if (response.statusCode == 200) {
        return CompanyModel.fromJson(response.data['company']);
      } else {
        throw ServerException(
          message: response.data['error'] ?? "Echec de changement du statut de l'entreprise",
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
        return TimeoutException(message: 'Connexion délai dépassé');

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
        } else if (statusCode == 403) {
          return ServerException(
            message: errorMessage,
            statusCode: statusCode,
          );
        } else {
          return ServerException(
            message: errorMessage,
            statusCode: statusCode,
          );
        }

      case DioExceptionType.connectionError:
        return NetworkException(
          message: 'Pas de connexion Internet',
        );

      case DioExceptionType.cancel:
        return ServerException(message: 'Requête annulée');

      default:
        return ServerException(
          message: e.message ?? 'Erreur inattendue',
        );
    }
  }
}