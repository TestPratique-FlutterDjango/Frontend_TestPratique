import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/publication.dart';

abstract class PublicationRepository {
  /// Get all published publications
  Future<Either<Failure, List<Publication>>> getPublications();

  /// Get user's publications (all statuses)
  Future<Either<Failure, List<Publication>>> getMyPublications();

  /// Get publication by id
  Future<Either<Failure, Publication>> getPublicationById(int id);

  /// Search publications
  Future<Either<Failure, List<Publication>>> searchPublications({
    String? query,
    String? status,
    int? companyId,
    String? tags,
  });

  /// Create publication
  Future<Either<Failure, Publication>> createPublication({
    required String title,
    required String content,
    required String status,
    int? companyId,
    String? tags,
    String? imagePath,
  });

  /// Update publication
  Future<Either<Failure, Publication>> updatePublication({
    required int id,
    required String title,
    required String content,
    required String status,
    int? companyId,
    String? tags,
    String? imagePath,
  });

  /// Delete publication
  Future<Either<Failure, void>> deletePublication(int id);

  /// Publish publication (change status to PUBLISHED)
  Future<Either<Failure, Publication>> publishPublication(int id);

  /// Archive publication
  Future<Either<Failure, Publication>> archivePublication(int id);
}