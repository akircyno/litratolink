import 'package:flutter/material.dart';

class AppScreen extends StatelessWidget {
  const AppScreen({
    required this.children,
    this.padding = const EdgeInsets.fromLTRB(20, 16, 20, 28),
    super.key,
  });

  final List<Widget> children;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: padding,
        children: children,
      ),
    );
  }
}
