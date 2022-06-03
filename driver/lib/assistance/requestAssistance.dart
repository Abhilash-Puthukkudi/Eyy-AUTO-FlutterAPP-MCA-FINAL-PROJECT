import 'dart:convert';
import 'package:http/http.dart' as http;

class requestAssistant {
  static Future<dynamic> getRequest(String url) async {
    http.Response response = await http.get(Uri.parse(url));

    try {
      if (response.statusCode == 200) {
        String jsonData = response.body;
        var decodedata = jsonDecode(jsonData);
        return decodedata;
      } else {
        return "Failed! No response avilable";
      }
    } catch (e) {
      return "Failed! ";
    }
  }
}
