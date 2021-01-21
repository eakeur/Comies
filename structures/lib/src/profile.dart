import 'enum.dart';

/// A group of settings that will allow or disallow operators to do things
class Profile {
  ///The profile id
  int id;

  ///The name of the profile setting
  String name;

  ///Level of permission for dealing with orders
  Permission orders;

  ///Level of permission for dealing with orders
  Permission products;

  ///Level of permission for dealing with orders
  Permission stores;

  ///Level of permission for dealing with orders
  Permission costumers;
}
