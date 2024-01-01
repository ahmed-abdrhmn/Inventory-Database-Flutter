import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:date_field/date_field.dart';
import '../../../Queries/inventory_query.dart' as inventory_query;
import '../../Shared/date_format.dart' as date_format;

class DialogResult {
  bool accept; //Whether the user pressed "yes" in the dialog box
  inventory_query.InventoryFields? fields;

  DialogResult({required this.accept, this.fields});
}

Future<DialogResult> showEditDialog(
    BuildContext context,
    {
      required List<int> headerIds,
      required List<int> packageIds,
      required List<int> itemIds,
      required inventory_query.InventoryFields fields
    }) async {
  int inventoryInHeaderId = fields.inventoryInHeaderId;
  int serial = fields.serial;
  int itemId = fields.itemId;
  int packageId = fields.packageId;
  String batchNumber = fields.batchNumber;
  String serialNumber = fields.serialNumber;
  DateTime expireDate = fields.expireDate;
  num quantity = fields.quantity;
  num consumerPrice = fields.consumerPrice;

  bool? accepted = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Document'),
          content: Form(
              child: SingleChildScrollView( //we need this to allow scrolling if the keyboard takes up the bottom part of the screen
                child: Column(
                  mainAxisSize: MainAxisSize.min, //prevent the popup from occupying the whole vertical space of screen
                  children: [
                    DropdownButtonFormField<int?>(
                      decoration: const InputDecoration(
                          label: Text('HeaderId')
                      ),
                      items: headerIds.map((i) => DropdownMenuItem<int>(value: i, child: Text(i.toString()))).toList(),
                      value: fields.inventoryInHeaderId,
                      onChanged: (value){inventoryInHeaderId = value!;},
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          label: Text('Serial')
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [ FilteringTextInputFormatter.digitsOnly],
                      initialValue: fields.serial.toString(),
                      onChanged: (value){serial = int.parse(value);},
                    ),
                    DropdownButtonFormField<int?>(
                      decoration: const InputDecoration(
                          label: Text('ItemId')
                      ),
                      items: itemIds.map((i) => DropdownMenuItem<int>(value: i, child: Text(i.toString()))).toList(),
                      value: fields.itemId,
                      onChanged: (value){itemId = value!;},
                    ),
                    DropdownButtonFormField<int?>(
                      decoration: const InputDecoration(
                          label: Text('PackageId')
                      ),
                      items: packageIds.map((i) => DropdownMenuItem<int>(value: i, child: Text(i.toString()))).toList(),
                      value: fields.packageId,
                      onChanged: (value){packageId = value!;},
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          label: Text('Batch Number')
                      ),
                      initialValue: fields.batchNumber,
                      onChanged: (value){batchNumber = value;},
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          label: Text('Serial Number')
                      ),
                      initialValue: fields.serialNumber,
                      onChanged: (value){serialNumber = value;},
                    ),
                    DateTimeFormField(
                      decoration: const InputDecoration(
                          label: Text('Expire Date')
                      ),
                      mode: DateTimeFieldPickerMode.date,
                      dateFormat: date_format.dateFormat, //date format should match the server (Though from the docs MySQL is pretty fexible but I don't want to depend on that)
                      initialValue: fields.expireDate,
                      onDateSelected: (value){expireDate = value;},
                    ),
                    TextFormField(
                        decoration: const InputDecoration(
                            label: Text('Quantity')
                        ),
                        keyboardType: TextInputType.number,
                        initialValue: fields.quantity.toString(),
                        onChanged: (value){quantity = num.parse(value);}
                    ),
                    TextFormField(
                        decoration: const InputDecoration(
                            label: Text('Consumer Price')
                        ),
                        keyboardType: TextInputType.number,
                        initialValue: fields.consumerPrice.toString(),
                        onChanged: (value){consumerPrice = num.parse(value);}
                    ),
                  ],
                ),
              )
          ),
          actions: [
            ElevatedButton(
                onPressed: (){
                  Navigator.of(context).pop(false); //close the dialog, put return value here
                },
                child: const Text('Cancel')
            ),
            ElevatedButton(
                onPressed: (){
                  Navigator.of(context).pop(true); //close the dialog, put the return value here
                },
                child: const Text('OK')
            ),
          ],
        );
      }
  );

  if (accepted == true){
    return DialogResult(
        accept: true,
        fields: inventory_query.InventoryFields(
            inventoryInHeaderId: inventoryInHeaderId,
            serial: serial,
            itemId: itemId,
            packageId: packageId,
            batchNumber: batchNumber,
            serialNumber: serialNumber,
            expireDate: expireDate,
            quantity: quantity,
            consumerPrice: consumerPrice
        )
    );
  }else{
    return DialogResult(accept: false);
  }
}