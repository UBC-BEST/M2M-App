/* import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
 import 'package:flutter_unity_widget/flutter_unity_widget.dart';

class FullScreenUnityGame extends StatefulWidget {
  final String gameName;

  const FullScreenUnityGame({super.key, required this.gameName});

  @override
  State<FullScreenUnityGame> createState() => _FullScreenUnityGameState();
}

class _FullScreenUnityGameState extends State<FullScreenUnityGame> {
  UnityWidgetController? _unityWidgetController;

  @override
  void initState() {
    super.initState();

    // Locks the orientation to landscape when entering the game
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // Hide the status bar and navigation bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Unity Game
          Positioned.fill(
            child: UnityWidget(
              onUnityCreated: onUnityCreated,
              onUnityUnloaded: onUnityUnloaded,
              onUnityMessage: onUnityMessage,
            ),
          ),
          // Black Bar with Close Button
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black,
              height: 50, // Height of the black bar
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: _exitGame,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Callback to initialize Unity controller
  void onUnityCreated(UnityWidgetController controller) {
    _unityWidgetController = controller;

    // Pass the game name to Unity to load the correct scene
    // (josh) Not sure how this will work. Hoping that it will help us navicate between games
    _unityWidgetController?.postMessage(
      'GameManager', // Unity GameObject name
      'LoadGame', // Unity method
      widget.gameName,
    );
  }

  void onUnityMessage(dynamic message) {
    debugPrint("Unity Message: $message");
  }

  void onUnityUnloaded() {
    debugPrint("Unity has been unloaded!");
  }

  void _exitGame() {
    // Restore orientation and UI when exiting the game
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    Navigator.pop(context);
  }

  @override
  void dispose() {
    // Restore orientation and UI on dispose
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }
}
  */
