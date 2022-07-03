import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testingbloc_course/bloc/app_state.dart';
import 'package:testingbloc_course/bloc/bloc_events.dart';
import 'dart:math' as math;

typedef AppBlocRandomUrlPicker = String Function(Iterable<String> allUrls);

// Extension to create random element from Iterable
extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(math.Random().nextInt(length));
}

class AppBloc extends Bloc<AppEvent, AppState> {
  String _getRandomUrl(Iterable<String> allUrls) => allUrls.getRandomElement();

  AppBloc({
    required Iterable<String> urls,
    Duration? waitBeforeLoading,
    AppBlocRandomUrlPicker? urlPicker,
  }) : super(const AppState.empty()) {
    on<LoadNextUrlEvent>(
      (event, emit) async {
        // Start loading
        emit(const AppState(
          isLoading: true,
          data: null,
          error: null,
        ));

        final url = (urlPicker ?? _getRandomUrl)(urls);

        try {
          if (waitBeforeLoading != null) {
            await Future.delayed(waitBeforeLoading);
          }

          final bundle = NetworkAssetBundle(Uri.parse(url));
          final data = (await bundle.load(url)).buffer.asUint8List();

          emit(AppState(
            isLoading: false,
            data: data,
            error: null,
          ));
        } catch (e) {
          emit(
            AppState(
              isLoading: false,
              data: null,
              error: e,
            ),
          );
        }
      },
    );
  }
}
