import 'package:flutter/material.dart';

class DismissibalWidgets extends StatelessWidget {
  final item;
  final Widget child;
  DismissibalWidgets({required this.child, required this.item, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ObjectKey(item),
      child: child,
    );
  }
}
