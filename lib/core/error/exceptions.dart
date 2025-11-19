class ServerException implements Exception {

  ServerException({
    required this.message,
    this.statusCode,
  });
  final String message;
  final int? statusCode;

  @override
  String toString() => 'ServerException: $message (Code: $statusCode)';
}

class CacheException implements Exception {

  CacheException({required this.message});
  final String message;

  @override
  String toString() => 'CacheException: $message';
}

class NetworkException implements Exception {

  NetworkException({required this.message});
  final String message;

  @override
  String toString() => 'NetworkException: $message';
}

class UnauthorizedException implements Exception {

  UnauthorizedException({
    this.message = 'Unauthorized - Please login again',
  });
  final String message;

  @override
  String toString() => 'UnauthorizedException: $message';
}

class ValidationException implements Exception {

  ValidationException({required this.errors});
  final Map<String, dynamic> errors;

  @override
  String toString() => 'ValidationException: $errors';
}

class NotFoundException implements Exception {

  NotFoundException({
    this.message = 'Resource not found',
  });
  final String message;

  @override
  String toString() => 'NotFoundException: $message';
}

class TimeoutException implements Exception {

  TimeoutException({
    this.message = 'Request timeout',
  });
  final String message;

  @override
  String toString() => 'TimeoutException: $message';
}