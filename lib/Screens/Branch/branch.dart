import 'package:flutter/material.dart';
import '../Shared/styles.dart' as styles;
import '../../Queries/branch_query.dart' as branch_query;
import 'Dialogs/delete_dialog.dart';
import 'Dialogs/add_dialog.dart';
import 'Dialogs/edit_dialog.dart';

//-----------------------------------INDIVIDUAL ENTITY------------------------------------

class BranchCard extends StatelessWidget {
  final branch_query.BranchEntity item;
  final void Function(branch_query.BranchEntity entity) onDelete;
  final void Function(branch_query.BranchEntity entity) onEdit;

  const BranchCard({super.key, required this.item, required this.onDelete, required this.onEdit});

  void _handlePopup(int action, BuildContext context) async {
    switch (action){
      case 0: { //Edit
        onEdit(item);
      }
      case 1: { //Delete
        onDelete(item);
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
                padding: const EdgeInsets.fromLTRB(8.0,0,0,0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Id: ${item.branchId}', style: styles.hStyle),
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
            Container(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 8.0),
              child: Text('Name: ${item.name}', style: styles.tStyle)
            ),
          ],
        )
    );
  }
}

//---------------------------------LIST OF ENTITIES-----------------------------------

class Branch extends StatefulWidget {
  const Branch({super.key});

  @override
  State<Branch> createState() => _BranchState();
}

class _BranchState extends State<Branch> {
  late Future<List<branch_query.BranchEntity>> _branches; //list of headers

  @override
  void initState(){
    super.initState();
    _branches = branch_query.getAll();
  }
  
  void _handleElementDelete(branch_query.BranchEntity entity) async{
    bool shouldDelete = await showDeleteDialog(context);

    if (shouldDelete) {
      await branch_query.delete(entity.branchId);

      setState(() {
        _branches = branch_query.getAll();
      });
    }
  }
  
  void _handleElementEdit(branch_query.BranchEntity entity) async {
    var result = await showEditDialog(
        context,
        fields: branch_query.BranchFields.fromEntity(entity)
    );

    if(result.accept){
      await branch_query.update(entity.branchId, result.fields!);

      setState(() {
        _branches = branch_query.getAll();
      });
    }
  }
  
  void _handleElementAdd() async {
    var result = await showAddDialog(context);

    if(result.accept){
      await branch_query.create(result.fields!);

      setState(() {
        _branches = branch_query.getAll();
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<branch_query.BranchEntity>>(
        future: _branches,
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
                            child: BranchCard(
                                item: x,
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
