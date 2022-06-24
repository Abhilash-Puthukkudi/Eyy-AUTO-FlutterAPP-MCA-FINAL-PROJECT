import 'package:passenger/models/nearByAvilableDrivers.dart';

class GeoFireAssistant {
  static List<NearByAvilableDrivers> nearByAvilableDriversList = [];

  static removeDriverFromList(String key) {
    int index = nearByAvilableDriversList.indexWhere(
        (element) => element.key == key); // finding index and removing
    nearByAvilableDriversList.removeAt(index);
  }

  static updateDriverNearbyLocation(NearByAvilableDrivers driver) {
    int index = nearByAvilableDriversList
        .indexWhere((element) => element.key == driver.key);
    nearByAvilableDriversList[index].latitude = driver.latitude;
    nearByAvilableDriversList[index].longitude = driver.longitude;
  }
}
