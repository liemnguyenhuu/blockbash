import 'package:blockbash/ui/settings_menu.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import '../game/block_bash_game.dart';
import '../game/components/hud_overlay.dart';
import '../game/components/overlay_elements.dart';
import 'game_over.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = BlockBashGame();

    return Scaffold(
      body: GameWidget(
        game: game,
        // 🔥 Khai báo toàn bộ overlays ở đây
        overlayBuilderMap: {
          "HUD": (context, game) => HudOverlay(game: game as BlockBashGame),
          "OverlayElements": (context, game) => OverlayElements(game: game as BlockBashGame),
          "SettingsMenu": (context, game) => SettingsMenu(game: game as BlockBashGame),
          'GameOver': (_, game) => GameOverScreen(game: game as BlockBashGame),
        },
        // 🔥 Các overlay sẽ bật khi game bắt đầu
        initialActiveOverlays: const ["HUD", "OverlayElements"],
      ),
    );
  }
}
