import 'dart:mirrors';

import 'package:comies_entities/comies_entities.dart';

List<Map<String, dynamic>> convertRowToMap(List<List<dynamic>> input, List<String> properties){
     var entities = <Map<String, dynamic>>[]; var index = 0;
     input.forEach((list) { 
       var map = <String, dynamic>{};
       for (var prop in properties) { map[prop] = list[index]; index++;}
       entities.add(map);
    });
    return entities;
   }


T putFieldsInObject<T>(T object, List<dynamic> values){
  var im = reflect(object);
  var classMirror = im.type;
  var index = 0;
  for ( var val in classMirror.declarations.values){
    try {
      if (im.getField(val.simpleName).type.isEnum){
        
      }
      if (im.getField(val.simpleName).type.isAssignableTo(1.0.runtimeType)){
        
      }
      
      var fieldName = val.simpleName;
      im.setField(fieldName, values[index]);
      index++;
    } catch (e) {
    }
  }
  return object;
}

void main() {
  print(putFieldsInObject(Product(), [1, 'Produto', 'REDF', 1.0, Unity.unity, 1.0, 1, true, <Partner>[], <Order>[]]));
}