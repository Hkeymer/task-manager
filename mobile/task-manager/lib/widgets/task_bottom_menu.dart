import 'package:flutter/material.dart';

class TaskBottomMenu extends StatelessWidget {
  final VoidCallback onFavorite;
  final VoidCallback onShare;
  final VoidCallback onDelete;
  final VoidCallback onComplete;

  const TaskBottomMenu({
    super.key,
    required this.onFavorite,
    required this.onShare,
    required this.onDelete,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(icon: const Icon(Icons.star_border, color: Colors.yellow), onPressed: onFavorite),
          IconButton(icon: const Icon(Icons.share, color: Colors.yellow), onPressed: onShare),
          IconButton(icon: const Icon(Icons.delete, color: Colors.redAccent), onPressed: onDelete),
          IconButton(icon: const Icon(Icons.check_circle_outline, color: Colors.green), onPressed: onComplete),
        ],
      ),
    );
  }
}
