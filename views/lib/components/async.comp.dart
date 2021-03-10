import 'package:comies/utils/declarations/environment.dart';
import 'package:comies_entities/comies_entities.dart';
import 'package:flutter/material.dart';

class AsyncComponent extends StatefulWidget {
  final Widget child;
  final Future Function() future;
  final String messageIfNullOrEmpty;
  final String initialMessage;
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
    this.initialMessage = "",
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
    } else if (widget.status == LoadStatus.waitingStart){
      return Container(
        height: 50,
        child: Center(
          child: Text(widget.initialMessage),
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
              ? MediaQuery.of(context).size.width / 2
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




class AsyncButton extends StatelessWidget {
  final String text;
  final String tooltip;
  final Icon icon;
  final ButtonStyle style;
  final Function onPressed;
  final bool isLoading;

  AsyncButton({this.text, this.icon, this.style, this.onPressed, this.isLoading, this.tooltip});
  @override
  Widget build(BuildContext context) {
    var button;
    if (text != null && icon == null) button = ElevatedButton(onPressed: onPressed, child: Text(text), style: style);
    if (text != null && icon != null) button = ElevatedButton.icon(onPressed: onPressed, label: Text(text), icon: icon, style: style);
    if (text == null && icon != null) button = IconButton(icon: icon, onPressed: onPressed, tooltip: tooltip);
    
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 400),
      switchInCurve: Curves.easeInBack,
      switchOutCurve: Curves.easeOutBack,
      transitionBuilder: (child, animation) => SizeTransition(child: child, sizeFactor: animation, axis: Axis.horizontal),
      child: isLoading 
        ? Container(width: 55, height: 55, child: CircularProgressIndicator(), padding: EdgeInsets.all(10), key: ValueKey(1)) 
        : Container(height: 55, child: (button is IconButton) ? button : Center(child: button) , key: ValueKey(2)),
    );
  }
}
