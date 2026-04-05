import 'unity_game.dart';

class UnitySensorPayload {
  const UnitySensorPayload({
    required this.bridgeVersion,
    required this.game,
    required this.timestampMs,
    required this.channels,
    required this.actions,
    required this.calibration,
  });

  final int bridgeVersion;
  final UnityGame game;
  final int timestampMs;
  final Map<String, double> channels;
  final Map<String, dynamic> actions;
  final Map<String, dynamic> calibration;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'bridgeVersion': bridgeVersion,
      'game': game.id,
      'ts': timestampMs,
      'channels': channels,
      'actions': actions,
      'calib': calibration,
    };
  }
}
