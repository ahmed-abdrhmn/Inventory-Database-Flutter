import 'package:flutter/material.dart';

class Document extends StatelessWidget {
  const Document({super.key});
  final tStyle = const TextStyle(
    fontSize: 45
  );

  final length = 20;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: List.generate(length, (x) => Text('Document',style: tStyle))
    );
  }
}
