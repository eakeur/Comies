import 'package:comies_entities/comies_entities.dart';

import '../utils/converters.dart';
import '../utils/database.dart';

class ProductsService {

  List<String> properties = ['id', 'name', 'code', 'min', 'unity', 'partnerId', 'active'];

   Future add() async {

   }

   Future<List<Map<String, dynamic>>> view(Map<String, dynamic> params) async {
     var query = collection.select().from('product');
     if (params['id'] != null) query = query.whereSafe('id', '=', params['id']);
     if (params['name'] != null) query = query.whereSafe('name', '=', params['name']);
     if (params['partnerId'] != null) query = query.whereSafe('partnerId', '=', params['partnerId']);
     return convertRowToMap(await query.get(), properties);
   }
}