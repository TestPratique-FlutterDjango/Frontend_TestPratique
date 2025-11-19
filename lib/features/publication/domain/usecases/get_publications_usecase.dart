import 'package:dartz/dartz.dart';
import 'package:publications_app/core/uscases/usecase.dart';
import '../../../../core/error/failures.dart';
import '../entities/publication.dart';
import '../repositories/publication_repository.dart';

class GetPublicationsUseCase implements UseCase<List<Publication>, NoParams> {

  GetPublicationsUseCase(this.repository);
  final PublicationRepository repository;

  @override
  Future<Either<Failure, List<Publication>>> call(NoParams params) async {
    return  repository.getPublications();
  }
}