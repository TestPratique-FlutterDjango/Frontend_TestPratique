import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/publication_model.dart';

abstract class PublicationRemoteDataSource {
  Future<List<PublicationModel>> getPublications();
  Future<List<PublicationModel>> getMyPublications();
  Future<PublicationModel> getPublicationById(int id);
  Future<List<PublicationModel>> searchPublications(Map<String, dynamic> params);
  Future<PublicationModel> createPublication(Map<String, dynamic> data);
  Future<PublicationModel> updatePublication(int id, Map<String, dynamic> data);
  Future<void> deletePublication(int id);
  Future<PublicationModel> publishPublication(int id);
  Future<PublicationModel> archivePublication(int id);
}

class PublicationRemoteDataSourceImpl implements PublicationRemoteDataSource {

  PublicationRemoteDataSourceImpl({required this.dioClient});
  final DioClient dioClient;

  @override
  Future<List<PublicationModel>> getPublications() async {
    try {
      final response = await dioClient.get(ApiConstants.publications);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data is List
            ? response.data as List<dynamic>
            : (response.data['results'] as List<dynamic>);
        return data.map((json) => PublicationModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          message: 'Failed to get publications',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<List<PublicationModel>> getMyPublications() async {
    try {
      final response = await dioClient.get(ApiConstants.myPublications);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data is List
            ? response.data as List<dynamic>
            : (response.data['results'] as List<dynamic>);
        return data.map((json) => PublicationModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          message: 'Failed to get publications',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<PublicationModel> getPublicationById(int id) async {
    try {
      final response = await dioClient.get(ApiConstants.publicationDetail(id));

      if (response.statusCode == 200) {
        return PublicationModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Failed to get publication',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<List<PublicationModel>> searchPublications(
      Map<String, dynamic> params) async {
    try {
      final response = await dioClient.get(
        ApiConstants.searchPublications,
        queryParameters: params,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['results'] as List<dynamic>;
        return data.map((json) => PublicationModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          message: 'Failed to search publications',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<PublicationModel> createPublication(Map<String, dynamic> data) async {
    try {
      final response = await dioClient.post(
        ApiConstants.publications,
        data: data,
      );

      if (response.statusCode == 201) {
        return PublicationModel.fromJson(response.data['publication']);
      } else {
        throw ServerException(
          message: 'Failed to create publication',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<PublicationModel> updatePublication(
      int id, Map<String, dynamic> data) async {
    try {
      final response = await dioClient.patch(
        ApiConstants.publicationDetail(id),
        data: data,
      );

      if (response.statusCode == 200) {
        return PublicationModel.fromJson(response.data['publication']);
      } else {
        throw ServerException(
          message: 'Failed to update publication',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<void> deletePublication(int id) async {
    try {
      final response = await dioClient.delete(
        ApiConstants.publicationDetail(id),
      );

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw ServerException(
          message: 'Failed to delete publication',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<PublicationModel> publishPublication(int id) async {
    try {
      final response = await dioClient.post(
        ApiConstants.publishPublication(id),
      );

      if (response.statusCode == 200) {
        return PublicationModel.fromJson(response.data['publication']);
      } else {
        throw ServerException(
          message: 'Failed to publish publication',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<PublicationModel> archivePublication(int id) async {
    try {
      final response = await dioClient.post(
        ApiConstants.archivePublication(id),
      );

      if (response.statusCode == 200) {
        return PublicationModel.fromJson(response.data['publication']);
      } else {
        throw ServerException(
          message: 'Failed to archive publication',
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
          return ServerException(message: errorMessage, statusCode: statusCode);
        } else if (statusCode == 404) {
          return NotFoundException(message: errorMessage);
        } else {
          return ServerException(message: errorMessage, statusCode: statusCode);
        }

      case DioExceptionType.connectionError:
        return NetworkException(message: 'No internet connection');

      case DioExceptionType.cancel:
        return ServerException(message: 'Request cancelled');

      default:
        return ServerException(message: e.message ?? 'Unknown error occurred');
    }
  }
}