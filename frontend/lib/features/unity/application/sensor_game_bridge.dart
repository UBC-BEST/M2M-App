import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

import '../../../core/services/bluetooth_sensor_service.dart';
import '../data/game_calibration_store.dart';
import '../domain/game_calibration_preset.dart';
import '../domain/unity_game.dart';
import '../domain/unity_sensor_payload.dart';

class SensorGameBridge extends ChangeNotifier {
  SensorGameBridge._();

  static final SensorGameBridge instance = SensorGameBridge._();

  static const int _bridgeVersion = 1;
  static const Duration _sendInterval = Duration(milliseconds: 66);

  final BluetoothSensorService _sensorService = BluetoothSensorService.instance;
  final GameCalibrationStore _calibrationStore = GameCalibrationStore();
  final Map<UnityGame, GameCalibrationPreset> _presets =
      <UnityGame, GameCalibrationPreset>{};
  final Map<String, int> _cooldownsUntilMs = <String, int>{};

  UnityWidgetController? _unityController;
  UnityGame? _activeGame;
  Timer? _sendTimer;
  bool _initialized = false;
  bool _unityReady = false;
  int _pizzaLaneIndex = 0;
  String _status = 'Idle';
  String _lastUnityEvent = '';

  UnityGame? get activeGame => _activeGame;
  bool get unityReady => _unityReady;
  bool get isSessionActive => _activeGame != null;
  bool get isSensorConnected => _sensorService.isConnected;
  double get currentSensorPercent =>
      _sensorService.currentPercent.clamp(0, 100);
  String get status => _status;
  String get lastUnityEvent => _lastUnityEvent;

  Future<void> ensureInitialized() async {
    if (_initialized) return;
    _initialized = true;
    _sensorService.addListener(_onSensorUpdate);
    await _sensorService.ensureInitialized(autoConnect: true);
    await _loadPresets();
    _setStatus('Ready');
  }

  Future<void> disposeBridge() async {
    _sensorService.removeListener(_onSensorUpdate);
    _sendTimer?.cancel();
    _sendTimer = null;
    _activeGame = null;
    _unityController = null;
    _unityReady = false;
    _status = 'Idle';
  }

  void attachController(UnityWidgetController controller) {
    _unityController = controller;
    _unityReady = false;
    _lastUnityEvent = 'controller_attached';
    _setStatus('Unity controller attached');
    _sendSessionStart();
  }

  void detachController() {
    _unityController = null;
    _unityReady = false;
    _setStatus('Unity controller detached');
  }

  Future<void> startSession(UnityGame game) async {
    await ensureInitialized();
    _activeGame = game;
    _pizzaLaneIndex = 0;
    _cooldownsUntilMs.clear();
    _setStatus('Starting ${game.displayName}');
    _sendSessionStart();
    _sendTimer?.cancel();
    _sendTimer = Timer.periodic(_sendInterval, (_) => _sendSensorFrame());
    notifyListeners();
  }

  void stopSession() {
    _sendTimer?.cancel();
    _sendTimer = null;
    _activeGame = null;
    _setStatus('Session ended');
    notifyListeners();
  }

  Future<GameCalibrationPreset> readPreset(UnityGame game) async {
    if (_presets.containsKey(game)) {
      return _presets[game]!;
    }

    final preset = await _calibrationStore.readPreset(game);
    _presets[game] = preset;
    return preset;
  }

  Future<void> savePreset(UnityGame game, GameCalibrationPreset preset) async {
    _presets[game] = preset;
    await _calibrationStore.writePreset(game, preset);
    notifyListeners();
  }

  Future<bool> hasPreset(UnityGame game) async {
    return _calibrationStore.hasPreset(game);
  }

  void onUnityMessage(dynamic message) {
    final payload = _parseUnityMessage(message);
    final eventName = payload['event']?.toString();
    if (eventName == null || eventName.isEmpty) {
      _lastUnityEvent = message.toString();
      notifyListeners();
      return;
    }

    _lastUnityEvent = eventName;
    if (eventName == 'ready') {
      _unityReady = true;
      _setStatus('Unity ready');
    } else if (eventName == 'score_update') {
      _setStatus('Score update received');
    } else if (eventName == 'game_over') {
      _setStatus('Game over');
    } else if (eventName == 'error') {
      _setStatus('Unity error', isError: true);
    } else {
      notifyListeners();
    }
  }

  Future<void> _loadPresets() async {
    for (final game in UnityGame.values) {
      _presets[game] = await _calibrationStore.readPreset(game);
    }
  }

  void _onSensorUpdate() {
    if (_activeGame == null) return;
    notifyListeners();
  }

  void _sendSessionStart() {
    final game = _activeGame;
    final controller = _unityController;
    if (game == null || controller == null) return;
    final message = <String, dynamic>{
      'event': 'session_start',
      'game': game.id,
      'scene': game.unityScene,
      'route': game.unityRoute,
      'bridgeVersion': _bridgeVersion,
    };

    try {
      controller.postMessage(
        'SensorInputAdapter',
        'OnSessionStart',
        jsonEncode(message),
      );
    } catch (error) {
      _setStatus('Failed to send session start: $error', isError: true);
    }
  }

  void _sendSensorFrame() {
    final game = _activeGame;
    final controller = _unityController;
    if (game == null || controller == null) return;

    final payload = _buildPayload(game);
    try {
      controller.postMessage(
        'SensorInputAdapter',
        'OnSensorPayload',
        jsonEncode(payload.toJson()),
      );
    } catch (error) {
      _setStatus('Failed to send sensor frame: $error', isError: true);
    }
  }

  UnitySensorPayload _buildPayload(UnityGame game) {
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    final preset = _presets[game] ?? const GameCalibrationPreset();
    final raw = (currentSensorPercent / 100).clamp(0.0, 1.0);
    final normalized = _normalize(raw: raw, preset: preset);
    final axis = _centerAxis(normalized: normalized, preset: preset);

    final channels = <String, double>{
      'raw': raw,
      'normalized': normalized,
      'axis': axis,
      'grip': normalized,
      'flexion': normalized,
      'extension': normalized,
      'rotation': normalized,
    };

    final actions = _buildActions(
      game: game,
      nowMs: nowMs,
      normalized: normalized,
      axis: axis,
      preset: preset,
    );

    return UnitySensorPayload(
      bridgeVersion: _bridgeVersion,
      game: game,
      timestampMs: nowMs,
      channels: channels,
      actions: actions,
      calibration: preset.toJson(),
    );
  }

  Map<String, dynamic> _buildActions({
    required UnityGame game,
    required int nowMs,
    required double normalized,
    required double axis,
    required GameCalibrationPreset preset,
  }) {
    final actions = <String, dynamic>{
      'connected': isSensorConnected,
      'unityReady': _unityReady,
      'sensorPercent': currentSensorPercent,
    };

    switch (game) {
      case UnityGame.pizza:
        final canTrigger = normalized >= preset.triggerThreshold &&
            _canTrigger('pizza', nowMs, preset.triggerCooldownMs);
        String lane = '';
        if (canTrigger) {
          lane = _nextPizzaLane();
        }
        actions['tap'] = canTrigger;
        actions['lane'] = lane;
        actions['index'] = canTrigger && lane == 'index';
        actions['middle'] = canTrigger && lane == 'middle';
        actions['ring'] = canTrigger && lane == 'ring';
        actions['pinky'] = canTrigger && lane == 'pinky';
        break;
      case UnityGame.fishing:
        actions['verticalAxis'] = axis;
        actions['reelUp'] = axis > 0.2;
        actions['reelDown'] = axis < -0.2;
        break;
      case UnityGame.jumping:
        actions['horizontalAxis'] = axis;
        actions['moveLeft'] = axis < -0.2;
        actions['moveRight'] = axis > 0.2;
        break;
    }

    return actions;
  }

  bool _canTrigger(String key, int nowMs, int cooldownMs) {
    final untilMs = _cooldownsUntilMs[key] ?? 0;
    if (nowMs < untilMs) return false;
    _cooldownsUntilMs[key] = nowMs + cooldownMs;
    return true;
  }

  String _nextPizzaLane() {
    const lanes = <String>['index', 'middle', 'ring', 'pinky'];
    final lane = lanes[_pizzaLaneIndex % lanes.length];
    _pizzaLaneIndex++;
    return lane;
  }

  double _normalize({
    required double raw,
    required GameCalibrationPreset preset,
  }) {
    final minValue = math.min(preset.min, preset.max);
    final maxValue = math.max(preset.min, preset.max);
    final range = maxValue - minValue;
    if (range <= 0.0001) return raw;
    final normalized = (raw - minValue) / range;
    return normalized.clamp(0.0, 1.0);
  }

  double _centerAxis({
    required double normalized,
    required GameCalibrationPreset preset,
  }) {
    final centered = ((normalized - preset.center) * 2.0) * preset.sensitivity;
    if (centered.abs() < preset.deadZone) return 0.0;
    return centered.clamp(-1.0, 1.0);
  }

  Map<String, dynamic> _parseUnityMessage(dynamic message) {
    if (message is Map<String, dynamic>) {
      return message;
    }

    if (message is Map) {
      return message.map((key, value) => MapEntry(key.toString(), value));
    }

    if (message is String) {
      try {
        final decoded = jsonDecode(message);
        if (decoded is Map<String, dynamic>) return decoded;
        if (decoded is Map) {
          return decoded.map((key, value) => MapEntry(key.toString(), value));
        }
      } catch (_) {}
    }

    return <String, dynamic>{'event': message.toString()};
  }

  void _setStatus(String message, {bool isError = false}) {
    _status = isError ? 'Error: $message' : message;
    notifyListeners();
  }
}
