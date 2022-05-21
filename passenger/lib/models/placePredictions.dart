class PlacePredictions {
  String? secondary_text;
  String? main_text;
  String? place_id;
  PlacePredictions({this.secondary_text, this.main_text, this.place_id});
  PlacePredictions.fromjson(Map<String, dynamic> json) {
    place_id = json["place_id"];
    main_text = json["main_text"];
    secondary_text = json["secondary_text"];
  }
}
