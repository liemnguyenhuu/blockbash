import 'package:flutter/material.dart';
import '../game/block_bash_game.dart';

class SettingsMenu extends StatefulWidget {
  final BlockBashGame game;
  const SettingsMenu({super.key, required this.game});

  @override
  State<SettingsMenu> createState() => _SettingsMenuState();
}

class _SettingsMenuState extends State<SettingsMenu>
    with SingleTickerProviderStateMixin {

  late AnimationController anim;
  late Animation<double> scaleAnim;

  @override
  void initState() {
    super.initState();

    anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    scaleAnim = CurvedAnimation(
      parent: anim,
      curve: Curves.easeOutBack,
    );

    anim.forward();
  }

  @override
  void dispose() {
    anim.dispose();
    super.dispose();
  }

  void closeMenu() {
    anim.reverse().then((_) {
      widget.game.overlays.remove("SettingsMenu");
      widget.game.overlays.add("HUD");
      widget.game.overlays.add("OverlayElements");
      widget.game.resumeEngine();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.65),
      child: Center(
        child: ScaleTransition(
          scale: scaleAnim,
          child: Container(
            width: 330,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                // Title
                const Text(
                  "SETTINGS",
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                // SOUND
                SwitchListTile(
                  title: const Text("Sound", style: TextStyle(color: Colors.white)),
                  value: widget.game.soundOn,
                  onChanged: (v) {
                    setState(() => widget.game.soundOn = v);
                  },
                  activeColor: Colors.greenAccent,
                ),

                // VIBRATION
                SwitchListTile(
                  title: const Text("Vibration", style: TextStyle(color: Colors.white)),
                  value: widget.game.vibrationOn,
                  onChanged: (v) {
                    setState(() => widget.game.vibrationOn = v);
                  },
                  activeColor: Colors.greenAccent,
                ),

                const Divider(color: Colors.white24, height: 30),

                // THEME SELECTOR
                Row(
                  children: [
                    const Text("Theme:", style: TextStyle(color: Colors.white)),
                    const SizedBox(width: 14),
                    DropdownButton<String>(
                      value: widget.game.theme,
                      dropdownColor: Colors.grey.shade900,
                      items: const [
                        DropdownMenuItem(value: "dark", child: Text("Dark", style: TextStyle(color: Colors.white))),
                        DropdownMenuItem(value: "light", child: Text("Light", style: TextStyle(color: Colors.white))),
                        DropdownMenuItem(value: "neon", child: Text("Neon", style: TextStyle(color: Colors.white))),
                      ],
                      onChanged: (v) {
                        if (v != null) {
                          setState(() => widget.game.theme = v);
                        }
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // GAME MODE SELECTOR
                Row(
                  children: [
                    const Text("Game mode:", style: TextStyle(color: Colors.white)),
                    const SizedBox(width: 14),
                    DropdownButton<String>(
                      value: widget.game.mode,
                      dropdownColor: Colors.grey.shade900,
                      items: const [
                        DropdownMenuItem(value: "classic", child: Text("Classic", style: TextStyle(color: Colors.white))),
                        DropdownMenuItem(value: "time", child: Text("Time Attack", style: TextStyle(color: Colors.white))),
                        DropdownMenuItem(value: "hard", child: Text("Hard Mode", style: TextStyle(color: Colors.white))),
                      ],
                      onChanged: (v) {
                        if (v != null) {
                          setState(() => widget.game.mode = v);
                        }
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                // CLOSE BUTTON
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                  ),
                  onPressed: closeMenu,
                  child: const Text("Close", style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
