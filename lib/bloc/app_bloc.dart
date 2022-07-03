import 'package:bloc/bloc.dart';
import 'package:testingbloc_course/api/login_api.dart';
import 'package:testingbloc_course/api/notes_api.dart';
import 'package:testingbloc_course/bloc/actions.dart';
import 'package:testingbloc_course/bloc/app_state.dart';
import 'package:testingbloc_course/models.dart';

// A Bloc class requires BLOC<Event, State>

class AppBloc extends Bloc<AppAction, AppState> {
  final LoginApiProtocol loginApi;
  final NotesApiProtocol notesApi;

  AppBloc({
    required this.loginApi,
    required this.notesApi,
  }) : super(const AppState.empty()) {
    // Triggered when login
    on<LoginAction>(
      ((event, emit) async {
        // start loading (Loading is changed by emit loading state)
        emit(const AppState(
          isLoading: true,
          loginError: null,
          loginHandle: null,
          fetchedNotes: null,
        ));

        // Log the user in
        final loginHandle =
            await loginApi.login(email: event.email, password: event.password);

        // After login in stop loading and handle login errors if any
        emit(
          AppState(
            isLoading: false,
            loginError: loginHandle == null ? LoginErrors.invalidHandle : null,
            loginHandle: loginHandle,
            fetchedNotes: null,
          ),
        );
      }),
    );

    // Triggered while fetching notes
    on<LoadNotesAction>(
      (event, emit) async {
        // start loading (Loading is changed by emit loading state)
        // get the login handle from state
        emit(
          AppState(
            isLoading: true,
            loginError: null,
            loginHandle: state
                .loginHandle, // We can access the current state of the app using 'state' available from BLOC
            fetchedNotes: null,
          ),
        );

        // Get login handle
        final loginHandle = state.loginHandle;
        if (loginHandle != const LoginHandle.fooBar()) {
          // invalid login handle , cannot fetch notes
          emit(
            AppState(
              isLoading: false,
              loginError: LoginErrors.invalidHandle,
              loginHandle: loginHandle,
              fetchedNotes: null,
            ),
          );
          return;
        }
        // We have a valid login handle, we can fetch notes
        final notes = await notesApi.getNotes(loginHandle: loginHandle!);
        emit(
          AppState(
            isLoading: false,
            loginError: null,
            loginHandle: loginHandle,
            fetchedNotes: notes,
          ),
        );
      },
    );
  }
}
