import 'package:http/http.dart' as http;
import '../config.dart' as config;
import './header_query.dart' as header_query;
import './item_query.dart' as item_query;
import './package_query.dart' as package_query;
import '../Screens/Shared/date_format.dart' as date_format;
import 'dart:convert';

// Entity classes are used as representation for GET methods response body
// Fields classes are used as representation for POST/PUT methods request body

class InventoryEntity {
  int inventoryInDetailId;
  header_query.HeaderEntity inventoryInHeader;
  int serial;
  item_query.ItemEntity item;
  package_query.PackageEntity package;
  String batchNumber;
  String serialNumber;
  DateTime expireDate;
  num quantity;
  num consumerPrice;
  num totalValue;

  InventoryEntity({
    required this.inventoryInDetailId,
    required this.inventoryInHeader,
    required this.serial,
    required this.item,
    required this.package,
    required this.batchNumber,
    required this.serialNumber,
    required this.expireDate,
    required this.quantity,
    required this.consumerPrice,
    required this.totalValue
  });

  factory InventoryEntity.fromJson(Map<String,dynamic> json){
    return InventoryEntity(
      inventoryInDetailId: json['inventoryInDetailId'],
      inventoryInHeader: header_query.HeaderEntity.fromJson(json['inventoryInHeader']),
      serial: json['serial'],
      item: item_query.ItemEntity.fromJson(json['item']),
      package: package_query.PackageEntity.fromJson(json['package']),
      batchNumber: json['batchNumber'],
      serialNumber: json['serialNumber'],
      expireDate: DateTime.parse(json['expireDate']),
      quantity: json['quantity'],
      consumerPrice: json['consumerPrice'],
      totalValue: json['totalValue']
    );
  }
}

class InventoryFields {
  int? inventoryInDetailId;
  int inventoryInHeaderId;
  int serial;
  int itemId;
  int packageId;
  String batchNumber;
  String serialNumber;
  DateTime expireDate;
  num quantity;
  num consumerPrice;

  InventoryFields({
    this.inventoryInDetailId,
    required this.inventoryInHeaderId,
    required this.serial,
    required this.itemId,
    required this.packageId,
    required this.batchNumber,
    required this.serialNumber,
    required this.expireDate,
    required this.quantity,
    required this.consumerPrice,
  });

  factory InventoryFields.fromEntity(InventoryEntity entity){
    return InventoryFields(
      inventoryInDetailId: entity.inventoryInDetailId,
      inventoryInHeaderId: entity.inventoryInHeader.inventoryInHeaderId,
      serial: entity.serial,
      itemId: entity.item.itemId,
      packageId: entity.package.packageId,
      batchNumber: entity.batchNumber,
      serialNumber: entity.serialNumber,
      expireDate: entity.expireDate,
      quantity: entity.quantity,
      consumerPrice: entity.consumerPrice,
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'inventoryInDetailId': inventoryInDetailId,
      'inventoryInHeaderId': inventoryInHeaderId,
      'serial': serial,
      'itemId': itemId,
      'packageId': packageId,
      'batchNumber': batchNumber,
      'serialNumber': serialNumber,
      'expireDate': date_format.dateFormat.format(expireDate),
      'quantity': quantity,
      'consumerPrice': consumerPrice
    };
  }
}

const endpoint = 'inventory';

Future<List<InventoryEntity>> getAll() async {
  http.Response resp = await http.get(Uri.parse('${config.apiUri}/$endpoint'));
  if (resp.statusCode != 200){ //Not Success
    throw Exception(resp.body);
  }
  return (jsonDecode(resp.body) as List<dynamic>).map((x) => InventoryEntity.fromJson(x)).toList();
}

Future<void> delete(int id) async {
  http.Response resp = await http.delete(Uri.parse('${config.apiUri}/$endpoint/$id'));

  if (resp.statusCode != 204){ //Not Success
    throw Exception(resp.body);
  }
}

Future<void> create(InventoryFields entity) async {
  http.Response resp = await http.post(
      Uri.parse('${config.apiUri}/$endpoint'),
      headers: {'content-type': 'application/json'}, //must explicitly set the content-type
      body: jsonEncode(entity)
  );

  if (resp.statusCode != 200){ //Not Success
    throw Exception(resp.body);
  }
}

Future<void> update(int id, InventoryFields entity) async {
  http.Response resp = await http.put(
    Uri.parse('${config.apiUri}/$endpoint/$id'),
    headers: {'content-type': 'application/json'}, //must explicitly set the content-type
    body: jsonEncode(entity)
  );

  if (resp.statusCode != 200){ //Not Success
    throw Exception(resp.body);
  }
}