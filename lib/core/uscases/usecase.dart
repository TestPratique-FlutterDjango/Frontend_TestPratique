import 'package:dartz/dartz.dart';
import '../error/failures.dart';

/// classe abstraite pour les cas d'utilisation (use cases)
/// [Type] est le type de retour
/// [Params] est le type des paramètres
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// utilitaire pour les cas d'utilisation sans paramètres
class NoParams {
  const NoParams();
}