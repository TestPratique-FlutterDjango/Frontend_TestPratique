import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {

  const Failure(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {

  const ServerFailure(super.message, {this.statusCode});
  final int? statusCode;

  @override
  List<Object> get props => [message, statusCode ?? 0];
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(super.message);
}

class ValidationFailure extends Failure {

  const ValidationFailure(super.message, {this.errors});
  final Map<String, dynamic>? errors;

  @override
  List<Object> get props => [message, errors ?? {}];
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure(super.message);
}

// Helper function to get user-friendly error message
String getFailureMessage(Failure failure) {
  if (failure is ServerFailure) {
    return 'Erreur serveur: ${failure.message}';
  } else if (failure is NetworkFailure) {
    return 'Erreur de connexion. Vérifiez votre connexion internet.';
  } else if (failure is UnauthorizedFailure) {
    return 'Session expirée. Veuillez vous reconnecter.';
  } else if (failure is ValidationFailure) {
    return 'Données invalides: ${failure.message}';
  } else if (failure is NotFoundFailure) {
    return 'Ressource introuvable.';
  } else if (failure is TimeoutFailure) {
    return "Délai d'attente dépassé. Veuillez réessayer.";
  } else if (failure is CacheFailure) {
    return 'Erreur de cache local.';
  }
  return "Une erreur inattendue s'est produite.";
}