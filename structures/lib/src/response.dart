import 'package:comies_entities/src/notification.dart';

class Response {
  String message;
  bool success;
  String access;
  dynamic data;
  List<Notification> notifications;

  Response(
      {this.message, this.success, this.access, this.data, this.notifications});
}
