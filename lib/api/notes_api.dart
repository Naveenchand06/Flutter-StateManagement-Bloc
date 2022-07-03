import 'package:flutter/foundation.dart' show immutable;
import 'package:testingbloc_course/models.dart';

// Mocking load notes API

@immutable
abstract class NotesApiProtocol {
  const NotesApiProtocol();

  Future<Iterable<Note>?> getNotes({
    required LoginHandle loginHandle,
  });
}

class NotesApi implements NotesApiProtocol {
  @override
  Future<Iterable<Note>?> getNotes({
    required LoginHandle loginHandle,
  }) =>
      Future.delayed(const Duration(seconds: 2),
          () => loginHandle == const LoginHandle.fooBar() ? mockNotes : null);
}
