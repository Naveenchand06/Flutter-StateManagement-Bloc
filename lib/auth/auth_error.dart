import 'package:flutter/foundation.dart' show immutable;

const Map<String, AuthError> authErrorMapping = {};

@immutable
abstract class AuthError {
  final String dialogTitle;
  final String dialogText;

  const AuthError({
    required this.dialogTitle,
    required this.dialogText,
  });
}
