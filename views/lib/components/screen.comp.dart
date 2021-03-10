import 'package:comies/utils/declarations/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Screen extends StatelessWidget{

  final Future<void> Function() onRefresh;
  final List<Widget> children;
  final List<double> grid;
  final int axis;

  Screen({this.onRefresh, this.children, this.grid, this.axis = 1});

  @override
    Widget build(BuildContext context){
        bool isBigScreen = MediaQuery.of(context).size.width > widthDivisor;
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: GridView.count(crossAxisCount: isBigScreen ? axis : 1, 
        childAspectRatio: MediaQuery.of(context).size.width / MediaQuery.of(context).size.height,
          children: [for(var child in children) Container(child: child)],
        )
      );
    }
}