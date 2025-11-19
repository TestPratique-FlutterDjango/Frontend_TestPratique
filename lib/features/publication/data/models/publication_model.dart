import '../../domain/entities/publication.dart';

class PublicationModel extends Publication {
  const PublicationModel({
    required super.id,
    required super.authorName,
    required super.authorId,
    required super.title, 
    required super.content, 
    required super.status, 
    required super.slug, 
    required super.viewsCount, 
    required super.tags, 
    required super.createdAt, 
    required super.updatedAt, 
    super.companyName,
    super.companyId,
    super.imageUrl,
    super.publishedAt,
  });

  factory PublicationModel.fromJson(Map<String, dynamic> json) {
    // Extraire author_name de différentes façons possibles
    String authorName = '';
    
    if (json['author_name'] != null && json['author_name'] is String) {
      authorName = json['author_name'] as String;
    } else if (json['author'] is Map) {
      final author = json['author'] as Map<String, dynamic>;
      final firstName = author['first_name'] ?? '';
      final lastName = author['last_name'] ?? '';
      authorName = '$firstName $lastName'.trim();
    }
    
    return PublicationModel(
      id: json['id'] as int,
      authorName: authorName.isEmpty ? 'Utilisateur' : authorName,
      authorId: json['author'] is Map
          ? json['author']['id'] as int
          : json['author'] as int? ?? 0,
      companyName: json['company_name'] as String?,
      companyId: json['company'] as int?,
      title: json['title'] as String,
      content: json['content'] as String,
      status: PublicationStatus.fromString(json['status'] as String),
      slug: json['slug'] as String,
      imageUrl: json['image'] as String?,
      viewsCount: json['views_count'] as int? ?? 0,
      publishedAt: json['published_at'] != null
          ? DateTime.parse(json['published_at'] as String)
          : null,
      tags: json['tags'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author_name': authorName,
      'author': authorId,
      'company_name': companyName,
      'company': companyId,
      'title': title,
      'content': content,
      'status': status.toApiString(),
      'slug': slug,
      'image': imageUrl,
      'views_count': viewsCount,
      'published_at': publishedAt?.toIso8601String(),
      'tags': tags,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Publication toEntity() {
    return Publication(
      id: id,
      authorName: authorName,
      authorId: authorId,
      companyName: companyName,
      companyId: companyId,
      title: title,
      content: content,
      status: status,
      slug: slug,
      imageUrl: imageUrl,
      viewsCount: viewsCount,
      publishedAt: publishedAt,
      tags: tags,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}