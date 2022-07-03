import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testingbloc_course/api/login_api.dart';
import 'package:testingbloc_course/api/notes_api.dart';
import 'package:testingbloc_course/bloc/actions.dart';
import 'package:testingbloc_course/bloc/app_bloc.dart';
import 'package:testingbloc_course/bloc/app_state.dart';
import 'package:testingbloc_course/dialog/generic_dialog.dart';
import 'package:testingbloc_course/dialog/loading_screen.dart';
import 'package:testingbloc_course/models.dart';
import 'package:testingbloc_course/views/iterable_list_view.dart';
import 'package:testingbloc_course/views/login_view.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    ),
  );
}

// We are mocking two APIs - login, load notes

// Based on the events, app's state will change
// So, the current state is AppState class
// The bloc we created for this is AppBloc class
// Actions or events that can happen in the app are listed in 'actions.dart' file.
// Define how the state should change when a action is happening in the constructor of AppBloc class

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(
        loginApi: LoginApi.instance(),
        notesApi: NotesApi(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        body: BlocConsumer<AppBloc, AppState>(
          listener: (context, appState) {
            // Loading Screen
            if (appState.isLoading) {
              LoadingScreen.instance().show(
                context: context,
                text: 'Please wait...',
              );
            } else {
              LoadingScreen.instance().hide();
            }

            // Display possible error
            final loginError = appState.loginError;
            if (loginError != null) {
              showGenericDialog(
                context: context,
                title: 'Login Error',
                content: 'There is an error while login',
                optionsBuilder: () => {'Ok': true},
              );
            }

            // if we logged in, but we have no fetched notes, fetch them now
            if (appState.isLoading == false &&
                appState.loginError == null &&
                appState.loginHandle == const LoginHandle.fooBar() &&
                appState.fetchedNotes == null) {
              // Triggering an Action or Event from UI
              context.read<AppBloc>().add(
                    LoadNotesAction(),
                  );
            }
          },
          builder: (context, appState) {
            final notes = appState.fetchedNotes;
            if (notes == null) {
              return LoginView(
                onLoginTapped: (email, password) {
                  // Triggering an Action or Event from UI
                  context.read<AppBloc>().add(
                        LoginAction(email: email, password: password),
                      );
                },
              );
            } else {
              return notes.toListView();
            }
          },
        ),
      ),
    );
  }
}
