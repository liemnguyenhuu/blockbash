/*import 'package:flutter/cupertino.dart';

class GameState extends ChangeNotifier {
  bool hintsEnabled = true;
  int hintRemaining = 0;

  void initHints(String level) {
    // Nếu disable hint → 0 luôn
    if (!hintsEnabled) {
      hintRemaining = 0;
      return;
    }

    // Nếu enable → gán theo level
    switch (_normalizeLevel(level)) {
      case 'easy':
        hintRemaining = 1;
        break;
      case 'medium':
        hintRemaining = 2;
        break;
      case 'hard':
        hintRemaining = 3;
        break;
      case 'expert':
        hintRemaining = 4;
        break;
      case 'master':
        hintRemaining = 5;
        break;
      case 'extreme':
        hintRemaining = 6;
        break;
      default:
        hintRemaining = 1;
    }
    notifyListeners();
  }

  void toggleHints(bool enabled, {String? level}) {
    hintsEnabled = enabled;
    if (!enabled) {
      hintRemaining = 0;
    } else {
      // Khi bật lại thì gán theo level nếu có
      if (level != null) {
        initHints(level);
      }
    }
    notifyListeners();
  }

  String _normalizeLevel(String? level) {
    return level?.toLowerCase().trim() ?? "easy";
  }
}
*/