import 'package:http/http.dart' as http;
import '../config.dart' as config;
import 'dart:convert';

// Entity classes are used as representation for GET methods response body
// Fields classes are used as representation for POST/PUT methods request body

class PackageEntity {
  int packageId;
  String name;

  PackageEntity({required this.packageId, required this.name});

  factory PackageEntity.fromJson(Map<String,dynamic> json){
    return PackageEntity(
      packageId: json['packageId'],
      name: json['name']
    );
  }
}

class PackageFields {
  int? packageId;
  String name;

  PackageFields({this.packageId, required this.name});

  factory PackageFields.fromEntity(PackageEntity entity){
    return PackageFields(
      packageId: entity.packageId,
      name: entity.name
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'packageId': packageId,
      'name': name
    };
  }
}

const endpoint = 'package';

Future<List<PackageEntity>> getAll() async {
  http.Response resp = await http.get(Uri.parse('${config.apiUri}/$endpoint'));
  if (resp.statusCode != 200){ //Not Success
    throw Exception(resp.body);
  }
  return (jsonDecode(resp.body) as List<dynamic>).map((x) => PackageEntity.fromJson(x)).toList();
}

Future<void> delete(int id) async {
  http.Response resp = await http.delete(Uri.parse('${config.apiUri}/$endpoint/$id'));

  if (resp.statusCode != 204){ //Not Success
    throw Exception(resp.body);
  }
}

Future<void> create(PackageFields entity) async {
  http.Response resp = await http.post(
      Uri.parse('${config.apiUri}/$endpoint'),
      headers: {'content-type': 'application/json'}, //must explicitly set the content-type
      body: jsonEncode(entity)
  );

  if (resp.statusCode != 200){ //Not Success
    throw Exception(resp.body);
  }
}

Future<void> update(int id, PackageFields entity) async {
  http.Response resp = await http.put(
    Uri.parse('${config.apiUri}/$endpoint/$id'),
    headers: {'content-type': 'application/json'}, //must explicitly set the content-type
    body: jsonEncode(entity)
  );

  if (resp.statusCode != 200){ //Not Success
    throw Exception(resp.body);
  }
}