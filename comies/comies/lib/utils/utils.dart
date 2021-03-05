import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

T getProvider<T>(BuildContext context, {listen = false}){
    return Provider.of<T>(context, listen: listen);
}