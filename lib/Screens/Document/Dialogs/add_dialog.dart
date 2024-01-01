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

Future<DialogResult> showAddDialog(
    BuildContext context,
    {
      required List<int> headerIds,
      required List<int> packageIds,
      required List<int> itemIds 
    }) async {
  int? inventoryInHeaderId;
  int? serial;
  int? itemId;
  int? packageId;
  String? batchNumber;
  String? serialNumber;
  DateTime? expireDate;
  num? quantity;
  num? consumerPrice;

  bool? accepted = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Document'),
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
                      onChanged: (value){inventoryInHeaderId = value!;},
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          label: Text('Serial')
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [ FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value){serial = int.parse(value);},
                    ),
                    DropdownButtonFormField<int?>(
                      decoration: const InputDecoration(
                          label: Text('ItemId')
                      ),
                      items: itemIds.map((i) => DropdownMenuItem<int>(value: i, child: Text(i.toString()))).toList(),
                      onChanged: (value){itemId = value!;},
                    ),
                    DropdownButtonFormField<int?>(
                      decoration: const InputDecoration(
                          label: Text('PackageId')
                      ),
                      items: packageIds.map((i) => DropdownMenuItem<int>(value: i, child: Text(i.toString()))).toList(),
                      onChanged: (value){packageId = value!;},
                    ),
                    TextFormField(
                        decoration: const InputDecoration(
                            label: Text('Batch Number')
                        ),
                        onChanged: (value){batchNumber = value;},
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          label: Text('Serial Number')
                      ),
                      onChanged: (value){serialNumber = value;},
                    ),
                    DateTimeFormField(
                      decoration: const InputDecoration(
                          label: Text('Expire Date')
                      ),
                      mode: DateTimeFieldPickerMode.date,
                      dateFormat: date_format.dateFormat, //date format should match the server (Though from the docs MySQL is pretty fexible but I don't want to depend on that)
                      onDateSelected: (value){expireDate = value;},
                    ),
                    TextFormField(
                        decoration: const InputDecoration(
                            label: Text('Quantity')
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value){quantity = num.parse(value);}
                    ),
                    TextFormField(
                        decoration: const InputDecoration(
                            label: Text('Consumer Price')
                        ),
                        keyboardType: TextInputType.number,
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
          inventoryInHeaderId: inventoryInHeaderId!,
          serial: serial!,
          itemId: itemId!,
          packageId: packageId!,
          batchNumber: batchNumber!,
          serialNumber: serialNumber!,
          expireDate: expireDate!,
          quantity: quantity!,
          consumerPrice: consumerPrice!
        )
    );
  }else{
    return DialogResult(accept: false);
  }
}