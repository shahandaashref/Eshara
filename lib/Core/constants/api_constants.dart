class ApiConstants {
  static const String baseUrl = 'https://eshara.runasp.net';
  static const int connectTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  static const int sendTimeout = 30000; // 30 seconds
  
  // Auth Endpoints
  static const String login = '/api/auth/login';
  static const String register = '/api/auth/register';
  static const String verifyOtp = '/api/auth/verify';
  static const String resendOtp = '/api/auth/resend-otp';
  
  // Dictionary Endpoints
  static const String getSigns = '/api/dictionary/signs';
  static const String searchSigns = '/api/dictionary/search';
  
  // Profile Endpoints
  static const String profile = '/api/profile';
  static const String updateProfile = '/api/profile/update';
  static const String logout = '/api/auth/logout';
  
  // Admin Endpoints
  static const String adminWords = '/api/admin/words';
  static const String adminCategories = '/api/admin/categories';
  static const String adminRequests = '/api/admin/requests';
  static const String adminUsers = '/api/admin/users';
  
  // Text to Sign
  static const String textToSign = '/api/text-to-sign/convert';
  
  // Sign to Text
  static const String signToText = '/api/sign-to-text/translate';
  
  // Add Word
  static const String addWordRequest = '/api/add-word/request';
  
  // استثناء المسارات التي لا تحتاج توكن
  static const List<String> publicPaths = [
    '/api/auth/login',
    '/api/auth/register',
    '/api/auth/verify',
    '/api/auth/resend-otp',
  ];
}