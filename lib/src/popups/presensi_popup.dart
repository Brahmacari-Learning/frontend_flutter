import 'package:flutter/material.dart';

class PresensiPopup extends StatefulWidget {
  const PresensiPopup({super.key});

  @override
  State<PresensiPopup> createState() => _PresensiPopupState();
}

class _PresensiPopupState extends State<PresensiPopup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('lib/assets/images/presensi_harian.png'),
          ],
        ),
      ),
    );
  }
}
