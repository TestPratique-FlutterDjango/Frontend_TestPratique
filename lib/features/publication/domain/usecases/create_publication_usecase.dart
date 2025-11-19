import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:publications_app/core/uscases/usecase.dart';
import '../../../../core/error/failures.dart';
import '../entities/publication.dart';
import '../repositories/publication_repository.dart';

class CreatePublicationUseCase implements UseCase<Publication, CreatePublicationParams> {

  CreatePublicationUseCase(this.repository);
  final PublicationRepository repository;

  @override
  Future<Either<Failure, Publication>> call(CreatePublicationParams params) async {
    return repository.createPublication(
      title: params.title,
      content: params.content,
      status: params.status,
      companyId: params.companyId,
      tags: params.tags,
      imagePath: params.imagePath,
    );
  }
}

class CreatePublicationParams extends Equatable {

  const CreatePublicationParams({
    required this.title,
    required this.content,
    required this.status,
    this.companyId,
    this.tags,
    this.imagePath,
  });
  final String title;
  final String content;
  final String status;
  final int? companyId;
  final String? tags;
  final String? imagePath;

  @override
  List<Object?> get props => [
        title,
        content,
        status,
        companyId,
        tags,
        imagePath,
      ];
}