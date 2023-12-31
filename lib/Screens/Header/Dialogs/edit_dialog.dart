import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import '../../../Queries/header_query.dart' as header_query;
import '../../Shared/date_format.dart' as date_format;

class DialogResult {
  bool accept; //Whether the user pressed "yes" in the dialog box
  header_query.HeaderFields? fields;

  DialogResult({required this.accept, this.fields});
}

Future<DialogResult> showEditDialog(BuildContext context, {required List<int> branchIds, required header_query.HeaderFields fields}) async {
  int branchId = fields.branchId;
  DateTime docDate = fields.docDate;
  String reference = fields.reference;
  String remarks = fields.remarks;

  bool? accepted = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Header'),
          content: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min, //prevent the popup from occupying the whole vertical space of screen
                children: [
                  DropdownButtonFormField<int?>(
                    decoration: const InputDecoration(
                        label: Text('BranchId')
                    ),
                    items: branchIds.map((i) => DropdownMenuItem<int>(value: i, child: Text(i.toString()))).toList(),
                    value: fields.branchId,
                    onChanged: (value){branchId = value!;},
                  ),
                  DateTimeFormField(
                    decoration: const InputDecoration(
                        label: Text('DocDate')
                    ),
                    mode: DateTimeFieldPickerMode.date,
                    dateFormat: date_format.dateFormat, //date format should match the server (Though from the docs MySQL is pretty fexible but I don't want to depend on that)
                    initialValue: fields.docDate,
                    onDateSelected: (value){docDate = value;},
                  ),
                  TextFormField(
                      decoration: const InputDecoration(
                          label: Text('Reference')
                      ),
                      initialValue: fields.reference,
                      onChanged: (value){reference = value;},
                  ),
                  TextFormField(
                      decoration: const InputDecoration(
                          label: Text('Remarks')
                      ),
                      initialValue: fields.remarks,
                      onChanged: (value){remarks = value;}
                  ),
                ],
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
        fields: header_query.HeaderFields(
            branchId: branchId,
            docDate: docDate,
            reference: reference,
            remarks: remarks
        )
    );
  }else{
    return DialogResult(accept: false);
  }
}