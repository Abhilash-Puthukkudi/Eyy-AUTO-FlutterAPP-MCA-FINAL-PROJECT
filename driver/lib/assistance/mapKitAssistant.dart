import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:maps_toolkit/maps_toolkit.dart';

class MapKitAssistant {
  //source latitiude source longitude , droplatitiude dropoff longitude
  static double getMarkerRotaion(sLat, sLng, dLat, dLng) {
    var roation =
        SphericalUtil.computeHeading(LatLng(sLat, sLng), LatLng(dLat, dLng));

    return roation as double;
  }
}
