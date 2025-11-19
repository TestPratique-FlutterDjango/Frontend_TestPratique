import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/publication.dart';

abstract class PublicationRepository {
  /// Obtention de la liste des publications
  Future<Either<Failure, List<Publication>>> getPublications();

  /// Obtention de la liste de mes publications
  Future<Either<Failure, List<Publication>>> getMyPublications();

  /// Obtention d'une publication par son ID
  Future<Either<Failure, Publication>> getPublicationById(int id);

  /// Recherche de publications avec des paramètres optionnels
  Future<Either<Failure, List<Publication>>> searchPublications({
    String? query,
    String? status,
    int? companyId,
    String? tags,
  });

  /// Création d'une nouvelle publication
  Future<Either<Failure, Publication>> createPublication({
    required String title,
    required String content,
    required String status,
    int? companyId,
    String? tags,
    String? imagePath,
  });

  /// Mise à jour d'une publication existante
  Future<Either<Failure, Publication>> updatePublication({
    required int id,
    required String title,
    required String content,
    required String status,
    int? companyId,
    String? tags,
    String? imagePath,
  });

  /// Suppression d'une publication
  Future<Either<Failure, void>> deletePublication(int id);

  /// Publier une publication
  Future<Either<Failure, Publication>> publishPublication(int id);

  /// Archiver une publication
  Future<Either<Failure, Publication>> archivePublication(int id);
}