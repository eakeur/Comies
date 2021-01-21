import 'package:comies/services/general.service.dart';
import 'package:comies/services/settings.service.dart';
import 'package:comies/utils/declarations/environment.dart';
import 'package:comies/utils/validators.dart';
import 'package:comies_entities/comies_entities.dart';

class AuthenticationService extends GeneralService<dynamic> {
  dynamic context;

  AuthenticationService(dynamic context) {
    this.context = context;
    this.path = 'operators';
  }

  Future<Response> login({String nickname, String password}) async {
    try {
      if (isTextValid(nickname) && isTextValid(password)) {
        this.path = 'operators/login';
        var response =
            await super.add({"identification": nickname, "password": password});
        this.path = 'operators';
        notify(response, context);
        return response;
      } else
        return new Response(notifications: [
          new Notification(
              message:
                  "Apelido ou senha inválidos. Por favor, verifique se digitou tudo corretamente.")
        ]);
    } catch (e) {
      return new Response(notifications: [
        new Notification(
            message:
                "Um erro ocorreu. Por favor, verifique se digitou tudo corretamente.")
      ]);
    }
  }

  Future logoff() async {
    try {
      access = null;
      var serv = new SettingsService();
      if ((await serv.getSetting<String>('access')) != null) {
        await serv.removeSetting('access');
      }
    } catch (e) {}
  }
}
