import 'package:flutter/material.dart';
import '../block_bash_game.dart';

class HudOverlay extends StatefulWidget {
  final BlockBashGame game;

  const HudOverlay({super.key, required this.game});

  @override
  State<HudOverlay> createState() => _HudOverlayState();
}

class _HudOverlayState extends State<HudOverlay> {
  final key = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = key.currentContext;
      if (ctx != null) {
        final height = ctx.size?.height ?? 0;
        widget.game.setHudHeight(height); // Chỉ đo top bar thôi
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;
    const double iconBarHeight = 44; // chiều cao icon area
    return Container(
      key: key,
      margin: EdgeInsets.only(
        top: topInset + iconBarHeight + 4,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ValueListenableBuilder<int>(
            valueListenable: widget.game.score,
            builder: (_, score, __) => Text(
              "Score: $score",
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          ValueListenableBuilder<int>(
            valueListenable: widget.game.level,
            builder: (_, level, __) => Text(
              "Level: $level",
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          ValueListenableBuilder<int>(
            valueListenable: widget.game.time,
            builder: (_, time, __) => Text(
              "Time: ${time}s",
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
