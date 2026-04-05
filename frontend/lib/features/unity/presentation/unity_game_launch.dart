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
    _enterImmersiveLandscape();
    _bridge.addListener(_onBridgeUpdate);
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await _bridge.ensureInitialized();
    await _bridge.startSession(widget.game);
  }

  Future<void> _enterImmersiveLandscape() async {
    await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
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

    final isConnected = _bridge.isSensorConnected;
    final status = _bridge.status;
    final sensorValue = _bridge.currentSensorPercent.toStringAsFixed(1);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: UnityWidget(
              onUnityCreated: _onUnityCreated,
              onUnityUnloaded: _onUnityUnloaded,
              onUnityMessage: _onUnityMessage,
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.all(12),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            widget.game.displayName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            status,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    _StatusPill(
                      label: isConnected
                          ? 'Sensor $sensorValue%'
                          : 'Sensor offline',
                      ok: isConnected,
                    ),
                    const SizedBox(width: 8),
                    _StatusPill(
                      label:
                          _bridge.unityReady ? 'Unity ready' : 'Unity loading',
                      ok: _bridge.unityReady,
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: _closeGame,
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.label,
    required this.ok,
  });

  final String label;
  final bool ok;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: ok ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
