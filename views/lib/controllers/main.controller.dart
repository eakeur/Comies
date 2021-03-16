import 'dart:collection';
import 'package:comies/services/general.service.dart';
import 'package:comies/services/settings.service.dart';
import 'package:comies/utils/converters.dart';
import 'package:comies/utils/validators.dart';
import 'package:comies/views/authentication/authentication.screen.dart';
import 'package:comies_entities/comies_entities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class SessionController extends ChangeNotifier {

  Operator operator;
  Partner partner;
  Store store;
  String token;
  Profile permissions;
  String server;
  String get kitchenRoute => "${server.replaceFirst("http://", "ws://").replaceFirst("https://", "wss://")}/kitchen/${partner.id}/${store.id}";
  String get screenRoute => "${server.replaceFirst("http://", "ws://").replaceFirst("https://", "wss://")}/screen/${partner.id}/${store.id}/";
  String get screenTVRoute => "${server.replaceFirst("http://", "ws://").replaceFirst("https://", "wss://")}/screen/${partner.id}/${store.id}/TV";
  List<Widget> _actionsOnPage = [];
  UnmodifiableListView<Widget> get actionsOnPage => _actionsOnPage;

  String _actualRoute = "/welcome";

  String get actualRoute => _actualRoute;

  void addActions(List<Widget> widgets){
    _actionsOnPage.addAll(widgets);
    notifyListeners();
  }


  void setActualRoute(String route, context){
    _actualRoute = route;
    Navigator.of(context).pushNamed(actualRoute);
  }

  Future<SessionController> getSession() async {
    try {
      var service = new SettingsService();
      if (await isConfigured()){
        server = await service.getSetting('url');
        if(server != null){
          if(token == null){
            token = await service.getSetting('access');
            if (isAuthenticated){_actualRoute = '/'; await _getOperator();}
            else {_actualRoute = "/authentication"; service.removeSetting('access');}
            return this;
          } else {
            if (isAuthenticated) await _getOperator();
            else _actualRoute = "/authentication";
            return this;
          }
        }
      } return this;
    } catch (e) {
      print(e);
      return this;
    }
  }

  Future<SessionController> loadSession(String token) async {
    try {
      token = token;
      if (isAuthenticated){
        _actualRoute = '/';
        await _getOperator();
      }
      else {_actualRoute = "/authentication";}
      return this;
    } catch (e) {
      print(e);
      return this;
    }
  }

  bool get isAuthenticated => isTextValid(token) ? !JwtDecoder.isExpired(token) : false ;
  
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
    var res = await new Service<Operator>('operators', serializeOperator, deserializeOperatorMap).getOne(JwtDecoder.decode(token)['id']);
    if (res.success){
      operator = res.data;
      partner = operator.partner;
      store = operator.store;
      permissions = operator.profile;
    }
  }



}