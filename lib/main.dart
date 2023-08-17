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
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        color: Colors.lightGreen,
        margin: const EdgeInsets.all(10.0),
        // child: Icon(
        //   Icons.warning
        // )
        // child: ElevatedButton.icon(
        //     onPressed: (){
        //       print('You have been FREEZED!!!\n');
        //     },
        //     icon: const Icon(Icons.ac_unit_rounded),
        //     label: const Text('FREEZE!'),
        //     style: ButtonStyle(
        //       backgroundColor: MaterialStateProperty.all(Colors.amber[600])
        //     ),
        child: IconButton(
          onPressed: (){
            print('You Pressed this Icon!');
          },
          icon: const Icon(Icons.gamepad)
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

