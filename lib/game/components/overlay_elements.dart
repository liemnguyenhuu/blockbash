import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../block_bash_game.dart';

class OverlayElements extends StatelessWidget {
  final BlockBashGame game;
  const OverlayElements({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;
    return ValueListenableBuilder<double>(
      valueListenable: game.hudHeightNotifier,
      builder: (_, hudH, __) {
        return Stack(
          children: [
            Positioned(
              top: topInset + 4,
              left: 8,
              child: IconButton(
                iconSize: 20,
                color: Colors.white,
                icon: const Icon(Icons.close),
                onPressed: () {
                  game.pauseEngine();
                  SystemNavigator.pop();
                },
              ),
            ),

            Positioned(
              top: topInset + 4,
              right: 8,
              child: IconButton(
                iconSize: 30,
                color: Colors.white,
                icon: const Icon(Icons.settings),
                onPressed: () {
                  game.overlays.add("SettingsMenu");
                  game.overlays.remove("HUD");
                },
              ),
            ),

            Positioned(
              bottom: 16 + MediaQuery.of(context).padding.bottom,
              left: 16,
              right: 16,
              child: ValueListenableBuilder<double>(
                valueListenable: game.energy,
                builder: (_, energy, __) => LinearProgressIndicator(
                  value: energy,
                  backgroundColor: Colors.white24,
                  color: Colors.greenAccent,
                  minHeight: 12,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/*class OverlayElements extends StatelessWidget {
  final BlockBashGame game;
  const OverlayElements({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Combo animation center
        /*Positioned(
          top: 80,
          left: 0,
          right: 0,
          child: Center(
            child: ValueListenableBuilder<int>(
              valueListenable: game.combo,
              builder: (_, combo, __) => AnimatedScale(
                scale: combo > 1 ? 1.5 : 1.0,
                duration: const Duration(milliseconds: 250),
                child: combo > 1
                    ? Text(
                  "Combo x$combo!",
                  style: const TextStyle(
                    color: Colors.yellow,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(blurRadius: 10, color: Colors.black, offset: Offset(2, 2)),
                    ],
                  ),
                )
                    : const SizedBox.shrink(),
              ),
            ),
          ),
        ),*/
        Positioned(
          top: game.hudHeight + 8,//top: 10,
          left: 8,//left: 28,
          child: IconButton(
            iconSize: 20,
            color: Colors.white,
            icon: const Icon(Icons.close),
            onPressed: () {
              game.pauseEngine();

              //Navigator.of(context).pop(); // CÁCH 1: Thoát về màn hình trước
               SystemNavigator.pop();// CÁCH 2: Thoát App hoàn toàn (nếu muốn)
            },
          ),
        ),

        // Pause button top-right
        Positioned(
          top: game.hudHeight + 8,//top: 10,
          right: 8,
          child: IconButton(
            iconSize: 30,
            color: Colors.white,
            icon: const Icon(Icons.settings),
            onPressed: () {
              game.overlays.add("SettingsMenu");
              game.overlays.remove("HUD");
            },
          ),
        ),

        // Energy bar bottom
        Positioned(
          bottom: 16 + MediaQuery.of(context).padding.bottom,
          left: 16,
          right: 16,
          child: ValueListenableBuilder<double>(
            valueListenable: game.energy,
            builder: (_, energy, __) => LinearProgressIndicator(
              value: energy,
              backgroundColor: Colors.white24,
              color: Colors.greenAccent,
              minHeight: 12,
            ),
          ),
        ),
      ],
    );
  }
}*/
