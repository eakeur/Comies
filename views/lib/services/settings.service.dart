import 'package:comies/utils/declarations/environment.dart';
import 'package:comies/utils/declarations/storage.dart';
import 'package:sembast/sembast.dart';

class SettingsService {

  StoreRef collection = StoreRef.main();

  Future<dynamic> addSetting(String key, dynamic value) async {
    try {
        if (key == "url") URL = value;
       return await collection.record(key).put(storage, value);
       
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> removeSetting(String key) async {
    try {
      return await collection.record(key).delete(storage);
    } catch (e) {
      print(e);
    }
  }

  Future<T> getSetting<T>(String key) async {
    try {
      return await collection.record(key).get(storage) as T;
    } catch (e) {
      print(e);
      return null;
    }
  }
}