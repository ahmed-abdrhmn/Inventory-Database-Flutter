import 'Dialogs/delete_dialog.dart';
import 'package:flutter/material.dart';
import '../Shared/styles.dart' as styles;
import '../Shared/date_format.dart' as date_format;
import '../../Queries/header_query.dart' as header_query;
import '../../Queries/branch_query.dart'as branch_query;

//-----------------------------------INDIVIDUAL ENTITY------------------------------------

class HeaderCard extends StatelessWidget {
  final header_query.HeaderEntity header;
  final void Function(int id) onDelete;
  final void Function(int id, header_query.HeaderFields fields) onEdit;
  final void Function(header_query.HeaderFields fields) onAdd;

  const HeaderCard({super.key, required this.header, required this.onDelete, required this.onEdit, required this.onAdd});

  void _handlePopup(header_query.HeaderEntity entity, int action, BuildContext context) async {
    switch (action){
      case 0: { //Edit

      }
      case 1: { //Delete
        bool shouldDelete = await showDeleteDialog(context);

        if(shouldDelete){
          onDelete(entity.inventoryInHeaderId);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        clipBehavior: Clip.antiAlias, //makes the top surface smooth
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
                color: Colors.blueAccent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Id: ${header.inventoryInHeaderId}', style: styles.hStyle),
                    PopupMenuButton<int>(
                        color: Colors.white,
                        position: PopupMenuPosition.under, //make the menu appear below the button
                        onSelected: (value) => _handlePopup(header, value, context),
                        itemBuilder: (context) => [
                          const PopupMenuItem<int>(value: 0, child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Edit'),
                              Icon(Icons.edit)
                            ],
                          )),
                          const PopupMenuItem<int>(value: 1, child: Row(
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
            const Text('Branch: ', style: styles.tStyle),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('BranchId: ${header.branch.branchId}', style: styles.tStyle),
                  Text('Name: ${header.branch.name}', style: styles.tStyle)
                ],
              )
            ),
            Text('DocDate: ${date_format.dateFormat.format(header.docDate)}', style: styles.tStyle),
            Text('Reference: ${header.reference}', style: styles.tStyle),
            Text('TotalValue: ${header.totalValue}', style: styles.tStyle),
            Text('Remarks: ${header.remarks}', style: styles.tStyle)
          ],
        )
    );
  }
}

//---------------------------------LIST OF ENTITIES-----------------------------------

class Header extends StatefulWidget {
  const Header({super.key});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  late Future<List<header_query.HeaderEntity>> _headers;

  @override
  void initState(){
    super.initState();
    _headers = header_query.getAll();
  }
  
  void _handleElementDelete(int id) async{
    await header_query.delete(id);

    setState(() {
      _headers = header_query.getAll();
    });
  }
  
  void _handleElementEdit(int id, header_query.HeaderFields fields) {}
  
  void _handleElementAdd(header_query.HeaderFields fields) {}
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<header_query.HeaderEntity>>(
        future: _headers,
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.done){
              if (!snapshot.hasError) {
                return ListView(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 100.0), //give space below the items so they not blocked by plus button
                  children: snapshot.data!.map(
                          (x) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: HeaderCard(
                                header: x,
                                onDelete: _handleElementDelete,
                                onEdit: _handleElementEdit,
                                onAdd: _handleElementAdd,
                            ),
                          )
                  ).toList(),
                );
              }else{
                return Center(child: ListView(
                  children: [
                    Text(snapshot.error.toString(), style: styles.tStyle),
                    Text(snapshot.stackTrace.toString(), style: styles.tStyle)
                  ],
                ));
              }
          }
          else{
            return const Center(child: CircularProgressIndicator());
          }
        }
    );
  }
}
