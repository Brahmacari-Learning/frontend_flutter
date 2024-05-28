import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  final String? avatarUrl;
  final String name;
  const AvatarWidget({super.key, required this.avatarUrl, required this.name});

  @override
  Widget build(BuildContext context) {
    return (avatarUrl != null)
        ? CircleAvatar(
            backgroundImage: NetworkImage(
              avatarUrl!,
            ),
          )
        : CircleAvatar(
            child: Text(
              name[0].toUpperCase(),
            ),
          );
  }
}
