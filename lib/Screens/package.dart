import 'package:flutter/material.dart';

class Package extends StatelessWidget {
  const Package({super.key});
  final tStyle = const TextStyle(
    fontSize: 40
  );

  final length = 20;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: List.generate(length, (x) => Text('Package', style: tStyle))
    );
  }
}