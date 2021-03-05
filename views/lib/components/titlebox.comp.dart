import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TitleBox extends StatelessWidget {
  final String title;
  final String subtitle;
  final double borderRadius;
  final Widget suffix;
  final bool paint;

  TitleBox(this.title, {this.subtitle, this.borderRadius = 10, this.suffix, this.paint = false });

  @override
  Widget build(BuildContext context){
    return Container(
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
        color: paint ? Theme.of(context).primaryColor : null, 
        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
      ),
      child: ListTile(
        title: Text(title.toUpperCase(), style: TextStyle(color: paint ? Colors.white : Theme.of(context).primaryColor , fontSize: 17, fontWeight: FontWeight.w600)),
        subtitle: subtitle != null ? Text(subtitle, style: TextStyle(color: Colors.white)) : null,
        trailing: suffix
      )
    );
  }
}