import 'dart:math';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gerrymandering_game/const.dart';
import 'package:gerrymandering_game/models/level.dart';
import 'package:gerrymandering_game/models/party.dart';
import 'package:gerrymandering_game/providers/brush_provider.dart';
import 'package:gerrymandering_game/providers/district_provider.dart';
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
    return ProviderScope(
      child: MaterialApp(
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData(
          brightness: Brightness.dark,
        ),
        home: const GerrymanderingGame()
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
      backgroundColor: Colors.black,
      body: Map()
    );
  }
}

class Map extends ConsumerStatefulWidget {
  const Map({super.key});

  @override
  ConsumerState<Map> createState() => _MapState();
}

class _MapState extends ConsumerState<Map> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text(
                "The Gerry Mander",
                style: TextStyle(
                  fontSize: 30
                ),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Sidebar(),
                  const SizedBox(width: 16),
                  Flexible(child: LevelWidget(ref.watch(currentLevelProvider))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Sidebar extends ConsumerWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDistrict = ref.watch(selectedDistrictProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (int i = 0; i < kNumDistricts; i++)
          FilledButton(
            onPressed: () {
              ref.read(selectedDistrictProvider.notifier).state = i;
            },
            style: OutlinedButton.styleFrom(
                backgroundColor: i == selectedDistrict ? Colors.green : Colors.transparent
            ),
            child: Text("District ${i+1}"),
          )
      ],
    );
  }
}

class LevelWidget extends ConsumerStatefulWidget {
  final Level level;
  const LevelWidget(this.level, {super.key});

  @override
  ConsumerState<LevelWidget> createState() => _LevelWidgetState();
}

class _LevelWidgetState extends ConsumerState<LevelWidget> {
  Offset? pointer;

  void movePointer(Offset? position) {
    if (position == null) {
      setState(() => pointer = null);
      return;
    }

    RenderBox rb = context.findRenderObject() as RenderBox;
    final pos = rb.globalToLocal(position);

    setState(() {
      // Save the position of the cursor when it moves
      pointer = pos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      // Inner yellow container
      builder: (_, constraints) {
        final widthC = constraints.maxWidth / kMapWidth;
        final heightC = constraints.maxHeight / kMapHeight;
        final c = min(widthC, heightC);
        final width = c*kMapWidth;
        final height = c*kMapHeight;

        final brushSize = ref.watch(brushSizeProvider).round();
        final cursorSize = brushSize * c;

        return SizedBox(
          width: width,
          height: height,
          child: MouseRegion(
              cursor: SystemMouseCursors.none,
              onExit: (event) => movePointer(null),
              child: Listener(
                onPointerHover: (event) => movePointer(event.position),
                onPointerMove: (event) => movePointer(event.position),
                onPointerSignal: (event) {
                  if (event is PointerScrollEvent) {
                    ref.read(brushSizeProvider.notifier)
                        .scroll(event.scrollDelta.dy*kBrushScrollModifier);
                  }
                },
                onPointerPanZoomUpdate: (PointerPanZoomUpdateEvent event) =>
                    ref.read(brushSizeProvider.notifier)
                        .scroll(event.panDelta.dy*kBrushScrollModifier),
                child: Stack(
                  children: [
                    Builder(
                      builder: (context) {
                        return ClipRRect(
                          child: ImageFiltered(
                            imageFilter: ImageFilter.blur(sigmaX: kMapBlur*c, sigmaY: kMapBlur*c),
                            enabled: false,
                            child: CustomPaint(
                              size: Size(width, height),
                              painter: MapPainter(widget.level),
                            ),
                          ),
                        );
                      }
                    ),
                    if (pointer != null)
                      Positioned(
                        left: pointer!.dx - (cursorSize/2),
                        top: pointer!.dy - (cursorSize/2),
                        child: Container(
                          height: cursorSize,
                          width: cursorSize,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(cursorSize/2)),
                            border: Border.all(
                              width: 2,
                              color: Colors.white,
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              )
          ),
        );
      }
    );
  }
}

class CustomCursor extends StatefulWidget {
  final Widget child;

  const CustomCursor({required this.child, super.key});

  @override
  State<CustomCursor> createState() => _CustomCursorState();
}

class _CustomCursorState extends State<CustomCursor> {
  Offset? pointer;

  void movePointer(Offset? position) {
    if (position == null) {
      setState(() => pointer = null);
      return;
    }

    RenderBox rb = context.findRenderObject() as RenderBox;
    final pos = rb.globalToLocal(position);

    setState(() {
      // Save the position of the cursor when it moves
      pointer = pos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.none,
      child: Listener(
        onPointerHover: (event) => movePointer(event.position),
        onPointerMove: (event) => movePointer(event.position),
        child: Stack(
          children: [
            if (pointer != null)
              widget.child,
              Positioned(
                left: pointer!.dx,
                top: pointer!.dy,
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(25)),
                    border: Border.all(
                      width: 2,
                      color: Colors.white,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
              ),
          ],
        ),
      )
       // child: GestureDetector(
       //    child: Icon(
       //      Icons.add_comment,
       //      size: 20,
       //    ),
       //    onTap: () {},
       //  ),
       //  child: Stack(
       //    children: [
       //      // widget.child,
       //      if (position != null)
       //        AnimatedPositioned(
       //          duration: const Duration(milliseconds: 100),
       //          left: position!.dx,
       //          top: position!.dy,
       //          child: Container(width: 10, height: 10, color: Colors.red,),
       //        ),
       //    ],
       //  )
    );
  }
}

class City {
  final v.Vector2 position;
  final double size;
  City(this.position, this.size);
}

class MapPainter extends CustomPainter {
  final Level level;
  MapPainter(this.level);

  @override
  void paint(Canvas canvas, Size size) {
    final tileSize = min(size.width/kMapWidth, size.height/kMapHeight);

    // draw tiles
    for (final tile in level.tiles) {
      final paint = Paint()..color = Color.fromARGB(255, (tile.republican*255).round(), 0, (tile.democrat*255).round());
      canvas.drawRect(Rect.fromLTWH(tile.x * tileSize, tile.y * tileSize, tileSize+kMapOverlap, tileSize+kMapOverlap), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

}
