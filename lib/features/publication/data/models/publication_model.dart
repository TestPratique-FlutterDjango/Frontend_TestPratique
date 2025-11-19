import 'package:logger/logger.dart';

import '../../domain/entities/publication.dart';

final _logger = Logger();
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
    // Gestion robuste de author_name
    String authorName = 'Utilisateur'; // Valeur par défaut
    
    try {
      // author_name existe directement (format liste)
      if (json.containsKey('author_name') && json['author_name'] != null) {
        authorName = json['author_name'].toString();
      }
      // author est un objet avec first_name et last_name
      else if (json['author'] is Map) {
        final author = json['author'] as Map<String, dynamic>;
        final firstName = author['first_name']?.toString() ?? '';
        final lastName = author['last_name']?.toString() ?? '';
        final fullName = '$firstName $lastName'.trim();
        if (fullName.isNotEmpty) {
          authorName = fullName;
        }
      }
    } catch (e) {
      _logger.e(' Erreur lors du parsing de author_name: $e');
    }
    
    // Gestion robuste de company_name
    String? companyName;
    try {
      if (json.containsKey('company_name') && json['company_name'] != null) {
        companyName = json['company_name'].toString();
      } else if (json['company'] is Map) {
        final company = json['company'] as Map<String, dynamic>;
        companyName = company['name']?.toString();
      }
    } catch (e) {
      _logger.e(' Erreur lors du parsing de company_name: $e');
    }
    
    // Gestion robuste de l'ID auteur
    int authorId = 0;
    try {
      if (json['author'] is Map) {
        authorId = json['author']['id'] as int? ?? 0;
      } else if (json['author'] is int) {
        authorId = json['author'] as int;
      }
    } catch (e) {
      _logger.e(' Erreur lors du parsing de author ID: $e');
    }
    
    // Gestion robuste de l'ID company
    int? companyId;
    try {
      if (json['company'] is Map) {
        companyId = json['company']['id'] as int?;
      } else if (json['company'] is int) {
        companyId = json['company'] as int;
      }
    } catch (e) {
      _logger.e(' Erreur lors du parsing de company ID: $e');
    }
    
    return PublicationModel(
      id: json['id'] as int,
      authorName: authorName,
      authorId: authorId,
      companyName: companyName,
      companyId: companyId,
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      status: PublicationStatus.fromString(json['status'] as String? ?? 'DRAFT'),
      slug: json['slug'] as String? ?? '',
      imageUrl: json['image'] as String?,
      viewsCount: json['views_count'] as int? ?? 0,
      publishedAt: json['published_at'] != null
          ? DateTime.tryParse(json['published_at'] as String)
          : null,
      tags: json['tags'] as String? ?? '',
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] as String? ?? '') ?? DateTime.now(),
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