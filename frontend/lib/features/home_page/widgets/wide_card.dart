import 'package:flutter/material.dart';

class WideCard extends StatelessWidget {
  final Color color;
  final Color textColor;
  final String title;
  final String subtitle;

  const WideCard({
    required this.color,
    required this.textColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Increased height for no overflow
      height: 96,
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Texts
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: textColor)),
              const SizedBox(height: 4),
              Text(subtitle,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: textColor.withOpacity(0.7))),
            ],
          ),
          // Play Button
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.white,
            child: Icon(Icons.play_arrow,
                color: color == Colors.white ? Colors.black : color, size: 32),
          ),
        ],
      ),
    );
  }
}
