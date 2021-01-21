import 'package:flutter/material.dart';

class ScreenBase extends StatelessWidget {
  final Widget child;
  final bool scrollable;

  ScreenBase({this.child, this.scrollable = false});

  Widget container() {
    if (scrollable) {
      return Scrollbar(
        child: SingleChildScrollView(
          child: Container(
            child: child,
          ),
        ),
      );
    }
    return Container(
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return container();
  }
}
