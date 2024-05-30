import 'package:flutter/material.dart';
import 'package:flutter_polygon/flutter_polygon.dart';

class StageScreen extends StatelessWidget {
  const StageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade400,
      body: Center(
        child: _button(sides: 3, child: const Text('test')),
      ),
    );
  }

  Widget _button({
    required int sides,
    required Widget child,
    Function()? onPressed,
  }) {
    return Container(
      // margin: const EdgeInsets.only(right: 16.0),
      decoration: ShapeDecoration(
        shape: PolygonBorder(
          sides: sides,
          rotate: 0,
          side: const BorderSide(
            color: Colors.green,
            width: 300,
          ),
        ),
      ),
      child: Text('$sides'),
    );
  }
}
