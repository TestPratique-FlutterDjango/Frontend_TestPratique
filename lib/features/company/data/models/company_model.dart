import 'package:logger/logger.dart';

import '../../domain/entities/company.dart';
final _logger = Logger();
class CompanyModel extends Company {
  const CompanyModel({
    required super.id,
    required super.userId,
    required super.name,
    required super.cfeNumber,
    required super.address,
    required super.isActive, 
    required super.publicationsCount, 
    required super.createdAt, 
    required super.updatedAt, 
    super.phone,
    super.email,
    super.description,
    super.website,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    // Gestion robuste de userId
    int userId = 0;
    try {
      if (json['user'] is Map) {
        userId = json['user']['id'] as int? ?? 0;
      } else if (json['user'] is int) {
        userId = json['user'] as int;
      }
    } catch (e) {
      _logger.e('Erreur lors du parsing de user ID: $e');
    }
    
    return CompanyModel(
      id: json['id'] as int,
      userId: userId,
      name: json['name'] as String? ?? '',
      cfeNumber: json['cfe_number'] as String? ?? '',
      address: json['address'] as String? ?? '',
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      description: json['description'] as String?,
      website: json['website'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      publicationsCount: json['publications_count'] as int? ?? 0,
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': userId,
      'name': name,
      'cfe_number': cfeNumber,
      'address': address,
      'phone': phone,
      'email': email,
      'description': description,
      'website': website,
      'is_active': isActive,
      'publications_count': publicationsCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Company toEntity() {
    return Company(
      id: id,
      userId: userId,
      name: name,
      cfeNumber: cfeNumber,
      address: address,
      phone: phone,
      email: email,
      description: description,
      website: website,
      isActive: isActive,
      publicationsCount: publicationsCount,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}