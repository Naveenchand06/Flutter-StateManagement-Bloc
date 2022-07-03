import 'package:flutter/foundation.dart' show immutable;
import 'package:testingbloc_course/models.dart';

// Mocking login API

@immutable
abstract class LoginApiProtocol {
  const LoginApiProtocol();

  // We are saying that whoever wants to be an API has to be implement this login function
  Future<LoginHandle?> login({required String email, required String password});
}

class LoginApi implements LoginApiProtocol {
  // Singleton pattern (These 3 lines is used to create singleton in dart)
  const LoginApi._sharedInstance();
  static const LoginApi _shared = LoginApi._sharedInstance();
  factory LoginApi.instance() => _shared;

  @override
  Future<LoginHandle?> login(
          {required String email, required String password}) =>
      Future.delayed(const Duration(seconds: 3),
              () => email == 'foo@bar.com' && password == 'foobar')
          .then((isLoggedIn) => isLoggedIn ? const LoginHandle.fooBar() : null);
}
