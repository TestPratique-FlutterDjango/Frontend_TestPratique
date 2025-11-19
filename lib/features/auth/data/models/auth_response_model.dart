import '../../domain/entities/auth_tokens.dart';
import 'user_model.dart';

class AuthResponseModel {

  AuthResponseModel({
    required this.user,
    required this.tokens,
    required this.message,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      tokens: AuthTokens(
        accessToken: json['tokens']['access'] as String,
        refreshToken: json['tokens']['refresh'] as String,
      ),
      message: json['message'] as String? ?? '',
    );
  }
  final UserModel user;
  final AuthTokens tokens;
  final String message;

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'tokens': {
        'access': tokens.accessToken,
        'refresh': tokens.refreshToken,
      },
      'message': message,
    };
  }
}