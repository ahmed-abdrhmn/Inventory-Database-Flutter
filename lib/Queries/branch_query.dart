import 'package:http/http.dart' as http;
import '../config.dart' as config;
import 'dart:convert';

// Entity classes are used as representation for GET methods response body
// Fields classes are used as representation for POST/PUT methods request body

class BranchEntity {
  int branchId;
  String name;

  BranchEntity({required this.branchId, required this.name});

  factory BranchEntity.fromJson(Map<String,dynamic> json){
    return BranchEntity(
      branchId: json['branchId'],
      name: json['name']
    );
  }
}

class BranchFields {
  int? branchId;
  String name;

  BranchFields({this.branchId, required this.name});

  factory BranchFields.fromEntity(BranchEntity entity){
    return BranchFields(
      branchId: entity.branchId,
      name: entity.name
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'branchId': branchId,
      'name': name
    };
  }
}

const endpoint = 'branch';

Future<BranchEntity> getAll() async {
  http.Response resp = await http.get(Uri.parse('${config.apiUri}/$endpoint'));
  if (resp.statusCode != 200){ //Not Success
    throw Exception(resp.body);
  }
  return BranchEntity.fromJson(jsonDecode(resp.body));
}

Future<void> delete(int id) async {
  http.Response resp = await http.delete(Uri.parse('${config.apiUri}/$endpoint/$id'));

  if (resp.statusCode != 204){ //Not Success
    throw Exception(resp.body);
  }
}

Future<void> create(BranchFields entity) async {
  http.Response resp = await http.post(
      Uri.parse('${config.apiUri}/$endpoint'),
      body: jsonEncode(entity)
  );

  if (resp.statusCode != 200){ //Not Success
    throw Exception(resp.body);
  }
}

Future<void> update(int id, BranchFields entity) async {
  http.Response resp = await http.put(
    Uri.parse('${config.apiUri}/$endpoint/$id'),
    body: jsonEncode(entity)
  );

  if (resp.statusCode != 200){ //Not Success
    throw Exception(resp.body);
  }
}