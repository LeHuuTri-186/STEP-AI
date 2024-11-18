
abstract class AuthSecureStorageRepository {
  Future<void> saveToken(String key, String token);
  Future<String?> getToken(String key);
  Future<void> deleteToken(String key);
}