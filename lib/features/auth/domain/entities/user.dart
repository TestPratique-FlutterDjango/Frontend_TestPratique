import 'package:equatable/equatable.dart';

class User extends Equatable {

  const User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.accountType, 
    required this.isVerified, 
    required this.createdAt, 
    required this.updatedAt, 
    this.address,
    this.companyName,
    this.cfeNumber,
  });
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String? address;
  final String accountType;
  final String? companyName;
  final String? cfeNumber;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

  String get fullName => '$firstName $lastName';

  bool get isProfessional => accountType == 'PROFESSIONAL';

  bool get isPrivate => accountType == 'PRIVATE';

  @override
  List<Object?> get props => [
        id,
        email,
        firstName,
        lastName,
        address,
        accountType,
        companyName,
        cfeNumber,
        isVerified,
        createdAt,
        updatedAt,
      ];
}