import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gerrymandering_game/const.dart';
import 'package:gerrymandering_game/models/level.dart';
import 'package:gerrymandering_game/providers/level_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vector_math/vector_math.dart' as v;

Future<void> main() async {
  runApp(const App());
}

class Tile {
  final int x;
  final int y;
  final int population;
  final double democrat;

  Tile({
    required this.x,
    required this.y,
    required this.population,
    required this.democrat,
  });

  double get republican => 1 - democrat;
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProviderScope(
      child: MaterialApp(
        home: GerrymanderingGame()
      ),
    );
  }
}

class GerrymanderingGame extends StatefulWidget {
  const GerrymanderingGame({super.key});

  @override
  State<StatefulWidget> createState() => _GerrymanderingGameState();
}

class _GerrymanderingGameState extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Map()
    );
  }
}

class Map extends StatefulWidget {
  const Map({super.key});

  @override
  State<StatefulWidget> createState() => _MapState();
}

class _MapState extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {
    // return CustomPaint(painter: MapPainter());
    return LayoutBuilder(
      // Inner yellow container
      builder: (_, constraints) => Container(
        width: constraints.widthConstraints().maxWidth,
        height: constraints.heightConstraints().maxHeight,
        color: Colors.black,
        child: Consumer(
          builder: (context, ref, _) { 
            return LevelWidget(ref.watch(currentLevelProvider));
          },
        )
      ),
    );
  }
}

class LevelWidget extends StatelessWidget {
  final Level level;
  const LevelWidget(this.level, {super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: MapPainter(level));
  }
}

class City {
  final v.Vector2 position;
  final double size;
  City(this.position, this.size);
}

class MapPainter extends CustomPainter {
  static final _rand = Random();
  final Level level;
  MapPainter(this.level);

  @override
  void paint(Canvas canvas, Size size) {
    final tileSize = min(size.width/kMapWidth, size.height/kMapHeight);

    // draw tiles
    for (final tile in level.tiles) {
      final paint = Paint()..color = Color.fromARGB(255, (tile.republican*255).round(), 0, (tile.democrat*255).round());
      canvas.drawRect(Rect.fromLTWH(tile.x * tileSize, tile.y * tileSize, tileSize, tileSize), paint);
    }

    // draw population clusters
    // final maxPopulation = tiles.map((e) => e.population).reduce(max);
    // for (final tile in tiles) {
    //   final color = ((tile.population/maxPopulation)*255).toInt();
    //   final paint = Paint()..color = Color.fromARGB(255, color, color, color);
    //   canvas.drawRect(Rect.fromLTWH(tile.x * tileSize, tile.y * tileSize, tileSize, tileSize), paint);
    // }

    // draw cities
    // for (final city in cities) {
    //   canvas.drawCircle(Offset(tileSize * city.position.x, tileSize * city.position.y), city.size*70, Paint()..color = Colors.green);
    // }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

}

//hiiiiiiiiii im making the most out of my one comment askskjgkhfkhfshkskhkhgshjksfgk hiiii im so tired no im not done yet dont take it away stop touching my elbow i just wanna write
// class Map extends PositionComponent {
//   Map() : super(priority: 1);
//
//   static final _paint = Paint()..color = Colors.white;
//   static final _rand = Random();
//
//   late final List<Tile> tiles;
//   late final List<(Vector2, double)> cities;
//
//   @override
//   void render(Canvas canvas) {
//     final tileSize = min(size.x/kMapWidth, size.y/kMapHeight);
//
//     // canvas.drawRect(size.toRect(), _paint);
//
//     // draw tiles
//     for (final tile in tiles) {
//       final paint = Paint()..color = Color.fromARGB(255, ((tile.republicans/tile.population)*255).round(), 0, ((tile.democrats/tile.population)*255).round());
//       canvas.drawRect(Rect.fromLTWH(tile.x * tileSize, tile.y * tileSize, tileSize, tileSize), paint);
//     }
//
//     // draw pop clusters
//     for (final (loc, s) in cities) {
//       canvas.drawCircle(Offset(tileSize * kMapWidth * loc.x, tileSize * kMapHeight * loc.y), s*70, _paint);
//     }
//   }
//
//   @override
//   void onLoad() {
//
//     final numCities = (_rand.nextDouble() * 4 + 10).toInt();
//     print(numCities);
//     cities = [
//       for (var i = 0; i < numCities; i++)
//         (Vector2.random(_rand), _rand.nextDouble())
//     ];
//
//     tiles = [
//       for (var x = 0; x < kMapWidth; x++)
//         for (var y = 0; y < kMapHeight; y++)
//           () {
//             return Tile(
//               x: x,
//               y: y,
//               democrats: _rand.nextInt(100),
//               republicans: _rand.nextInt(100),
//             );
//           }()
//     ];
//   }
// }
//
// class GerrymanderingGame extends FlameGame {
//   late Player player;
//   late Map map;
//
//   @override
//   void render(Canvas canvas) {
//     super.render(canvas);
//     map.size = size;
//   }
//
//   @override
//   void onLoad() {
//     super.onLoad();
//
//     // mouseCursor = SystemMouseCursors.none;
//
//     // player = Player()
//     //   ..position = size / 2
//     //   ..width = 50
//     //   ..height = 100
//     //   ..anchor = Anchor.center;
//     //
//     // add(player);
//
//     map = Map()..size = size;
//     add(map);
//
//   }
// }
