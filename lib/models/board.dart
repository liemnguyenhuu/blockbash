import 'dart:ui';
import 'package:flame/components.dart';
import 'game_block.dart';

class Board {
  final int size;
  late List<List<int>> grid;
  late List<List<Color?>> colorGrid;
  Board({this.size = 10}) {
    grid = List.generate(size, (_) => List.filled(size, 0));
    colorGrid = List.generate(size, (_) => List.filled(size, null));
  }
  Board clone() {
    final copy = Board(size: size);

    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        copy.grid[y][x] = grid[y][x];
        copy.colorGrid[y][x] = colorGrid[y][x];
      }
    }

    return copy;
  }
  bool canPlace(GameBlock block, int gx, int gy) {
    if (gx < 0 || gy < 0) return false;
    if (gx + block.width  > size) return false;
    if (gy + block.height > size) return false;

    for (int y = 0; y < block.height; y++) {
      for (int x = 0; x < block.width; x++) {
        if (block.shape[y][x] == 1) {
          int bx = gx + x;
          int by = gy + y;

          if (bx < 0 || by < 0 || bx >= size || by >= size) return false;
          if (grid[by][bx] == 1) return false;
        }
      }
    }
    return true;
  }

  void placeBlock(GameBlock block, int gx, int gy) {
    for (int y = 0; y < block.height; y++) {
      for (int x = 0; x < block.width; x++) {
        if (block.shape[y][x] == 1) {
          grid[gy + y][gx + x] = 1;
          colorGrid[gy + y][gx + x] = block.color;
        }
      }
    }
  }

  int clearLines() {
    int cleared = 0;

    // Xóa hàng đầy
    for (int y = 0; y < size; y++) {
      if (grid[y].every((c) => c == 1)) {
        grid[y] = List.filled(size, 0);
        cleared++;
      }
    }

    // Xóa cột đầy
    for (int x = 0; x < size; x++) {
      bool full = true;
      for (int y = 0; y < size; y++) {
        if (grid[y][x] == 0) full = false;
      }
      if (full) {
        for (int y = 0; y < size; y++) {
          grid[y][x] = 0;
        }
        cleared++;
      }
    }

    return cleared;
  }

  List<Vector2> getClearedCells() {
    List<Vector2> cells = [];

    // rows
    for (int y = 0; y < size; y++) {
      if (grid[y].every((e) => e == 1)) {
        for (int x = 0; x < size; x++) {
          cells.add(Vector2(x.toDouble(), y.toDouble()));
        }
      }
    }

    // cols
    for (int x = 0; x < size; x++) {
      bool full = true;
      for (int y = 0; y < size; y++) {
        if (grid[y][x] == 0) full = false;
      }
      if (full) {
        for (int y = 0; y < size; y++) {
          cells.add(Vector2(x.toDouble(), y.toDouble()));
        }
      }
    }
    return cells;
  }

  int applyClear(List<Vector2> cells) {
    for (final c in cells) {
      final y = c.y.toInt();
      final x = c.x.toInt();
      grid[y][x] = 0;
      colorGrid[y][x] = null;
    }
    return cells.length;
  }
  bool canPlaceAnywhere(GameBlock block) {
    for (int gy = 0; gy < size; gy++) {
      for (int gx = 0; gx < size; gx++) {
        if (canPlace(block, gx, gy)) {
          return true; // chỉ cần tìm được 1 vị trí hợp lệ
        }
      }
    }
    return false; // không nơi nào đặt được → block này vô dụng
  }
  bool isRowFull(int y) {
    for (int x = 0; x < size; x++) {
      if (grid[y][x] == 0) return false;
    }
    return true;
  }

  bool isColFull(int x) {
    for (int y = 0; y < size; y++) {
      if (grid[y][x] == 0) return false;
    }
    return true;
  }

}
