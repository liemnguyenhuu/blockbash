import '../game/block_bash_game.dart';
import 'package:flutter/material.dart';

class GameOverScreen extends StatelessWidget {
  final BlockBashGame game;

  const GameOverScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "GAME OVER",
              style: TextStyle(fontSize: 28, color: Colors.white),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                game.overlays.remove('GameOver');
                Future.delayed(const Duration(milliseconds: 150), () {
                  game.resumeEngine();
                  game.resetGame();
                });
              },
              child: const Text("Play Again"),
            )
          ],
        ),
      ),
    );
  }
}
