import 'package:flutter/material.dart';
import 'package:m2m/l10n/app_localizations.dart';
import 'package:m2m/features/navigation/presentation/navigation_shell.dart';

class TrainingSelectionPage extends StatefulWidget {
  const TrainingSelectionPage({super.key});

  @override
  State<TrainingSelectionPage> createState() => _TrainingSelectionPageState();
}

class _TrainingSelectionPageState extends State<TrainingSelectionPage> {
  final List<int> _selectedIndexes = [];
  late List<Color> _boxColors;

  @override
  void initState() {
    super.initState();
    _boxColors = const [];
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final trainingOptions = _trainingOptions(localizations);

    if (_boxColors.isEmpty) {
      _boxColors = List<Color>.generate(
        trainingOptions.length,
        (index) => _pastelColor(Colors.primaries[index % Colors.primaries.length]),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.trainingSelectionTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              localizations.trainingSelectionQuestion,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemCount: trainingOptions.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedIndexes.contains(index);
                  final color = isSelected
                      ? _brighterColor(_boxColors[index])
                      : _boxColors[index];

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedIndexes.remove(index);
                        } else {
                          _selectedIndexes.add(index);
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected ? Colors.grey : color,
                          width: 2,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        trainingOptions[index],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                },
              ),
            ),
            FilledButton(
              onPressed: _selectedIndexes.isNotEmpty
                  ? () {
                      for (final index in _selectedIndexes) {
                        debugPrint('Selected: ${trainingOptions[index]}');
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NavigationShell(),
                        ),
                      );
                    }
                  : null,
              child: Text(localizations.startButtonLabel),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  List<String> _trainingOptions(AppLocalizations localizations) {
    return [
      localizations.trainingCardio,
      localizations.trainingStrength,
      localizations.trainingFlexibility,
      localizations.trainingBalance,
      localizations.trainingEndurance,
      localizations.trainingMovementAccuracy,
    ];
  }

  Color _pastelColor(Color color) => Color.lerp(color, Colors.white, 0.5)!;

  Color _brighterColor(Color color) => Color.lerp(color, Colors.white, 0.3)!;
}
