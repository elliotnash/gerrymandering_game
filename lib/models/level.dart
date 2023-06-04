import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gerrymandering_game/const.dart';
import 'package:gerrymandering_game/models/city.dart';
import 'package:gerrymandering_game/models/party.dart';
import 'package:gerrymandering_game/models/tile.dart';
import 'package:vector_math/vector_math.dart';

import '../util/math.dart';

part 'level.freezed.dart';
part 'level.g.dart';

final _rand = Random();

@freezed
class Level with _$Level {
  const Level._();

  const factory Level({
    required List<Tile> tiles,
    required List<City> cities,
    required Party party,
    required int difficulty
  }) = _Level;

  int get population => tiles.map((e) => e.population).reduce(sum);
  int get democrats => tiles.map((e) => e.democrats).reduce(sum);
  int get republicans => tiles.map((e) => e.republicans).reduce(sum);

  factory Level.generate([Party party = Party.democrat, int difficulty = 2]) {
    final int bigCities = (party == Party.democrat ? 9 : 1) - (difficulty*2);
    const int smallCities = 40;
    final cities = [
      for (var i = 0; i < bigCities; i++)
        City(Vector2(_rand.nextDouble()*kMapWidth, _rand.nextDouble()*kMapHeight), _rand.nextDouble()*0.5+0.5),
      for (var i = 0; i < smallCities; i++)
        City(Vector2(_rand.nextDouble()*kMapWidth, _rand.nextDouble()*kMapHeight), _rand.nextDouble()*0.2+0.1)
    ];

    final List<double> popModifiers = [];

    Tile generateTile(int x, int y) {
      final position = Vector2(x.toDouble(), y.toDouble());
      final popModifier = cities.map((city) {
        final distance = position.distanceTo(city.position);
        return 2/(1+pow(e, ((0.2-city.size*0.1)*distance+3*(1-city.size))));
      }).reduce(sum);
      popModifiers.add(popModifier);

      final demModifier = (popModifier*2).clamp(0, 1);

      final cityPopulation = popModifier * 20000 * (_rand.nextDouble()*0.2+0.9);
      final ruralPopulation = _rand.nextDouble() * 225 + 50;

      final ruralDemocrat = _rand.nextDouble() * 0.2 + 0.1;
      final cityDemocrat = _rand.nextDouble() * 0.2 + 0.6;

      return Tile(
        x: x,
        y: y,
        population: (ruralPopulation+cityPopulation).toInt(),
        democrat: ruralDemocrat * (1-demModifier) + cityDemocrat * demModifier,
      );
    }

    final tiles = [
      for (var x = 0; x < kMapWidth; x++)
        for (var y = 0; y < kMapHeight; y++)
          generateTile(x, y)
    ];

    return Level(tiles: tiles, cities: cities, party: party, difficulty: difficulty);
  }

  factory Level.fromJson(Map<String, dynamic> json)
      => _$LevelFromJson(json);
}
