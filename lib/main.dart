import 'package:flame/game.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  final game = FlameGame();
  runApp(GameWidget(game: game));
}
