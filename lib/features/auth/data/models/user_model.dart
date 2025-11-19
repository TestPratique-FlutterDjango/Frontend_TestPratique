import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.firstName,
    required super.lastName,
    required super.accountType, 
    required super.isVerified, 
    required super.createdAt, 
    required super.updatedAt, 
    super.address,
    super.companyName,
    super.cfeNumber,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      email: json['email'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      address: json['address'] as String?,
      accountType: json['account_type'] as String,
      companyName: json['company_name'] as String?,
      cfeNumber: json['cfe_number'] as String?,
      isVerified: json['is_verified'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'address': address,
      'account_type': accountType,
      'company_name': companyName,
      'cfe_number': cfeNumber,
      'is_verified': isVerified,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  User toEntity() {
    return User(
      id: id,
      email: email,
      firstName: firstName,
      lastName: lastName,
      address: address,
      accountType: accountType,
      companyName: companyName,
      cfeNumber: cfeNumber,
      isVerified: isVerified,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}