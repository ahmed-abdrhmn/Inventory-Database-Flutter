import 'package:flutter/material.dart';
import '../../../Queries/branch_query.dart' as branch_query;

class DialogResult {
  bool accept; //Whether the user pressed "yes" in the dialog box
  branch_query.BranchFields? fields;

  DialogResult({required this.accept, this.fields});
}

Future<DialogResult> showAddDialog(BuildContext context) async {
  String? name;

  bool? accepted = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Branch'),
          content: Form(
            child: TextFormField(
                decoration: const InputDecoration(
                    label: Text('Name')
                ),
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
        fields: branch_query.BranchFields(
            name: name!
        )
    );
  }else{
    return DialogResult(accept: false);
  }
}