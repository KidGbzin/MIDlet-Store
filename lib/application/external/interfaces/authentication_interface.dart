abstract interface class IAuthentication {
  Future<dynamic> currentAccount();

  Future<dynamic> login();

  Future<void> logout();
}