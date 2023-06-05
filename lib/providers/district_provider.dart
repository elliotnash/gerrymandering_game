import 'dart:math';
import 'dart:ui';

import 'package:gerrymandering_game/models/district.dart';
import 'package:gerrymandering_game/providers/brush_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'district_provider.g.dart';

@riverpod
class SelectedDistrict extends _$SelectedDistrict {
  @override
  int? build() => null;
}

@riverpod
class Districts extends _$Districts {
  @override
  Map<int, District> build() => {};

  void select(Offset position) {
    final brushSize = ref.read(brushSizeProvider).round();
    final r = brushSize/2;
    final selectedDistrict = ref.read(selectedDistrictProvider);

    final List<SelectedTile> newSelection = [
      for (int x = 0; x < brushSize; x++)
        for (int y = 0; y < brushSize; y++)
          if (sqrt(pow(x-r, 2)+pow(y-r, 2)) < r)
            SelectedTile(x: x, y: y),
    ];

    state = {
      selectedDistrict!: District(selection: newSelection)
    };
  }
}
