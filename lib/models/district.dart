import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vector_math/vector_math.dart';
import 'package:gerrymandering_game/util/vector_converter.dart';

part 'district.freezed.dart';
part 'district.g.dart';

@freezed
class District with _$District {
  const District._();

  const factory District({
    required List<SelectedTile> selection,
  }) = _District;

  factory District.fromJson(Map<String, dynamic> json)
  => _$DistrictFromJson(json);
}

@freezed
class SelectedTile with _$SelectedTile {
  const SelectedTile._();

  const factory SelectedTile({
    required int x,
    required int y,
  }) = _SelectedTile;

  factory SelectedTile.fromJson(Map<String, dynamic> json)
  => _$SelectedTileFromJson(json);
}

