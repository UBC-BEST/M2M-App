import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:m2m/l10n/app_localizations.dart';

/// Rehabilitation calibration sequence aligned with Figma "Calibration screens for app"
/// (M2M Wireframes — welcome, connect sensors, instructions, 4 exercises, results).
class CalibrationFlowPage extends StatefulWidget {
  const CalibrationFlowPage({super.key});

  @override
  State<CalibrationFlowPage> createState() => _CalibrationFlowPageState();
}

class _CalibrationFlowPageState extends State<CalibrationFlowPage> {
  /// 0 welcome, 1 connect, 2 instructions, 3–6 exercises, 7 results
  int _step = 0;

  bool _connecting = false;
  final List<bool> _sensorOk = [false, false, false, false];

  /// 0 intro, 1 countdown, 2 finished (per exercise while on that step)
  int _exerciseSub = 0;
  int _countdown = 3;
  Timer? _countdownTimer;

  int get _exerciseIndex => _step - 3;

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _goTo(int step) {
    setState(() {
      _step = step;
      if (step >= 3 && step <= 6) {
        _exerciseSub = 0;
        _countdown = 3;
      }
    });
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    setState(() {
      _exerciseSub = 1;
      _countdown = 3;
    });
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() {
        if (_countdown <= 1) {
          t.cancel();
          _exerciseSub = 2;
        } else {
          _countdown--;
        }
      });
    });
  }

  Future<void> _onConnectSensors() async {
    setState(() => _connecting = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() {
      _connecting = false;
      for (var i = 0; i < _sensorOk.length; i++) {
        _sensorOk[i] = true;
      }
    });
  }

  void _onExport() {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.calibrationExportComingSoon)),
    );
  }

  Widget _buildStep(
    BuildContext context,
    AppLocalizations l,
    String dateStr,
  ) {
    switch (_step) {
      case 0:
        return _WelcomeBody(
          onStart: () => _goTo(1),
          l: l,
        );
      case 1:
        return _ConnectBody(
          l: l,
          connecting: _connecting,
          sensorsOk: _sensorOk,
          onConnect: _onConnectSensors,
          onNext: () => _goTo(2),
        );
      case 2:
        return _InstructionsBody(
          l: l,
          onStart: () => _goTo(3),
        );
      case 3:
      case 4:
      case 5:
      case 6:
        return _ExerciseBody(
          l: l,
          exerciseIndex: _exerciseIndex,
          sub: _exerciseSub,
          countdown: _countdown,
          onBegin: _startCountdown,
          onContinue: () {
            if (_step < 6) {
              _goTo(_step + 1);
            } else {
              _goTo(7);
            }
          },
        );
      default:
        return _ResultsBody(
          l: l,
          sessionDate: dateStr,
          onExport: _onExport,
          onHome: () => Navigator.of(context).pop(),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final dateStr = DateFormat.yMd().format(DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xFFEFF6FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEFF6FF),
        elevation: 0,
        foregroundColor: const Color(0xFF1E2939),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFEFF6FF),
              Color(0xFFF0F7FF),
              Color(0xFFF0F9FF),
            ],
            stops: [0, 0.5, 1],
          ),
        ),
        child: SafeArea(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: KeyedSubtree(
              key: ValueKey(_step),
              child: _buildStep(
                context,
                l,
                dateStr,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ——— Welcome ———

class _WelcomeBody extends StatelessWidget {
  const _WelcomeBody({
    required this.onStart,
    required this.l,
  });

  final VoidCallback onStart;
  final AppLocalizations l;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          const SizedBox(height: 8),
          const _HeaderIcon(icon: Icons.front_hand_outlined),
          const SizedBox(height: 16),
          Text(
            l.calibrationRehabTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              height: 36 / 30,
              color: Color(0xFF1E2939),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l.calibrationTherapyGamepadSubtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              height: 28 / 18,
              color: Color(0xFF4A5565),
            ),
          ),
          const SizedBox(height: 24),
          _WhiteCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.calibrationBeforeWeBegin,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0A0A0A),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l.calibrationBeforeWeBeginBody,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 24 / 16,
                    color: Color(0xFF5B7A9E),
                  ),
                ),
                const SizedBox(height: 20),
                _BulletRow(
                  icon: Icons.speed_outlined,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFDFF2FE), Color(0xFFDBEAFE)],
                  ),
                  title: l.calibrationDailyBaseline,
                  body: l.calibrationDailyBaselineBody,
                ),
                const SizedBox(height: 12),
                _BulletRow(
                  icon: Icons.show_chart,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFCEFAFE), Color(0xFFDFF2FE)],
                  ),
                  title: l.calibrationFourQuickTests,
                  body: l.calibrationFourQuickTestsBody,
                ),
                const SizedBox(height: 12),
                _BulletRow(
                  icon: Icons.pan_tool_alt_outlined,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFDBEAFE), Color(0xFFE0E7FF)],
                  ),
                  title: l.calibrationAtYourPace,
                  body: l.calibrationAtYourPaceBody,
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFBEDBFF)),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFEFF6FF), Color(0xFFF0F9FF)],
                    ),
                  ),
                  child: Text(
                    l.calibrationImportantCallout,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 20 / 14,
                      color: Color(0xFF1C398E),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _PrimaryButton(label: l.calibrationStartCalibration, onPressed: onStart),
        ],
      ),
    );
  }
}

// ——— Connect ———

class _ConnectBody extends StatelessWidget {
  const _ConnectBody({
    required this.l,
    required this.connecting,
    required this.sensorsOk,
    required this.onConnect,
    required this.onNext,
  });

  final AppLocalizations l;
  final bool connecting;
  final List<bool> sensorsOk;
  final Future<void> Function() onConnect;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final allOk = sensorsOk.every((e) => e);
    final names = [
      l.calibrationSensorGrip,
      l.calibrationSensorFlexion,
      l.calibrationSensorExtension,
      l.calibrationSensorRotation,
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          const _HeaderIcon(icon: Icons.bluetooth),
          const SizedBox(height: 16),
          Text(
            l.calibrationConnectGamepad,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E2939),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l.calibrationConnectGamepadHint,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, color: Color(0xFF4A5565)),
          ),
          const SizedBox(height: 24),
          _WhiteCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.calibrationSensorStatus,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0A0A0A),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l.calibrationSensorStatusHint,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 24 / 16,
                    color: Color(0xFF5B7A9E),
                  ),
                ),
                const SizedBox(height: 16),
                for (var i = 0; i < names.length; i++) ...[
                  if (i > 0) const SizedBox(height: 12),
                  _SensorRow(
                    label: names[i],
                    connected: sensorsOk[i],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
          _PrimaryButton(
            label: connecting ? l.calibrationConnectingSensors : l.calibrationConnectSensors,
            icon: Icons.bluetooth,
            onPressed: connecting
                ? null
                : () async {
                    await onConnect();
                  },
          ),
          if (allOk) ...[
            const SizedBox(height: 12),
            _PrimaryButton(
              label: l.nextButtonLabel,
              onPressed: onNext,
            ),
          ],
        ],
      ),
    );
  }
}

class _SensorRow extends StatelessWidget {
  const _SensorRow({
    required this.label,
    required this.connected,
  });

  final String label;
  final bool connected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDBEAFE)),
        gradient: const LinearGradient(
          colors: [Color(0xFFEFF6FF), Color(0xFFF0F9FF)],
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: connected ? const Color(0xFF00C950) : const Color(0xFFD1D5DC),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1A000000),
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1E2939),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ——— Instructions ———

class _InstructionsBody extends StatelessWidget {
  const _InstructionsBody({
    required this.l,
    required this.onStart,
  });

  final AppLocalizations l;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final items = [
      (l.calibrationListGripTitle, l.calibrationListGripBody, Icons.back_hand_outlined),
      (l.calibrationListFlexionTitle, l.calibrationListFlexionBody, Icons.swap_vert),
      (l.calibrationListExtensionTitle, l.calibrationListExtensionBody, Icons.swap_vert),
      (l.calibrationListRotationTitle, l.calibrationListRotationBody, Icons.rotate_right),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          Text(
            l.calibrationExercisesHeading,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E2939),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l.calibrationExercisesSubheading,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, color: Color(0xFF4A5565)),
          ),
          const SizedBox(height: 24),
          _WhiteCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.calibrationWhatToExpect,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0A0A0A),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l.calibrationWhatToExpectHint,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF5B7A9E),
                  ),
                ),
                const SizedBox(height: 16),
                for (var i = 0; i < items.length; i++) ...[
                  if (i > 0) const SizedBox(height: 12),
                  _InstructionRow(
                    icon: items[i].$3,
                    title: items[i].$1,
                    body: items[i].$2,
                    gradientIndex: i,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFBEDBFF)),
              gradient: const LinearGradient(
                colors: [Color(0xFFEFF6FF), Color(0xFFF0F9FF)],
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x80DBEAFE),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.calibrationRememberHeading,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E2939),
                  ),
                ),
                const SizedBox(height: 8),
                _RememberLine(l.calibrationRemember1),
                _RememberLine(l.calibrationRemember2),
                _RememberLine(l.calibrationRemember3),
                _RememberLine(l.calibrationRemember4),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _PrimaryButton(
            label: l.calibrationStartFirstExercise,
            icon: Icons.arrow_forward,
            onPressed: onStart,
          ),
        ],
      ),
    );
  }
}

class _InstructionRow extends StatelessWidget {
  const _InstructionRow({
    required this.icon,
    required this.title,
    required this.body,
    required this.gradientIndex,
  });

  final IconData icon;
  final String title;
  final String body;
  final int gradientIndex;

  static const _gradients = [
    LinearGradient(colors: [Color(0xFFDFF2FE), Color(0xFFB8E6FE)]),
    LinearGradient(colors: [Color(0xFFCEFAFE), Color(0xFFA2F4FD)]),
    LinearGradient(colors: [Color(0xFFDBEAFE), Color(0xFFBEDBFF)]),
    LinearGradient(colors: [Color(0xFFE0E7FF), Color(0xFFC6D2FF)]),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: _gradients[gradientIndex % _gradients.length],
            boxShadow: const [
              BoxShadow(color: Color(0x1A000000), blurRadius: 2, offset: Offset(0, 1)),
            ],
          ),
          child: Icon(icon, size: 24, color: const Color(0xFF1E2939)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1E2939),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                body,
                style: const TextStyle(
                  fontSize: 14,
                  height: 20 / 14,
                  color: Color(0xFF4A5565),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RememberLine extends StatelessWidget {
  const _RememberLine(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 18, color: Color(0xFF155DFC))),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                height: 20 / 14,
                color: Color(0xFF364153),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ——— Exercise ———

class _ExerciseBody extends StatelessWidget {
  const _ExerciseBody({
    required this.l,
    required this.exerciseIndex,
    required this.sub,
    required this.countdown,
    required this.onBegin,
    required this.onContinue,
  });

  final AppLocalizations l;
  final int exerciseIndex;
  final int sub;
  final int countdown;
  final VoidCallback onBegin;
  final VoidCallback onContinue;

  String _title() {
    switch (exerciseIndex) {
      case 0:
        return l.calibrationExerciseGripTitle;
      case 1:
        return l.calibrationExerciseFlexionTitle;
      case 2:
        return l.calibrationExerciseExtensionTitle;
      default:
        return l.calibrationExerciseRotationTitle;
    }
  }

  String _instruction() {
    switch (exerciseIndex) {
      case 0:
        return l.calibrationExerciseGripInstruction;
      case 1:
        return l.calibrationExerciseFlexionInstruction;
      case 2:
        return l.calibrationExerciseExtensionInstruction;
      default:
        return l.calibrationExerciseRotationInstruction;
    }
  }

  String _tip() {
    switch (exerciseIndex) {
      case 0:
        return l.calibrationExerciseGripTip;
      case 1:
        return l.calibrationExerciseFlexionTip;
      case 2:
        return l.calibrationExerciseExtensionTip;
      default:
        return l.calibrationExerciseRotationTip;
    }
  }

  @override
  Widget build(BuildContext context) {
    const total = 4;
    final current = exerciseIndex + 1;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        children: [
          _ProgressSegments(activeIndex: exerciseIndex, total: total),
          const SizedBox(height: 24),
          Text(
            _title(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E2939),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l.calibrationExerciseOf(current, total),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Color(0xFF4A5565)),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0x264A90E2)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33DBEAFE),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                if (sub == 0) ...[
                  Text(
                    _instruction(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      height: 28 / 18,
                      color: Color(0xFF364153),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFBEDBFF)),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFEFF6FF), Color(0xFFF0F9FF)],
                      ),
                    ),
                    child: Text(
                      _tip(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1C398E),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _PrimaryButton(
                    label: l.calibrationBeginExercise,
                    onPressed: onBegin,
                  ),
                ] else if (sub == 1) ...[
                  Text(
                    l.calibrationCountdownPreparing,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E2939),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '$countdown',
                    style: const TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF155DFC),
                    ),
                  ),
                ] else ...[
                  const Icon(Icons.check_circle, color: Color(0xFF00C950), size: 56),
                  const SizedBox(height: 12),
                  Text(
                    l.calibrationExerciseComplete,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E2939),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _PrimaryButton(
                    label: l.calibrationContinue,
                    onPressed: onContinue,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressSegments extends StatelessWidget {
  const _ProgressSegments({
    required this.activeIndex,
    required this.total,
  });

  final int activeIndex;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (i) {
        final filled = i <= activeIndex;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i < total - 1 ? 8 : 0),
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: filled ? null : const Color(0xFFE5E7EB),
                gradient: filled
                    ? const LinearGradient(
                        colors: [Color(0xFF00A6F4), Color(0xFF155DFC)],
                      )
                    : null,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ——— Results ———

class _ResultsBody extends StatelessWidget {
  const _ResultsBody({
    required this.l,
    required this.sessionDate,
    required this.onExport,
    required this.onHome,
  });

  final AppLocalizations l;
  final String sessionDate;
  final VoidCallback onExport;
  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) {
    const exercises = 4;
    const dataPoints = 48;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF00D492), Color(0xFF00C950)],
              ),
              boxShadow: [
                BoxShadow(color: Color(0x80B9F8CF), blurRadius: 12, offset: Offset(0, 4)),
              ],
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 48),
          ),
          const SizedBox(height: 16),
          Text(
            l.calibrationCompleteTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E2939),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l.calibrationCompleteSubtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, color: Color(0xFF4A5565)),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFA4F4CF)),
              gradient: const LinearGradient(
                colors: [Color(0xFFECFDF5), Color(0xFFF0FDF4)],
              ),
              boxShadow: const [
                BoxShadow(color: Color(0x80DCFCE7), blurRadius: 12, offset: Offset(0, 4)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.show_chart, color: Color(0xFF00A63E), size: 20),
                    const SizedBox(width: 8),
                    Text(
                      l.calibrationSummaryTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1E2939),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  l.calibrationSessionCompletedOn(sessionDate),
                  style: const TextStyle(fontSize: 16, color: Color(0xFF5B7A9E)),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _MiniStat(
                        value: '$exercises',
                        label: l.calibrationSummaryExercises,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _MiniStat(
                        value: '$dataPoints',
                        label: l.calibrationSummaryDataPoints,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              l.calibrationExerciseResults,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E2939),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _ResultTile(title: l.calibrationExerciseGripTitle),
          _ResultTile(title: l.calibrationExerciseFlexionTitle),
          _ResultTile(title: l.calibrationExerciseExtensionTitle),
          _ResultTile(title: l.calibrationExerciseRotationTitle),
          const SizedBox(height: 20),
          _WhiteCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.calibrationNextSteps,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1E2939),
                  ),
                ),
                const SizedBox(height: 12),
                _CheckLine(l.calibrationNextStep1),
                _CheckLine(l.calibrationNextStep2),
                _CheckLine(l.calibrationNextStep3),
                _CheckLine(l.calibrationNextStep4),
              ],
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              side: const BorderSide(color: Color(0xFFBEDBFF)),
              backgroundColor: const Color(0xFFF0F7FF),
              foregroundColor: const Color(0xFF0A0A0A),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: onExport,
            icon: const Icon(Icons.download_outlined, size: 18),
            label: Text(l.calibrationExportData),
          ),
          const SizedBox(height: 12),
          _PrimaryButton(
            label: l.calibrationReturnHome,
            icon: Icons.home_outlined,
            onPressed: onHome,
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFB9F8CF)),
        boxShadow: const [
          BoxShadow(color: Color(0x1A000000), blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E2939),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Color(0xFF4A5565)),
          ),
        ],
      ),
    );
  }
}

class _ResultTile extends StatelessWidget {
  const _ResultTile({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFDBEAFE)),
          boxShadow: const [
            BoxShadow(color: Color(0x80DBEAFE), blurRadius: 10, offset: Offset(0, 4)),
          ],
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1E2939),
          ),
        ),
      ),
    );
  }
}

class _CheckLine extends StatelessWidget {
  const _CheckLine(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('✓', style: TextStyle(fontSize: 18, color: Color(0xFF00A63E))),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                height: 20 / 14,
                color: Color(0xFF364153),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ——— Shared ———

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 96,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFF00BCFF), Color(0xFF2B7FFF)],
        ),
        boxShadow: [
          BoxShadow(color: Color(0x80BEDBFF), blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: 48),
    );
  }
}

class _WhiteCard extends StatelessWidget {
  const _WhiteCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFDBEAFE)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x80DBEAFE),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _BulletRow extends StatelessWidget {
  const _BulletRow({
    required this.icon,
    required this.gradient,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final Gradient gradient;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: gradient,
            boxShadow: const [
              BoxShadow(color: Color(0x1A000000), blurRadius: 2, offset: Offset(0, 1)),
            ],
          ),
          child: Icon(icon, size: 24, color: const Color(0xFF1E2939)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1E2939),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                body,
                style: const TextStyle(
                  fontSize: 14,
                  height: 20 / 14,
                  color: Color(0xFF4A5565),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onPressed == null ? 0.6 : 1,
      child: Material(
        borderRadius: BorderRadius.circular(16),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onPressed,
          child: Ink(
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: onPressed == null
                  ? const LinearGradient(colors: [Color(0xFF9CA3AF), Color(0xFF6B7280)])
                  : const LinearGradient(
                      colors: [Color(0xFF00A6F4), Color(0xFF155DFC)],
                    ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x80BEDBFF),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
