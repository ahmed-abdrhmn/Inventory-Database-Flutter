import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Item{
  int id;
  String name;

  Item({required this.id, required this.name});

  factory Item.fromJson(Map<String, dynamic> json){
    return switch (json) {
      {
        'itemId': int id,
        'name': String name
      } => Item(
        id: id,
        name: name
      ),
      _ => throw const FormatException('This aint an item!')
    };
  }
}

void main() {
  runApp(const MaterialApp(
    title: 'Ahmed\'s title',
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatefulWidget {
  static const TextStyle tStyle = TextStyle(fontSize: 30);
  static const TextStyle hStyle = TextStyle(fontSize: 30, color: Colors.white);

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Item> data = [Item(id: 15, name: 'loading...')];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ahmed Abdelrahman'),
        centerTitle: true,
        backgroundColor: Colors.red[600],
      ),
      body: ListView(
        children: data.map(
                (x) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Card(
                    clipBehavior: Clip.antiAlias, //makes the top surface smooth
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                            color: Colors.blueAccent,
                            child: Text('Id: ${x.id}', style: HomeScreen.hStyle)
                        ),
                        Text('Name: ${x.name}', style: HomeScreen.tStyle),
                      ],
                    )
                  ),
                )
        ).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        backgroundColor: Colors.red[800],
        child: const Text('Click!'),
      ),
    );
  }

  void fetchAndUpdate() async {
    try {
      var resp = await http.get(
          Uri.parse('http://192.168.100.19:5230/api/item'));

      List<Item> list = (jsonDecode(resp.body) as List).map((x) => Item.fromJson(x)).toList();
      //List<Item> list = [Item(id: 1, name:'Banana'), Item(id: 2, name: 'BlueBerry'), Item(id: 3, name: 'Orange')];
      setState(() {
        data = list + list + list + list; //artificially make the list long
      });
    }catch(e){
      setState((){
        data = [Item(id:400,name:e.toString())];
      });
    }
  }

  @override
  void initState(){
    super.initState();
    fetchAndUpdate();
  }
}

