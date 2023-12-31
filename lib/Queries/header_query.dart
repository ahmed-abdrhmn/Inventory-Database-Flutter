import 'package:aproject/Queries/branch_query.dart';
import 'package:http/http.dart' as http;
import '../config.dart' as config;
import '../Screens/Shared/date_format.dart' as date_format;
import 'dart:convert';

// Entity classes are used as representation for GET methods response body
// Fields classes are used as representation for POST/PUT methods request body

class HeaderEntity {
  int inventoryInHeaderId;
  BranchEntity branch;
  DateTime docDate;
  String reference;
  num totalValue; //I wanted to make it double but flutter doesn't allow int to double cast
  String remarks;


  HeaderEntity({required this.inventoryInHeaderId, required this.branch, required this.docDate,
      required this.reference, required this.totalValue, required this.remarks});

  factory HeaderEntity.fromJson(Map<String,dynamic> json){
    return HeaderEntity(
      inventoryInHeaderId: json['inventoryInHeaderId'],
      branch: BranchEntity.fromJson(json['branch']),
      docDate: DateTime.parse(json['docDate']),
      reference: json['reference'],
      totalValue: json['totalValue'],
      remarks: json['remarks']
    );
  }
}

class HeaderFields {
  int? inventoryInHeaderId;
  int branchId;
  DateTime docDate;
  String reference;
  String remarks;


  HeaderFields({this.inventoryInHeaderId, required this.branchId, required this.docDate,
    required this.reference, required this.remarks});

  factory HeaderFields.fromEntity(HeaderEntity entity){
    return HeaderFields(
      inventoryInHeaderId: entity.inventoryInHeaderId,
      branchId: entity.branch.branchId,
      docDate: entity.docDate,
      reference: entity.reference,
      remarks: entity.remarks
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'inventoryInHeaderId': inventoryInHeaderId,
      'branchId': branchId,
      'docDate': date_format.dateFormat.format(docDate),
      'reference': reference,
      'remarks': remarks
    };
  }
}

const endpoint = 'header';

Future<List<HeaderEntity>> getAll() async {
  http.Response resp = await http.get(Uri.parse('${config.apiUri}/$endpoint'));
  if (resp.statusCode != 200){ //Not Success
    throw Exception(resp.body);
  }

  return (jsonDecode(resp.body) as List<dynamic>).map((x) => HeaderEntity.fromJson(x)).toList();
}

Future<void> delete(int id) async {
  http.Response resp = await http.delete(Uri.parse('${config.apiUri}/$endpoint/$id'));

  if (resp.statusCode != 204){ //Not Success
    throw Exception(resp.body);
  }
}

Future<void> create(HeaderFields fields) async {
  http.Response resp = await http.post(
      Uri.parse('${config.apiUri}/$endpoint'),
      headers: {'content-type': 'application/json'},
      body: jsonEncode(fields)
  );

  if (resp.statusCode != 200){ //Not Success
    throw Exception(resp.body);
  }
}

Future<void> update(int id, HeaderFields fields) async {
  http.Response resp = await http.put(
    Uri.parse('${config.apiUri}/$endpoint/$id'),
    headers: {'content-type': 'application/json'},
    body: jsonEncode(fields)
  );

  if (resp.statusCode != 200){ //Not Success
    throw Exception(resp.body);
  }
}