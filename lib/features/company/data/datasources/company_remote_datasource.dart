import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/company_model.dart';

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
        final List<dynamic> data = response.data as List<dynamic>;
        return data.map((json) => CompanyModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          message: response.data['error'] ?? 'Failed to get companies',
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
          message: response.data['error'] ?? 'Failed to get company',
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
          message: response.data['error'] ?? 'Failed to create company',
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
          message: response.data['error'] ?? 'Failed to update company',
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
          message: response.data['error'] ?? 'Failed to delete company',
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
          message: response.data['error'] ?? 'Failed to toggle company status',
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