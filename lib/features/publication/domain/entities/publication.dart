import 'package:equatable/equatable.dart';

enum PublicationStatus {
  draft,
  published,
  archived;

  String get displayName {
    switch (this) {
      case PublicationStatus.draft:
        return 'Brouillon';
      case PublicationStatus.published:
        return 'Publié';
      case PublicationStatus.archived:
        return 'Archivé';
    }
  }

  static PublicationStatus fromString(String status) {
    switch (status.toUpperCase()) {
      case 'DRAFT':
        return PublicationStatus.draft;
      case 'PUBLISHED':
        return PublicationStatus.published;
      case 'ARCHIVED':
        return PublicationStatus.archived;
      default:
        return PublicationStatus.draft;
    }
  }

  String toApiString() {
    return name.toUpperCase();
  }
}

class Publication extends Equatable {

  const Publication({
    required this.id,
    required this.authorName,
    required this.authorId,
    required this.title, 
    required this.content, 
    required this.status, 
    required this.slug, 
    required this.viewsCount, 
    required this.tags, 
    required this.createdAt, 
    required this.updatedAt, 
    this.companyName,
    this.companyId,
    this.imageUrl,
    this.publishedAt,
  });
  final int id;
  final String authorName;
  final int authorId;
  final String? companyName;
  final int? companyId;
  final String title;
  final String content;
  final PublicationStatus status;
  final String slug;
  final String? imageUrl;
  final int viewsCount;
  final DateTime? publishedAt;
  final String tags;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isPublished => status == PublicationStatus.published;
  bool get isDraft => status == PublicationStatus.draft;
  bool get isArchived => status == PublicationStatus.archived;

  List<String> get tagsList {
    if (tags.isEmpty) return [];
    return tags.split(',').map((tag) => tag.trim()).where((tag) => tag.isNotEmpty).toList();
  }

  @override
  List<Object?> get props => [
        id,
        authorName,
        authorId,
        companyName,
        companyId,
        title,
        content,
        status,
        slug,
        imageUrl,
        viewsCount,
        publishedAt,
        tags,
        createdAt,
        updatedAt,
      ];
}