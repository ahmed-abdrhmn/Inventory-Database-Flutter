import 'package:flutter/material.dart';

Future<bool> showDeleteDialog(BuildContext context) async {
  bool? delete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Document'),
          content: const Text('Are you sure you want to delete this document?'),
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

  if (delete != null){
    return delete;
  }else{
    return false;
  }
}