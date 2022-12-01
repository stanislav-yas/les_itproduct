abstract class AuthRepository {
  Future<dynamic> signUp({
    required String username,
    required String password,
    required String email,
  });

  Future<dynamic> signIn({
    required String username,
    required String password,
  });

  Future<dynamic> getProfile();

  Future<dynamic> userUpdate({
    String? username,
    String? email,
  });

  Future<dynamic> passwordUpdate({
    required String oldPassword,
    required String newPassword,
  });

  Future<dynamic> refreshToken({required String refreshToken});
}
