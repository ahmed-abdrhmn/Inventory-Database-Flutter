import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    title: 'Ahmed\'s title',
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ahmed Abdelrahman'),
        centerTitle: true,
        backgroundColor: Colors.red[600],
      ),
      body: const Center(
          child: Text('"Beauty is my second name"\n-Me',
            style: TextStyle(
              fontSize: 30,
              fontFamily: 'DancingScript',
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.right,
          )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        backgroundColor: Colors.red[800],
        child: const Text('Click!'),
      ),
    );
  }
}

