import 'dart:mirrors';

import 'package:comies_entities/comies_entities.dart';

void main(){
  var im = reflect();
  var classMirror = im.type;
  for ( var val in classMirror.declarations.values){
    try {
      var i = im.getField(val.simpleName).reflectee;
      if (i is Function) return;
      print(i);
    } catch (e) {
      return;
    }
  }
}