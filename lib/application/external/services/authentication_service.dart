import 'package:google_sign_in/google_sign_in.dart';

import '../interfaces/authentication_interface.dart';

class Authentication implements IAuthentication {
  final GoogleSignIn _googleAccount = GoogleSignIn();

  @override
  Future<GoogleSignInAccount?> login() async => await _googleAccount.signIn();
  
  @override
  Future<void> logout() => _googleAccount.signOut();
  
  @override
  Future<GoogleSignInAccount?> currentAccount() => _googleAccount.signInSilently(); 
}