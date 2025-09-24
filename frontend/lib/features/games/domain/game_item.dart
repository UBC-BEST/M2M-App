import 'package:flutter/material.dart';

class GameItem {
  const GameItem({
    required this.name,
    this.onTap,
  });

  final String name;
  final VoidCallback? onTap;
}
