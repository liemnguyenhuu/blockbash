import 'package:flutter/material.dart';
import '../game/block_bash_game.dart';

class NextBlocksOverlay extends StatelessWidget {
  final BlockBashGame game;

  const NextBlocksOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10,
      right: 10,
      child: Opacity(
        opacity: 0.4,
        child: Image.asset(
          "assets/ui/next_blocks.png",
          width: 80,
        ),
      ),
    );
  }
}
