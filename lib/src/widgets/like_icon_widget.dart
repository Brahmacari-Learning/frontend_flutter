import 'package:flutter/material.dart';

class LikeIcon extends StatelessWidget {
  final bool isLiked;
  const LikeIcon({super.key, required this.isLiked});

  @override
  Widget build(BuildContext context) {
    return isLiked
        ? const Icon(Icons.favorite, color: Colors.purple)
        : const Icon(Icons.favorite_border, color: Colors.purple);
  }
}

class LikeIconWithCount extends StatelessWidget {
  final bool isLiked;
  final int likesCount;

  const LikeIconWithCount({
    super.key,
    required this.isLiked,
    required this.likesCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        LikeIcon(
          isLiked: isLiked,
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 8,
          ),
          child: Text(
            '$likesCount',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.purple,
              fontWeight: FontWeight.w500,
            ),
          ),
        )
      ],
    );
  }
}
