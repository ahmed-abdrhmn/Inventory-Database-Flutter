import 'package:flutter/material.dart';
import '../../../Queries/header_query.dart' as header_query;

Future<bool> showDeleteDialog(BuildContext context) async {
  bool? delete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Header'),
          content: const Text('Are you sure you want to delete this header?'),
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