class Constant{
  //API:------------------------------------------------------------------------
  static String apiBaseUrl = 'https://api.jarvis.cx';

  static String loginEndpoint = '/api/v1/auth/sign-in';
  static String registerEndpoint = '/api/v1/auth/sign-up';
  static String logoutEndpoint = '/api/v1/auth/sign-out';
  static String refreshTokenPartEndpoint = '/api/v1/auth/refresh?refreshToken=';
  //Tokens map key:-------------------------------------------------------------
  static String access = 'AccessToken';
  static String refresh = 'RefreshToken';
}