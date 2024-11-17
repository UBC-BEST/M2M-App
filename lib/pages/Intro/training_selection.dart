import 'package:flutter/material.dart';
import '../Home/Landing.dart';

class TrainingSelectionPage extends StatefulWidget {
  const TrainingSelectionPage({super.key});

  @override
  State<TrainingSelectionPage> createState() => _TrainingSelectionPageState();
}

class _TrainingSelectionPageState extends State<TrainingSelectionPage> {
  final List<int> selectedBoxes = [];
  final List<String> boxLabel = [
    'Cardio',
    'Strength Training',
    'Flexibility',
    'Balance',
    'Endurance',
    'Movement Accuracy',
  ];

  // Temporarily making the background of each box into colours. Will change this once UX/UI photos/icons are finalized
  // List to store generated pastel colors for each box
  late List<Color> _boxColors;

  @override
  void initState() {
    super.initState();
    // Generate a list of unique pastel colors for each box at initialization
    _boxColors = List<Color>.generate(
      boxLabel.length,
      (index) {
        // Cycle through Colors.primaries to ensure unique colors
        return _getPastelColor(
            Colors.primaries[index % Colors.primaries.length]);
      },
    );
  }

  // Method to generate a pastel color by blending with white
  Color _getPastelColor(Color color) {
    return Color.lerp(color, Colors.white, 0.5)!;
  }

  // Method to generate a brighter color by blending with white
  Color _getBrighterColor(Color color) {
    return Color.lerp(
        color, Colors.white, 0.3)!; // Blend slightly with white to brighten
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Training Selection'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'What would you like to train?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 20),

            // Grid of 6 Selectable Boxes
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two columns
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemCount: boxLabel.length,
                itemBuilder: (context, index) {
                  final bool isSelected = selectedBoxes.contains(index);
                  final Color boxColor = isSelected
                      ? _getBrighterColor(_boxColors[index])
                      : _boxColors[index];

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedBoxes.remove(index);
                        } else {
                          selectedBoxes.add(index);
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: boxColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected ? Colors.grey : boxColor,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          boxLabel[index],
                          textAlign:
                              TextAlign.center, // Center text horizontally
                          style: TextStyle(
                            color: isSelected ? Colors.black : Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Submit Button

            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue.shade600,
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: selectedBoxes.isNotEmpty
                  ? () {
                      //Prints all of the chosen exercises to console. We can utilize this later on if needed
                      for (var index in selectedBoxes) {
                        print('Selected: ${boxLabel[index]}');
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Navigation(),
                        ),
                      );
                    }
                  : null,
              child: const Text("Let's start"),
            ),
            const SizedBox(height: 30)
          ],
        ),
      ),
    );
  }
}
