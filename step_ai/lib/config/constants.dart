class Constant{
  Constant._();
  //API:------------------------------------------------------------------------
  static String apiBaseUrl = 'https://api.jarvis.cx';

  static String loginEndpoint = '/api/v1/auth/sign-in';
  static String registerEndpoint = '/api/v1/auth/sign-up';
  static String logoutEndpoint = '/api/v1/auth/sign-out';
  static String refreshTokenPartEndpoint = '/api/v1/auth/refresh?refreshToken=';

  static String promptSearchBaseEndpoint = '/api/v1/prompts?';
  static String promptSearchQuery = 'query=';
  static String promptSearchOffset = 'offset=';
  static String promptSearchLimit = 'limit=';
  static String promptSearchIsFavorite = 'isFavorite=';
  static String promptSearchIsPublic = 'isPublic';
  //Tokens map key:-------------------------------------------------------------
  static String access = 'AccessToken';
  static String refresh = 'RefreshToken';

  //Test
  static String KB_accessToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImJlZjgxMDA4LTg4MTktNGM5NS1iNzZjLWQwODA3YzU0MTNiNSIsImVtYWlsIjoibmd1eWVuYm9jaGFAZ21haWwuY29tIiwiaWF0IjoxNzMzNzYyMzgzLCJleHAiOjE3MzM4NDg3ODN9.4Y301njs7H1CivCmCJpIIAKjwIxDR-CGjKnqBLmkEOE';
}