import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tile.freezed.dart';
part 'tile.g.dart';

@freezed
class Tile with _$Tile {
  const Tile._();

  const factory Tile({
    required int x,
    required int y,
    required int population,
    required double democrat,
  }) = _Tile;

  double get republican => 1 - democrat;

  int get democrats => (population*democrat).toInt();
  int get republicans => (population*republican).toInt();

  factory Tile.fromJson(Map<String, dynamic> json)
  => _$TileFromJson(json);
}
