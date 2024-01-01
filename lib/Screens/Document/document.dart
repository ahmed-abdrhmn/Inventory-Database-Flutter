import 'package:flutter/material.dart';
import '../Shared/styles.dart' as styles;
import '../Shared/date_format.dart' as date_format;
import '../../Queries/header_query.dart' as header_query;
import '../../Queries/item_query.dart'as item_query;
import '../../Queries/package_query.dart' as package_query;
import '../../Queries/inventory_query.dart' as inventory_query;
import 'Dialogs/delete_dialog.dart';
import 'Dialogs/add_dialog.dart';
import 'Dialogs/edit_dialog.dart';

//-----------------------------------INDIVIDUAL ENTITY------------------------------------

class DocumentCard extends StatelessWidget {
  final inventory_query.InventoryEntity document;
  final void Function(inventory_query.InventoryEntity entity) onDelete;
  final void Function(inventory_query.InventoryEntity entity) onEdit;

  const DocumentCard({super.key, required this.document, required this.onDelete, required this.onEdit});

  void _handlePopup(int action, BuildContext context) async {
    switch (action){
      case 0: { //Edit
        onEdit(document);
      }
      case 1: { //Delete
        onDelete(document);
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
                    Text('Id: ${document.inventoryInDetailId}', style: styles.hStyle),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Header: ', style: styles.tStyle),
                  Container(
                      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('HeaderId: ${document.inventoryInHeader.inventoryInHeaderId}', style: styles.tStyle),
                          const Text('Branch: ', style: styles.tStyle),
                          Container(
                              padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('BranchId: ${document.inventoryInHeader.branch.branchId}', style: styles.tStyle),
                                  Text('Name: ${document.inventoryInHeader.branch.name}', style: styles.tStyle)
                                ],
                              )
                          ),
                          Text('DocDate: ${date_format.dateFormat.format(document.inventoryInHeader.docDate)}', style: styles.tStyle),
                          Text('Reference: ${document.inventoryInHeader.reference}', style: styles.tStyle),
                          Text('TotalValue: ${document.inventoryInHeader.totalValue}', style: styles.tStyle),
                          Text('Remarks: ${document.inventoryInHeader.remarks}', style: styles.tStyle),
                        ],
                      )
                  ),
                  Text('Serial: ${document.serial}', style: styles.tStyle),
                  const Text('Item: ', style: styles.tStyle),
                  Container(
                      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ItemId: ${document.item.itemId}', style: styles.tStyle),
                          Text('Name: ${document.item.name}', style: styles.tStyle)
                        ],
                      )
                  ),
                  const Text('Package: ', style: styles.tStyle),
                  Container(
                      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('PackageId: ${document.package.packageId}', style: styles.tStyle),
                          Text('Name: ${document.package.name}', style: styles.tStyle)
                        ],
                      )
                  ),
                  Text('BatchNumber: ${document.batchNumber}', style: styles.tStyle),
                  Text('SerialNumber: ${document.serialNumber}', style: styles.tStyle),
                  Text('ExpireDate: ${date_format.dateFormat.format(document.expireDate)}', style: styles.tStyle),
                  Text('Quantity: ${document.quantity}', style: styles.tStyle),
                  Text('ConsumerPrice: ${document.consumerPrice}', style: styles.tStyle),
                  Text('TotalValue: ${document.totalValue}', style: styles.tStyle),
                ],
              ),
            )
          ],
        )
    );
  }
}

//---------------------------------LIST OF ENTITIES-----------------------------------

class Document extends StatefulWidget {
  const Document({super.key});

  @override
  State<Document> createState() => _DocumentState();
}

class _DocumentState extends State<Document> {
  late Future<List<inventory_query.InventoryEntity>> _inventories; //list of inventories
  late Future<List<int>> _headerIds; //list of ids, used for drop down list
  late Future<List<int>> _packageIds; //list of ids, used for drop down list
  late Future<List<int>> _itemIds; //list of ids, used for drop down list

  @override
  void initState(){
    super.initState();
    _inventories = inventory_query.getAll();
    _headerIds = header_query.getAll().then( (x) => x.map((i)=>i.inventoryInHeaderId).toList() );
    _packageIds = package_query.getAll().then( (x) => x.map((i)=>i.packageId).toList() );
    _itemIds = item_query.getAll().then( (x) => x.map((i)=>i.itemId).toList() );
  }

  void _handleElementDelete(inventory_query.InventoryEntity entity) async{
    bool shouldDelete = await showDeleteDialog(context);

    if (shouldDelete) {
      await inventory_query.delete(entity.inventoryInDetailId);

      setState(() {
        _inventories = inventory_query.getAll();
      });
    }
  }

  void _handleElementEdit(inventory_query.InventoryEntity entity) async {
    var result = await showEditDialog(
        context,
        headerIds: await _headerIds,
        packageIds: await _packageIds,
        itemIds: await _itemIds,
        fields: inventory_query.InventoryFields.fromEntity(entity)
    );

    if(result.accept){
      await inventory_query.update(entity.inventoryInDetailId, result.fields!);

      setState(() {
        _inventories = inventory_query.getAll();
      });
    }
  }

  void _handleElementAdd() async {
    var result = await showAddDialog(
      context,
      headerIds: await _headerIds,
      itemIds: await _itemIds,
      packageIds: await _packageIds
    );

    if(result.accept) {
      await inventory_query.create(result.fields!);

      setState(() {
        _inventories = inventory_query.getAll();
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<inventory_query.InventoryEntity>>(
        future: _inventories,
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
                          child: DocumentCard(
                            document: x,
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
