class ApiConstants {
  // Base URL
  static const String baseUrl = 'http://10.0.2.2:8000'; //'https://backend-testpratique-2.onrender.com';
  
  // Timeout
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Auth Endpoints
  static const String login = '/api/auth/login/';
  static const String register = '/api/auth/register/';
  static const String logout = '/api/auth/logout/';
  static const String profile = '/api/auth/profile/';
  static const String changePassword = '/api/auth/change-password/';
  static const String refreshToken = '/api/auth/token/refresh/';
  
  // Company Endpoints
  static const String companies = '/api/companies/';
  static String companyDetail(int id) => '/api/companies/$id/';
  static String toggleCompanyStatus(int id) => '/api/companies/$id/toggle_status/';
  static String companyPublications(int id) => '/api/companies/$id/publications/';
  
  // Publication Endpoints
  static const String publications = '/api/publications/';
  static String publicationDetail(int id) => '/api/publications/$id/';
  static const String myPublications = '/api/publications/my_publications/';
  static const String searchPublications = '/api/publications/search/';
  static String publishPublication(int id) => '/api/publications/$id/publish/';
  static String archivePublication(int id) => '/api/publications/$id/archive/';
  
  // Headers
  static const String contentType = 'application/json';
  static const String accept = 'application/json';
  
  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String isLoggedInKey = 'is_logged_in';
}