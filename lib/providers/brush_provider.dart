import 'dart:math';

import 'package:gerrymandering_game/const.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'brush_provider.g.dart';

@riverpod
class BrushSize extends _$BrushSize {
  @override
  double build() => kDefaultBrushSize;

  void scroll(double dy) {
    state = (state + dy).clamp(kMinBrushSize, kMaxBrushSize);
  }
}
