import 'package:gerrymandering_game/models/level.dart';
import 'package:gerrymandering_game/models/party.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'level_provider.g.dart';

@riverpod
class CurrentLevel extends _$CurrentLevel {
  @override
  Level build() {
    return Level.generate();
  }
  void generate(Party party, int difficulty) {
    state = Level.generate(party, difficulty);
  }
}
