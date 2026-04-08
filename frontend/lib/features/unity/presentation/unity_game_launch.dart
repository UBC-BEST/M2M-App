import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

import '../application/sensor_game_bridge.dart';
import '../domain/unity_game.dart';

class UnityGameLaunchPage extends StatefulWidget {
  const UnityGameLaunchPage({
    super.key,
    required this.game,
  });

  final UnityGame game;

  @override
  State<UnityGameLaunchPage> createState() => _UnityGameLaunchPageState();
}

class _UnityGameLaunchPageState extends State<UnityGameLaunchPage> {
  final SensorGameBridge _bridge = SensorGameBridge.instance;

  @override
  void initState() {
    super.initState();
    _applyGameOrientation();
    _bridge.addListener(_onBridgeUpdate);
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await _bridge.ensureInitialized();
    await _bridge.startSession(widget.game);
  }

  Future<void> _applyGameOrientation() async {
    await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  Future<void> _restorePortraitSystemUi() async {
    await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  void _onBridgeUpdate() {
    if (!mounted) return;
    setState(() {});
  }

  void _onUnityCreated(UnityWidgetController controller) {
    _bridge.attachController(controller);
  }

  void _onUnityMessage(dynamic message) {
    _bridge.onUnityMessage(message);
  }

  void _onUnityUnloaded() {
    _bridge.detachController();
  }

  Future<void> _closeGame() async {
    _bridge.stopSession();
    await _restorePortraitSystemUi();
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _bridge.removeListener(_onBridgeUpdate);
    _bridge.stopSession();
    _restorePortraitSystemUi();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.game.displayName),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Icon(
                Icons.web_asset_off_outlined,
                size: 40,
                color: Colors.orange,
              ),
              const SizedBox(height: 16),
              const Text(
                'Unity games are not supported on Flutter Web in this build.',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Use an Android or iOS target to run the embedded Unity game.',
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 8),
              Text(
                'Current game: ${widget.game.displayName}',
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back to Games'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: ColoredBox(
              color: Colors.black,
              child: UnityWidget(
                onUnityCreated: _onUnityCreated,
                onUnityUnloaded: _onUnityUnloaded,
                onUnityMessage: _onUnityMessage,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Align(
                alignment: Alignment.topLeft,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.55),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    tooltip: 'Back to games',
                    onPressed: _closeGame,
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
