import 'package:flutter/material.dart';


import 'Screens/Document/document.dart';
import 'Screens/Header/header.dart';
import 'Screens/Branch/branch.dart';
import 'Screens/Item/item.dart';
import 'Screens/Package/package.dart';

import 'Screens/Shared/styles.dart' as styles;

void main() {
  runApp(const MaterialApp(
    title: 'Ahmed\'s title',
    home: Body()
  ));
}


class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

const pages = <Widget>[
  Document(),
  Header(),
  Branch(),
  Item(),
  Package()
];

const pageTitles = <String>[
  'Documents',
  'Headers',
  'Branches',
  'Items',
  'Packages'
];

class _BodyState extends State<Body> {
  int currentPageId = 0;
  List<int> pageHistory = [];
  bool popupShowing = false;

  void _changePage(int nextId){
    setState(() {
      pageHistory.add(currentPageId);
      currentPageId = nextId;
    });
  }

  bool _prevPage(){ //returns if successfully backtracked
    //To allow the back button to close the drawer
    if(popupShowing) return false;

    if (pageHistory.isNotEmpty){
      setState(() {
        currentPageId = pageHistory.last;
        pageHistory.removeLast(); //pop it off from the history
      });
      return true;
    }else{
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitles[currentPageId]), //show the title of the current page
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      onDrawerChanged: (bool isOpen){ //This is used to keep track of the state of the drawer. Not sure if setState is necessary here.
        print('The state of Drawer is $isOpen');
        if (isOpen) {
          setState(() {
            popupShowing = true;
          });
        }else{
          setState(() {
            popupShowing = false;
          });
        }
      },
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.red
                ),
                child: Text('Inventory', style: styles.hStyle,),
            ),
            ListTile(
              title: const Text('Documents'),
              onTap: (){
                _changePage(0);
                Navigator.pop(context);
              },
              selected: currentPageId == 0,
            ),
            ListTile(
              title: const Text('Headers'),
              onTap: (){
                _changePage(1);
                Navigator.pop(context);
              },
              selected: currentPageId == 1,
            ),
            ListTile(
              title: const Text('Branches'),
              onTap: (){
                _changePage(2);
                Navigator.pop(context);
                },
              selected: currentPageId == 2,
            ),
            ListTile(
              title: const Text('Items'),
              onTap: (){
                _changePage(3);
                Navigator.pop(context);
              },
              selected: currentPageId == 3,
            ),
            ListTile(
              title: const Text('Packages'),
              onTap: (){
                _changePage(4);
                Navigator.pop(context);
              },
              selected: currentPageId == 4
            )
          ],
        )
      ),
      body: WillPopScope(
          child: pages[currentPageId],
          onWillPop: () async {
              bool reversed = _prevPage();
              return !reversed;
            },
      )
    );
  }
}
