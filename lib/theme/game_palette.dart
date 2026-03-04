import 'package:flutter/material.dart';
class GamePalette {
  final Color outerbackground;     // nền ngoài
  final Color boardbackground;  //+ board
  final Color emptyCell;      // ô trống
  final Color filledCell;     // ô đã đặt
  final Color emptyLight;
  final Color emptyDark;
  final Color filledLight;
  final Color filledDark;
  final Color highlight;

  GamePalette({
    required this.outerbackground,
    required this.boardbackground,
    required this.emptyCell,
    required this.filledCell,
    required this.emptyLight,
    required this.emptyDark,
    required this.filledLight,
    required this.filledDark,
    required this.highlight,
  });

  factory GamePalette.fromBase(Color base) {
    final baseHsl = HSLColor.fromColor(base);

    // 1️⃣ EMPTY — tối + giảm saturation
    final emptyHsl = baseHsl
        .withLightness((baseHsl.lightness - 0.30).clamp(0, 1))
        .withSaturation((baseHsl.saturation * 0.6).clamp(0, 1));
    final highlightHsl = baseHsl
        .withHue((baseHsl.hue + 60) % 360)
        .withLightness((baseHsl.lightness + 0.25).clamp(0, 1))
        .withSaturation((baseHsl.saturation + 0.30).clamp(0, 1));

    final highlight = highlightHsl.toColor();

    //final empty = emptyHsl.toColor();

    // 2️⃣ FILLED — XOAY HUE + đậm hơn
    final filledHsl = baseHsl
        .withHue((baseHsl.hue + 35) % 360) // 🔥 CỐT LÕI
        .withLightness((baseHsl.lightness - 0.12).clamp(0, 1))
        .withSaturation((baseHsl.saturation + 0.25).clamp(0, 1));

    final filled = filledHsl.toColor();

    return GamePalette(
      outerbackground: base,
      boardbackground: Colors.black45,
      emptyCell: Colors.black45,
      emptyLight: _lighter(Colors.black45, 0.06),
      emptyDark: _darker(Colors.black45, 0.08),
      filledCell: filled,
      filledLight: _lighter(filled, 0.20),
      filledDark: _darker(filled, 0.25),
      highlight: highlight,
    );
  }

  static Color _lighter(Color c, double v) =>
      HSLColor.fromColor(c)
          .withLightness((HSLColor.fromColor(c).lightness + v).clamp(0, 1))
          .toColor();

  static Color _darker(Color c, double v) =>
      HSLColor.fromColor(c)
          .withLightness((HSLColor.fromColor(c).lightness - v).clamp(0, 1))
          .toColor();
}
