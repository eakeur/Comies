import 'package:comies/main.dart';
import 'package:comies/services/general.service.dart';
import 'package:comies/services/settings.service.dart';
import 'package:comies_entities/comies_entities.dart';
import 'package:flutter/widgets.dart';

class AuthenticationController extends ChangeNotifier {


  Service service = new Service('authentication', (obj) => obj, (obj) => obj);
  

  Future<Response> login({String nickname, String password, bool stayConnected = false}) async {
    try {
      var res = await service.add({"identification": nickname, "password": password, "remember": stayConnected});
      if (res.success){
        var settingsService = new SettingsService();
        await settingsService.removeSetting('access');
        await settingsService.addSetting('access', res.access);
        await session.loadSession(res.access);
        return res;
      } else throw res;
    } catch (e) {
      throw e;
    }
  }

  static Future<void> logoff() async {
    try {
      session.token = null;
      var serv = new SettingsService();
      if ((await serv.getSetting<String>('access')) != null) {
        await serv.removeSetting('access');
      }
    } catch (e) {}
  }
}