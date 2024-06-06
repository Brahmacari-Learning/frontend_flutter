import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  final String? avatarUrl;
  final String name;
  final int radius;
  const AvatarWidget(
      {super.key,
      required this.avatarUrl,
      required this.name,
      this.radius = 30});

  @override
  Widget build(BuildContext context) {
    return (avatarUrl != null)
        ? CircleAvatar(
            backgroundImage: NetworkImage(
              avatarUrl!,
            ),
            radius: radius.toDouble(),
          )
        : CircleAvatar(
            radius: radius.toDouble(),
            child: Text(
              name[0].toUpperCase(),
            ),
          );
  }
}
