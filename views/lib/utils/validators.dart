import 'dart:io';

bool isTextValid(String v) => v != null && v != "" && v.trim() != "";
bool isNull(dynamic v) => v == null;
bool isWeb(){try{return Platform.isAndroid?false:false;}catch(e){return true;}}
