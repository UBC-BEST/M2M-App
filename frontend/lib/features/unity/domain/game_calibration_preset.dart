class GameCalibrationPreset {
  const GameCalibrationPreset({
    this.center = 0.5,
    this.min = 0.0,
    this.max = 1.0,
    this.deadZone = 0.08,
    this.sensitivity = 1.0,
    this.triggerThreshold = 0.7,
    this.triggerCooldownMs = 180,
  });

  factory GameCalibrationPreset.fromJson(Map<String, dynamic> json) {
    return GameCalibrationPreset(
      center: _readDouble(json['center'], fallback: 0.5),
      min: _readDouble(json['min'], fallback: 0.0),
      max: _readDouble(json['max'], fallback: 1.0),
      deadZone: _readDouble(json['deadZone'], fallback: 0.08),
      sensitivity: _readDouble(json['sensitivity'], fallback: 1.0),
      triggerThreshold: _readDouble(json['triggerThreshold'], fallback: 0.7),
      triggerCooldownMs: _readInt(json['triggerCooldownMs'], fallback: 180),
    );
  }

  final double center;
  final double min;
  final double max;
  final double deadZone;
  final double sensitivity;
  final double triggerThreshold;
  final int triggerCooldownMs;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'center': center,
      'min': min,
      'max': max,
      'deadZone': deadZone,
      'sensitivity': sensitivity,
      'triggerThreshold': triggerThreshold,
      'triggerCooldownMs': triggerCooldownMs,
    };
  }

  GameCalibrationPreset copyWith({
    double? center,
    double? min,
    double? max,
    double? deadZone,
    double? sensitivity,
    double? triggerThreshold,
    int? triggerCooldownMs,
  }) {
    return GameCalibrationPreset(
      center: center ?? this.center,
      min: min ?? this.min,
      max: max ?? this.max,
      deadZone: deadZone ?? this.deadZone,
      sensitivity: sensitivity ?? this.sensitivity,
      triggerThreshold: triggerThreshold ?? this.triggerThreshold,
      triggerCooldownMs: triggerCooldownMs ?? this.triggerCooldownMs,
    );
  }

  static double _readDouble(dynamic value, {required double fallback}) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? fallback;
    return fallback;
  }

  static int _readInt(dynamic value, {required int fallback}) {
    if (value is num) return value.round();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }
}
