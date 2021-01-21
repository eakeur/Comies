
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';

Future initDB() async {
  DatabaseFactory dbFactory;
  try {
    dbFactory = databaseFactoryIo;
    storage = await dbFactory.openDatabase((await getApplicationDocumentsDirectory()).path +"/cdfvvghmisssokjres.db");
  } catch (e) {
    dbFactory = databaseFactoryWeb;
    storage = await dbFactory.openDatabase("/cdfvvghmisssokjres.db");
  }
}

Database storage;
