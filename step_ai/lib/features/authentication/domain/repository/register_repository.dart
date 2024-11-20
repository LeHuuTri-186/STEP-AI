abstract class RegisterRepository{
  Future<int> register(String email, String password, String username);
}