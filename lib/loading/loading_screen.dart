import 'dart:async';
import 'package:flutter/material.dart';
import 'package:testingbloc_course/loading/loading_screen_controller.dart';

class LoadingScreen {
  // Singleton pattern
  LoadingScreen._sharedInstance();
  static late final LoadingScreen _shared = LoadingScreen._sharedInstance();
  factory LoadingScreen.instance() => _shared;

  LoadingScreenController? _controller;

  // This function is called to show loading overlay
  void show({
    required BuildContext context,
    required String text,
  }) {
    if (_controller?.update(text) ?? false) {
      return;
    } else {
      _controller = _showOverlay(
        context: context,
        text: text,
      );
    }
  }

  // To hide overlay
  void hide() {
    _controller?.close();
    _controller = null;
  }

  LoadingScreenController _showOverlay({
    required BuildContext context,
    required String text,
  }) {
    final _text = StreamController<String>();
    _text.add(text);

    // Overlays let independent child widgets "float" visual elements on top of other widgets by
    // inserting them into the overlay's stack. The overlay lets each of these widgets manage their
    // participation in the overlay using [OverlayEntry] objects.

    final state = Overlay.of(context);
    // renderBox is to know the sizing of the overlay
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(150),
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: size.width * 0.8, // 80% of width
                maxHeight: size.height * 0.8, // 80% of height
                minWidth: size.width * 0.5, //  50% of width
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10.0),
                      const CircularProgressIndicator(),
                      const SizedBox(height: 20.0),
                      StreamBuilder<String>(
                        stream: _text.stream,
                        builder: ((context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.data!,
                              textAlign: TextAlign.center,
                            );
                          } else {
                            return Container();
                          }
                        }),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    state?.insert(overlay);
    return LoadingScreenController(close: () {
      _text.close();
      overlay.remove();
      return true;
    }, update: (text) {
      _text.add(text);
      return true;
    });
  }
}
