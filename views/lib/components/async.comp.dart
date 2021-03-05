import 'package:comies/utils/declarations/environment.dart';
import 'package:comies_entities/comies_entities.dart';
import 'package:flutter/material.dart';

class AsyncComponent extends StatefulWidget {
  final Widget child;
  final Future Function() future;
  final String messageIfNullOrEmpty;
  final LoadStatus status;
  final SnackBar snackbar;
  final dynamic data;
  final bool animate;

  AsyncComponent({
    this.animate = true,
    this.data,
    this.future,
    this.messageIfNullOrEmpty,
    this.status,
    this.child,
    this.snackbar,
    Key key,
  }) : super(key: key);

  @override
  Async createState() => Async();
}

class Async extends State<AsyncComponent> with TickerProviderStateMixin {
  AnimationController controller;
  bool visible = false;
  bool isDataNullOrEmpty() {
    var tgt = widget.data;
    if (tgt != null) {
      if (tgt is List) return tgt.length <= 0;
      else if (tgt is Set) return tgt.length <= 0;
      else if (tgt is Map) return tgt.length <= 0;
      else return false;
    }
    return true;
  }

  Widget decideRender() {
    if (widget.status == LoadStatus.loading) {
      return Container(
        width: 50,
        height: 50,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (widget.status == LoadStatus.failed){
      return Container(
        height: 50,
        child: Center(
          child: Text("Ops! Um erro ocorreu!"),
        ),
      );
    }
    return isDataNullOrEmpty()
        ? NullResultWidget(messageIfNullOrEmpty: widget.messageIfNullOrEmpty)
        : widget.child;
  }

  @override
  void initState(){
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    return decideRender();
  }
}

class NullResultWidget extends StatelessWidget {
  final String messageIfNullOrEmpty;

  NullResultWidget({this.messageIfNullOrEmpty, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/illustrations/man.food.png",
          height: 150,
          width: MediaQuery.of(context).size.width > widthDivisor
              ? MediaQuery.of(context).size.width / 4
              : MediaQuery.of(context).size.width / 1.1,
          alignment: Alignment.bottomCenter,
        ),
        Text(
          messageIfNullOrEmpty,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
