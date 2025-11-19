class RegisterRequestModel {

  RegisterRequestModel({
    required this.email,
    required this.password,
    required this.passwordConfirm,
    required this.firstName,
    required this.lastName,
    required this.accountType, 
    this.address,
    this.companyName,
    this.cfeNumber,
  });
  final String email;
  final String password;
  final String passwordConfirm;
  final String firstName;
  final String lastName;
  final String? address;
  final String accountType;
  final String? companyName;
  final String? cfeNumber;

  Map<String, dynamic> toJson() {
    final map = {
      'email': email,
      'password': password,
      'password_confirm': passwordConfirm,
      'first_name': firstName,
      'last_name': lastName,
      'account_type': accountType,
    };

    if (address != null && address!.isNotEmpty) {
      map['address'] = address!;
    }

    if (companyName != null && companyName!.isNotEmpty) {
      map['company_name'] = companyName!;
    }

    if (cfeNumber != null && cfeNumber!.isNotEmpty) {
      map['cfe_number'] = cfeNumber!;
    }

    return map;
  }
}