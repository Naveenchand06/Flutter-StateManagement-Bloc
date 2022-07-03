import 'package:flutter/material.dart';
import 'package:testingbloc_course/views/home_page.dart';

// We are implementing MultiBlocProvider
// for that, we are using one event and two Blocs which extends one parent Bloc
// This parent bloc contains the Event Action or state change based on the event

// |-> AppBlocView is a Generic Widget for AppBloc.
// |-> AppBlocView triggers a function which create a periodic stream of events (triggers BLOC) NOTE: GENERIC BLOC

// |-> HomePage provides two blocs using MultiBlocProvider
// |-> AppBlocView gets changed based on its State. NOTE: AppBlocView is a Generic

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
