import 'package:http/http.dart' as http;
import '../config.dart' as config;
import 'dart:convert';

// Entity classes are used as representation for GET methods response body
// Fields classes are used as representation for POST/PUT methods request body

class ItemEntity {
  int itemId;
  String name;

  ItemEntity({required this.itemId, required this.name});

  factory ItemEntity.fromJson(Map<String,dynamic> json){
    return ItemEntity(
      itemId: json['itemId'],
      name: json['name']
    );
  }
}

class ItemFields {
  int? itemId;
  String name;

  ItemFields({this.itemId, required this.name});

  factory ItemFields.fromEntity(ItemEntity entity){
    return ItemFields(
      itemId: entity.itemId,
      name: entity.name
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'itemId': itemId,
      'name': name
    };
  }
}

const endpoint = 'item';

Future<List<ItemEntity>> getAll() async {
  http.Response resp = await http.get(Uri.parse('${config.apiUri}/$endpoint'));
  if (resp.statusCode != 200){ //Not Success
    throw Exception(resp.body);
  }
  return (jsonDecode(resp.body) as List<dynamic>).map((x) => ItemEntity.fromJson(x)).toList();
}

Future<void> delete(int id) async {
  http.Response resp = await http.delete(Uri.parse('${config.apiUri}/$endpoint/$id'));

  if (resp.statusCode != 204){ //Not Success
    throw Exception(resp.body);
  }
}

Future<void> create(ItemFields entity) async {
  http.Response resp = await http.post(
      Uri.parse('${config.apiUri}/$endpoint'),
      headers: {'content-type': 'application/json'}, //must explicitly set the content-type
      body: jsonEncode(entity)
  );

  if (resp.statusCode != 200){ //Not Success
    throw Exception(resp.body);
  }
}

Future<void> update(int id, ItemFields entity) async {
  http.Response resp = await http.put(
    Uri.parse('${config.apiUri}/$endpoint/$id'),
    headers: {'content-type': 'application/json'}, //must explicitly set the content-type
    body: jsonEncode(entity)
  );

  if (resp.statusCode != 200){ //Not Success
    throw Exception(resp.body);
  }
}