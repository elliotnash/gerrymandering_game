import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vector_math/vector_math.dart';

class Vector2Converter extends JsonConverter<Vector2, List<double>> {
  const Vector2Converter();

  @override
  Vector2 fromJson(List<double> json) {
    return Vector2(json[0], json[1]);
  }

  @override
  List<double> toJson(Vector2 object) {
    return [object.x, object.y];
  }
}
