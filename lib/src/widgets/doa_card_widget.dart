import 'package:flutter/material.dart';

class DoaCardWidget extends StatelessWidget {
  final String headerText;
  final String subHeaderText;
  const DoaCardWidget({
    super.key,
    this.headerText = '',
    this.subHeaderText = 'Versi Bali',
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFDF98FA),
              Color(0xFF9055FF),
            ],
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      headerText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 28,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subHeaderText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    // bottom line
                    Container(
                      height: 1,
                      width: 200,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
            // Image
            Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset(
                'lib/assets/images/doa_detail.png',
                width: 300, // Adjust the width to fit the container properly
                fit: BoxFit.cover, // Ensure the image covers the space properly
              ),
            ),
          ],
        ),
      ),
    );
  }
}
