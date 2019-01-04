class LocationArea {
  final int id;
  final String user;
  final double lat;
  final double lon;

  LocationArea({this.id, this.user, this.lat, this.lon});

  factory LocationArea.fromJson(Map<String, dynamic> parsedJson) {
    print("LocationArea.fromJson(Map");
    return LocationArea(
        id: parsedJson["id"],
        user: parsedJson["user"],
        lat: parsedJson["lat"],
        lon: parsedJson["lon"]);
  }
}

class Locations {
  final int status;
  final int distance;
  final double curLat;
  final double curLon;
  List<LocationArea> lstLocationArea;

  Locations(
      {this.status,
      this.distance,
      this.curLat,
      this.curLon,
      this.lstLocationArea});

  factory Locations.fromJson(Map<String, dynamic> parsedJson) {
    print("Locations.fromJson");
    var list = parsedJson["data"] as List;
    print("Locations.fromJson list: $list");
    print(list.runtimeType);
    List<LocationArea> lstLocation =
        list.map((i) => LocationArea.fromJson(i)).toList();
    int status = parsedJson["status"];
    print("Locations.fromJson status: $status");
    return Locations(
        status: parsedJson["status"],
        distance: parsedJson["distance"],
        curLat: parsedJson["curLat"],
        curLon: parsedJson["curLon"],
        lstLocationArea: lstLocation);
  }
}
