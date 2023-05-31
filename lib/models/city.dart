import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vector_math/vector_math.dart';
import 'package:gerrymandering_game/util/vector_converter.dart';

part 'city.freezed.dart';
part 'city.g.dart';

@freezed
class City with _$City {
  const City._();

  const factory City(@Vector2Converter() Vector2 position, double size) = _City;

  factory City.fromJson(Map<String, dynamic> json)
  => _$CityFromJson(json);
}
// im making a comment hiiiiii elliot didnt like my coding skills they have no appreciation for my talents and they said that if i did this for a few more minutes we wouldnt be friends but i know thats not true because they need me to give them food