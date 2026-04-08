class ButtonCalibrationProfile {
  const ButtonCalibrationProfile({
    required this.idleRaw,
    required this.releaseTolerance,
    required this.matchTolerance,
    required this.buttonRawValues,
  });

  static const ButtonCalibrationProfile m2mDefault = ButtonCalibrationProfile(
    idleRaw: 0,
    releaseTolerance: 55,
    matchTolerance: 95,
    buttonRawValues: <int, int>{
      1: 125,
      2: 300,
      3: 475,
      4: 680,
      5: 850,
      6: 1000,
      7: 1250,
      8: 1515,
      9: 1825,
      10: 2260,
      11: 2890,
      12: 4050,
    },
  );

  static const List<(int button, int min, int max)> m2mButtonRanges = <(
    int,
    int,
    int
  )>[
    (1, 100, 150),
    (2, 290, 310),
    (3, 460, 490),
    (4, 630, 730),
    (5, 820, 880),
    (6, 990, 1010),
    (7, 1200, 1300),
    (8, 1480, 1550),
    (9, 1770, 1880),
    (10, 2220, 2300),
    (11, 2830, 2950),
    (12, 4050, 4095),
  ];

  factory ButtonCalibrationProfile.fromJson(Map<String, dynamic> json) {
    final rawValues = <int, int>{};
    final source = json['buttonRawValues'];
    if (source is Map) {
      for (final entry in source.entries) {
        final key = int.tryParse(entry.key.toString());
        final value = _readInt(entry.value);
        if (key == null || value == null) continue;
        rawValues[key] = value;
      }
    }

    return ButtonCalibrationProfile(
      idleRaw: _readInt(json['idleRaw']) ?? 0,
      releaseTolerance: _readInt(json['releaseTolerance']) ?? 80,
      matchTolerance: _readInt(json['matchTolerance']) ?? 140,
      buttonRawValues: rawValues,
    );
  }

  final int idleRaw;
  final int releaseTolerance;
  final int matchTolerance;
  final Map<int, int> buttonRawValues;

  bool get isComplete {
    for (var button = 1; button <= 12; button++) {
      if (!buttonRawValues.containsKey(button)) return false;
    }
    return true;
  }

  bool get hasDistinctButtons {
    if (!isComplete) return false;
    final values = buttonRawValues.values.toList()..sort();
    var minGap = 1 << 30;
    for (var i = 1; i < values.length; i++) {
      final gap = (values[i] - values[i - 1]).abs();
      if (gap < minGap) minGap = gap;
    }
    return minGap >= 20;
  }

  int? decodeButton(int rawValue) {
    if (buttonRawValues.isEmpty) return null;
    if ((rawValue - idleRaw).abs() <= releaseTolerance) return null;

    int? bestButton;
    var bestDistance = 1 << 30;
    var secondBestDistance = 1 << 30;
    for (final entry in buttonRawValues.entries) {
      final distance = (rawValue - entry.value).abs();
      if (distance < bestDistance) {
        secondBestDistance = bestDistance;
        bestDistance = distance;
        bestButton = entry.key;
      } else if (distance < secondBestDistance) {
        secondBestDistance = distance;
      }
    }

    if (bestButton == null) return null;
    if (bestDistance > matchTolerance) return null;
    final ambiguityMargin = (matchTolerance * 0.2).round().clamp(8, 40);
    if (secondBestDistance - bestDistance <= ambiguityMargin) return null;
    return bestButton;
  }

  static int? decodeM2MRangeButton(int rawValue) {
    for (final entry in m2mButtonRanges) {
      if (rawValue >= entry.$2 && rawValue <= entry.$3) {
        return entry.$1;
      }
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'idleRaw': idleRaw,
      'releaseTolerance': releaseTolerance,
      'matchTolerance': matchTolerance,
      'buttonRawValues': buttonRawValues.map(
        (key, value) => MapEntry(key.toString(), value),
      ),
    };
  }

  ButtonCalibrationProfile copyWith({
    int? idleRaw,
    int? releaseTolerance,
    int? matchTolerance,
    Map<int, int>? buttonRawValues,
  }) {
    return ButtonCalibrationProfile(
      idleRaw: idleRaw ?? this.idleRaw,
      releaseTolerance: releaseTolerance ?? this.releaseTolerance,
      matchTolerance: matchTolerance ?? this.matchTolerance,
      buttonRawValues: buttonRawValues ?? this.buttonRawValues,
    );
  }

  static int? _readInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.round();
    if (value is String) return int.tryParse(value);
    return null;
  }
}
