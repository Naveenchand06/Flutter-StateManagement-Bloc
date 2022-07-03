import 'package:flutter/foundation.dart' show immutable;

// This file contains the Actions or Events involved in this app.
// Parameters required for the action is defined in the corresponsing action class.

@immutable
abstract class AppAction {
  const AppAction();
}

@immutable
class LoginAction implements AppAction {
  final String email;
  final String password;

  const LoginAction({
    required this.email,
    required this.password,
  });
}

@immutable
class LoadNotesAction implements AppAction {}
