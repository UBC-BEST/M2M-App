import 'package:flutter/material.dart';

class GameItem {
  const GameItem({
    required this.name,
    required this.id,
    this.subtitle,
    this.onTap,
  });

  final String id;
  final String name;
  final String? subtitle;
  final VoidCallback? onTap;
}
