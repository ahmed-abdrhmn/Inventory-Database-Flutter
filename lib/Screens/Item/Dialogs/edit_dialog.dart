import 'package:flutter/material.dart';
import '../../../Queries/item_query.dart' as item_query;

class DialogResult {
  bool accept; //Whether the user pressed "yes" in the dialog box
  item_query.ItemFields? fields;

  DialogResult({required this.accept, this.fields});
}

Future<DialogResult> showEditDialog(BuildContext context, { required item_query.ItemFields fields }) async {
  String name = fields.name;

  bool? accepted = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Item'),
          content: Form(
            child: TextFormField(
              decoration: const InputDecoration(
                  label: Text('Name')
              ),
              initialValue: fields.name,
              onChanged: (value){name = value;}
            ),
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
        fields: item_query.ItemFields(
          name: name
        )
    );
  }else{
    return DialogResult(accept: false);
  }
}