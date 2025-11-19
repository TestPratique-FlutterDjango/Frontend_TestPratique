import 'package:equatable/equatable.dart';

class Company extends Equatable {

  const Company({
    required this.id,
    required this.userId,
    required this.name,
    required this.cfeNumber,
    required this.address,
    required this.isActive, 
    required this.publicationsCount, 
    required this.createdAt, 
    required this.updatedAt, 
    this.phone,
    this.email,
    this.description,
    this.website,
  });
  final int id;
  final int userId;
  final String name;
  final String cfeNumber;
  final String address;
  final String? phone;
  final String? email;
  final String? description;
  final String? website;
  final bool isActive;
  final int publicationsCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        cfeNumber,
        address,
        phone,
        email,
        description,
        website,
        isActive,
        publicationsCount,
        createdAt,
        updatedAt,
      ];
}