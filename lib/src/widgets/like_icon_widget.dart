import 'package:flutter/material.dart';

class LikeIcon extends StatelessWidget {
  final bool isLiked;
  const LikeIcon({super.key, required this.isLiked});

  @override
  Widget build(BuildContext context) {
    return isLiked
        ? const Icon(Icons.favorite, color: Color(0xFFB95A92))
        : const Icon(Icons.favorite_border, color: Color(0xFFB95A92));
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
              color: Color(0xFFB95A92),
              fontWeight: FontWeight.w500,
            ),
          ),
        )
      ],
    );
  }
}
