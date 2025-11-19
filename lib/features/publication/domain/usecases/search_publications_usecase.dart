import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:publications_app/core/uscases/usecase.dart';
import '../../../../core/error/failures.dart';
import '../entities/publication.dart';
import '../repositories/publication_repository.dart';

class SearchPublicationsUseCase implements UseCase<List<Publication>, SearchPublicationsParams> {

  SearchPublicationsUseCase(this.repository);
  final PublicationRepository repository;

  @override
  Future<Either<Failure, List<Publication>>> call(SearchPublicationsParams params) async {
    return repository.searchPublications(
      query: params.query,
      status: params.status,
      companyId: params.companyId,
      tags: params.tags,
    );
  }
}

class SearchPublicationsParams extends Equatable {

  const SearchPublicationsParams({
    this.query,
    this.status,
    this.companyId,
    this.tags,
  });
  final String? query;
  final String? status;
  final int? companyId;
  final String? tags;

  @override
  List<Object?> get props => [query, status, companyId, tags];
}