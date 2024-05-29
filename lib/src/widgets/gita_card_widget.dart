import 'package:flutter/material.dart';

class GitaCardWidget extends StatelessWidget {
  final String headerText;
  final String subHeaderText;
  final String text;
  final String buttonText;
  final bool withImage;
  final bool withButton;
  final Function() onPress;
  const GitaCardWidget({
    super.key,
    this.headerText = '',
    required this.subHeaderText,
    required this.text,
    this.buttonText = 'Lanjutkan Membaca',
    this.withImage = true,
    this.withButton = true,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        // gradient color
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
        child: Row(
          mainAxisAlignment: withImage
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.center,
          crossAxisAlignment:
              withImage ? CrossAxisAlignment.end : CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.book,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          headerText,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      subHeaderText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // button lanjutkan membaca
                    if (withButton)
                      TextButton(
                        onPressed: onPress,
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 3)),
                        child: Text(
                          buttonText,
                          style: const TextStyle(
                            color: Colors.purple,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Image
            if (withImage)
              Image.asset(
                'lib/assets/images/gita.png',
                width: 100,
                height: 100,
              ),
          ],
        ),
      ),
    );
  }
}
