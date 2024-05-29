import 'package:flutter/material.dart';

class GitaCardWidget extends StatefulWidget {
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
  State<GitaCardWidget> createState() => _GitaCardWidgetState();
}

class _GitaCardWidgetState extends State<GitaCardWidget> {
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
              // 863ED5 to 994FF8
              Color.fromARGB(255, 176, 116, 255),
              Color(0xFF863ED5),
            ],
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: widget.withImage
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.start,
          crossAxisAlignment: widget.withImage
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.center,
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
                          widget.headerText,
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
                      widget.subHeaderText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      widget.text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // button lanjutkan membaca
                    if (widget.withButton)
                      TextButton(
                        onPressed: widget.onPress,
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 3)),
                        child: Text(
                          widget.buttonText,
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
            if (widget.withImage)
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
