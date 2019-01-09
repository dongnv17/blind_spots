import 'dart:math' as math;
class CalBearing{
  static double _degreeToRadians(double latLong) {

    return (math.pi * latLong / 180.0);
  }

  static double _radiansToDegree(double latLong) {
    return (latLong * 180.0 / math.pi);
  }

  static double getBearing(double latSource, double lngSource, double latDest, double lngDest) {

    double fLat = _degreeToRadians(latSource);
    double fLong = _degreeToRadians(lngSource);
    double tLat = _degreeToRadians(latDest);
    double tLong = _degreeToRadians(lngDest);

    double dLon = (tLong - fLong);

    double degree = _radiansToDegree(math.atan2(math.sin(dLon) * math.cos(tLat),
        math.cos(fLat) * math.sin(tLat) - math.sin(fLat) * math.cos(tLat) * math.cos(dLon)));

    if (degree >= 0) {
      return degree;
    } else {
      return 360 + degree;
    }
  }
}