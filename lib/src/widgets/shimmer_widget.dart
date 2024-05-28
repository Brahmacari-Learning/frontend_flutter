import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final double roundedRadius;

  const CustomShimmerWidget({
    super.key,
    required this.width,
    required this.height,
    required this.roundedRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color.fromARGB(255, 210, 210, 210),
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(roundedRadius),
            color: Colors.grey[300]),
      ),
    );
  }
}
