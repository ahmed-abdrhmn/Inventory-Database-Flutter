import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:date_field/date_field.dart';
import 'package:intl/intl.dart';

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

  void _handleEdit(int id, BuildContext context){

  }

  void _handlePopup(int id, int action, BuildContext context){
    if (action == 1){ //DELETE
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Delete'),
              content: Text('Sure wanna delete item#$id?'),
              actions: [
                ElevatedButton(
                    onPressed: (){
                      Navigator.of(context).pop(); //close the dialog, put return value here
                    },
                    child: Text('No')
                ),
                ElevatedButton(
                    onPressed: (){
                      Navigator.of(context).pop(); //close the dialog, put the return value here
                    },
                    child: Text('Yes')
                ),
              ],
            );
          }
      );
    }
    else if (action == 0) { //EDIT
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Edit'),
              content: Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min, //prevent the popup from occupying the whole vertical space of screen
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                          label: Text('Name')
                      ),
                      initialValue: 'Existing Name'
                    ),
                    DateTimeFormField(
                      decoration: InputDecoration(
                        label: Text('Expiry Date')
                      ),
                      mode: DateTimeFieldPickerMode.date,
                      dateFormat: DateFormat('yyyy-MM-dd'), //date format should match the server (Though from the docs MySQL is pretty fexible but I don't want to depend on that)
                      initialValue: DateTime(2023,12,27),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        label: Text('Quantity')
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    DropdownButtonFormField<int>(
                      items: [
                        DropdownMenuItem(value: 1, child: Text('1')),
                        DropdownMenuItem(value: 2, child: Text('2')),
                        DropdownMenuItem(value: 5, child: Text('5'))
                      ],
                      onChanged: (value){},
                    )
                  ],
                )
              ),
              actions: [
                ElevatedButton(
                    onPressed: (){
                      Navigator.of(context).pop(); //close the dialog, put return value here
                    },
                    child: Text('No')
                ),
                ElevatedButton(
                    onPressed: (){
                      Navigator.of(context).pop(); //close the dialog, put the return value here
                    },
                    child: Text('Yes')
                ),
              ],
            );
          }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ahmed Abdelrahman'),
        centerTitle: true,
        backgroundColor: Colors.red[600],
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 100.0), //give space below the items so they not blocked by plus button
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Id: ${x.id}', style: HomeScreen.hStyle),
                                PopupMenuButton<int>(
                                    color: Colors.white,
                                    position: PopupMenuPosition.under, //make the menu appear below the button
                                    onSelected: (value) => _handlePopup(x.id, value, context),
                                    itemBuilder: (context) => [
                                      PopupMenuItem<int>(value: 0, child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Edit'),
                                          Icon(Icons.edit)
                                        ],
                                      )),
                                      PopupMenuItem<int>(value: 1, child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Delete'),
                                          Icon(Icons.delete),
                                        ],
                                      ))
                                    ]
                                )
                              ],
                            )
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
        backgroundColor: Colors.red[500],
        child: const Icon(Icons.add),
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

