import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key});
  final tStyle = const TextStyle(
    fontSize: 40
  );

  final length = 20;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: List.generate(length, (x) => Text('Header', style: tStyle))
    );
  }
}
