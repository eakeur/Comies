import 'package:comies/services/operators.service.dart';
import 'package:comies/services/settings.service.dart';
import 'package:comies/utils/validators.dart';
import 'package:comies/views/authentication/authentication.screen.dart';
import 'package:comies_entities/comies_entities.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class Session {
  Session({this.token});

  Future<Session> loadSession() async {
    try {
      var service = new SettingsService();
      server = await service.getSetting('url');
      if(token == null){
        token = await service.getSetting('access');
        isAuthenticated() ? await _getOperator() : token == null ? print("No session to be restored")  : service.removeSetting('access');
        return this;
      } else {
        if (isAuthenticated()) await _getOperator();
        return this;
      }
    } catch (e) {
      print(e);
      return this;
    }
  }

  String token;
  Operator operator;
  Profile permissions;
  String server;
  bool isAuthenticated(){
    if (isTextValid(token)) return !JwtDecoder.isExpired(token);
    else return false;
  }
  
  Future<bool> isConfigured() async {
    var service = new SettingsService();
    dynamic allSet = await service.getSetting<bool>('allSet');
    if (allSet != null && allSet is bool) return allSet;
    return false;
  }
  AuthenticationScreen goToAuthenticationScreen(){
    return AuthenticationScreen();
  }

  Future<void> _getOperator() async {
    operator = await new OperatorsService().getById(JwtDecoder.decode(token)['id']);
    permissions = operator.profile;
  }
}