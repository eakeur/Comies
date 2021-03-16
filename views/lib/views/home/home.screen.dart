import 'package:comies/components/menu.comp.dart';
import 'package:comies/main.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class HomeScreen extends StatefulWidget {
  
  @override
  Home createState() => Home();
}

class Home extends State<HomeScreen> {
  
  IOWebSocketChannel channel;  // IOWebSocketChannel.connect(session.screenRoute, headers: {"authorization": session.token});
  TextEditingController c = new TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return session.isAuthenticated ? Scaffold(
      bottomNavigationBar: NavigationBar(),
      body:  channel != null ? Card(
        child: GestureDetector(
          onVerticalDragUpdate: (DragUpdateDetails det){
            channel.sink.add(det.globalPosition.dy.toString());
          },
          child: Container(
            width: 1000,
            height: 1000,
            child: Text("deslize")
          ),
        )
      ) : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: TextFormField(
            controller: c,
            decoration: InputDecoration(
              suffix: IconButton(icon: Icon(Icons.add), onPressed: () => setState((){
              channel = IOWebSocketChannel.connect(Uri.parse(session.screenRoute+"${c.text}"), headers: {"authorization": session.token});
            }))
            ),
          ),)
        ],
      )
    ): session.goToAuthenticationScreen();
  }
}
