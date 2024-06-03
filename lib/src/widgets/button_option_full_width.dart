import 'package:flutter/material.dart';

class ButtonOptionFullWidth extends StatefulWidget {
  final String text;
  final VoidCallback onClick;
  final Color color;
  const ButtonOptionFullWidth({
    super.key,
    required this.text,
    required this.onClick,
    this.color = const Color(0xFF9C7AFF),
  });

  @override
  State<ButtonOptionFullWidth> createState() => _ButtonOptionFullWidthState();
}

class _ButtonOptionFullWidthState extends State<ButtonOptionFullWidth> {
  late Color color;

  @override
  void initState() {
    super.initState();
    color = widget.color;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          color = const Color.fromARGB(122, 244, 211, 180);
        });
        widget.onClick();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 0,
        // ignore: prefer_const_constructors
        side: BorderSide(
          color: const Color.fromARGB(172, 255, 255, 255),
          width: 2.0,
        ),
        minimumSize: const Size(double.infinity, 70),
      ),
      child: Text(
        widget.text,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
