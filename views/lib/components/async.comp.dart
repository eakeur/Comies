import 'package:comies/utils/declarations/environment.dart';
import 'package:comies_entities/comies_entities.dart';
import 'package:flutter/material.dart';

class AsyncComponent extends StatefulWidget {
  final Widget child;
  final Future Function() future;
  final String messageIfNullOrEmpty;
  final LoadStatus status;
  final dynamic data;

  AsyncComponent({
    this.data,
    this.future,
    this.messageIfNullOrEmpty,
    this.status,
    this.child,
    Key key,
  }) : super(key: key);

  @override
  Async createState() => Async();
}

class Async extends State<AsyncComponent> {
  bool visible = false;
  bool isDataNullOrEmpty() {
    var tgt = widget.data;
    if (tgt != null) {
      if (tgt is List) return tgt.length <= 0;
      if (tgt is Set) return tgt.length <= 0;
      if (tgt is Map) return tgt.length <= 0;
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
    }
    return isDataNullOrEmpty()
        ? NullResultWidget(messageIfNullOrEmpty: widget.messageIfNullOrEmpty)
        : widget.child;
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
