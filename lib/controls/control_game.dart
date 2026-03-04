/*import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> confirmAndExitGame({
  required BuildContext context,
  required int gameId,
  required List<List<int>> currentBoard,
  required int elapsedSeconds,
  required int mistakes,
  required Future<void> Function({
  required int gameId,
  required List<List<int>> currentBoard,
  required int elapsedTime,
  required int mistakes,
  }) saveGameProgress,
}) async {
  final confirmExit = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("exitConfirmationTitle"),
      content: Text("exitConfirmationMessage"),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text('cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text("confirm"),
        ),
      ],
    ),
  );

  if (confirmExit == true) {
    try {
      await saveGameProgress(
        gameId: gameId,
        currentBoard: currentBoard,
        elapsedTime: elapsedSeconds,
        mistakes: mistakes,
      );
    } catch (e) {
      debugPrint('❌ Lỗi khi lưu tiến trình: $e');
    }

    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }
  }
}

void handleGameCompleted({
  required BuildContext context,
  required VoidCallback onLoadNewGame,
  required Future<void> Function() loadAd,
}) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text("🎉 Congratulations!"),
      content: const Text("You've completed the puzzle!"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop();

            loadAd().then((_) {
              onLoadNewGame();
            });
          },
          child: const Text("OK"),
        ),
      ],
    ),
  );
} */


