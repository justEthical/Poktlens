
/// Represents a contour consisting of different points.
class Contour {
  List<Point> contour;

  Contour(this.contour);

  Contour.fromJson(Map<String, dynamic> data) {
    List<dynamic> points = data['points'];
    contour = points.map<Point>((p) => Point.fromJson(p)).toList();
  }

  bool get isRectangle => contour.length == 4;
}

/// This represents a point in a cartesian coordinate system
class Point {
  double x;
  double y;

  Point({this.x, this.y});

  // Leave this * 1.0 because I don't found a better way to cast a int to a double
  Point.fromJson(Map<String, dynamic> data)
      : x = data['x'] * 1.0,
        y = data['y'] * 1.0;
}
