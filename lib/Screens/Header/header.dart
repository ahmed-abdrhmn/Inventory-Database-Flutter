import 'package:flutter/material.dart';
import '../Shared/styles.dart' as styles;
import '../Shared/date_format.dart' as date_format;
import '../../Queries/header_query.dart' as header_query;
import '../../Queries/branch_query.dart'as branch_query;
import 'Dialogs/delete_dialog.dart';
import 'Dialogs/add_dialog.dart';
import 'Dialogs/edit_dialog.dart';

//-----------------------------------INDIVIDUAL ENTITY------------------------------------

class HeaderCard extends StatelessWidget {
  final header_query.HeaderEntity header;
  final void Function(header_query.HeaderEntity entity) onDelete;
  final void Function(header_query.HeaderEntity entity) onEdit;

  const HeaderCard({super.key, required this.header, required this.onDelete, required this.onEdit});

  void _handlePopup(int action, BuildContext context) async {
    switch (action){
      case 0: { //Edit
        onEdit(header);
      }
      case 1: { //Delete
        onDelete(header);
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
                        onSelected: (value) => _handlePopup(value, context),
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
  late Future<List<header_query.HeaderEntity>> _headers; //list of headers
  late Future<List<int>> _branchIds; //list of branchIds, used in drop down list for BranchId

  @override
  void initState(){
    super.initState();
    _headers = header_query.getAll();
    _branchIds = branch_query.getAll().then( (x) => x.map((i)=>i.branchId).toList() );
  }
  
  void _handleElementDelete(header_query.HeaderEntity entity) async{
    bool shouldDelete = await showDeleteDialog(context);

    if (shouldDelete) {
      await header_query.delete(entity.inventoryInHeaderId);

      setState(() {
        _headers = header_query.getAll();
      });
    }
  }
  
  void _handleElementEdit(header_query.HeaderEntity entity) async {
    var result = await showEditDialog(
        context,
        branchIds: await _branchIds,
        fields: header_query.HeaderFields.fromEntity(entity)
    );

    if(result.accept){
      await header_query.update(entity.inventoryInHeaderId, result.fields!);

      setState(() {
        _headers = header_query.getAll();
      });
    }
  }
  
  void _handleElementAdd() async {
    var result = await showAddDialog(context, branchIds: await _branchIds);

    if(result.accept){
      await header_query.create(result.fields!);

      setState(() {
        _headers = header_query.getAll();
      });
    }

  }
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<header_query.HeaderEntity>>(
        future: _headers,
        builder: (context, snapshot){
          // First we check if there is some cached version of the data
          // If there isn't, we check if there is an error
          // If there isn't, we assume the data is still loading.
          if (snapshot.hasData) {
            return Stack(
              children: [
                // The actual list of entites
                ListView(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 100.0), //give space below the items so they not blocked by plus button
                  children: snapshot.data!.map(
                          (x) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: HeaderCard(
                                header: x,
                                onDelete: _handleElementDelete,
                                onEdit: _handleElementEdit,
                            ),
                          )
                  ).toList(),
                ),
                // The floating action button. Normally this should be
                // under the scaffold. But I put it here so I can pass
                // different callback functions depending on the page
                Positioned(
                  bottom: 16.0,
                  right: 16.0,
                  child: FloatingActionButton(
                    onPressed: _handleElementAdd,
                    backgroundColor: Colors.blue,
                    child: const Icon(
                        Icons.add,
                    ),
                  )
                )
              ]
            );
          }else if (snapshot.hasError){
            return Center(child: ListView(
              children: [
                Text(snapshot.error.toString(), style: styles.tStyle),
                Text(snapshot.stackTrace.toString(), style: styles.tStyle)
              ],
            ));
          }
          else{
            return const Center(child: CircularProgressIndicator());
          }
        }
    );
  }
}
