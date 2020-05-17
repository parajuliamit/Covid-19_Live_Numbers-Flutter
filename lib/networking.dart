import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateNumbers {
  //TODO add your API KEY here to run
  static const _api_key = '<Your API-Key>';
  static const String _baseUrl = "covid-19-data.p.rapidapi.com";
  static const Map<String, String> _headers = {
    "content-type": "application/json",
    "x-rapidapi-host": "covid-19-data.p.rapidapi.com",
    "x-rapidapi-key": _api_key,
  };

  Future<List<String>> get(String country) async {
    List<String> data = [];
    http.Response response;
    if (country == 'Global') {
      Uri uri = Uri.https(_baseUrl, "/totals", {"format": "json"});

      response = await http.get(uri, headers: _headers);
    } else {
      Uri uri = Uri.https(
          _baseUrl, "/country/code", {"format": "json", "code": country});

      response = await http.get(uri, headers: _headers);
    }
    if (response.statusCode == 200) {
      var decodedData = jsonDecode(response.body);
      if (decodedData[0]['lastUpdate'] == null) {
        return ['--', '--', '--', '--', '--'];
      }
      try {
        int confirmed = decodedData[0]['confirmed'];
        int deaths = decodedData[0]['deaths'];
        int recovered = decodedData[0]['recovered'];
        int active = confirmed - deaths - recovered;

        data.add(decodedData[0]['lastUpdate']);
        data.add(confirmed.toString());
        data.add(deaths.toString());
        data.add(active.toString());
        data.add(recovered.toString());
      } catch (e) {
        print(e);
        return ['--', '--', '--', '--', '--'];
      }
    } else {
      print(response.statusCode);
      data = ['--', '--', '--', '--', '--'];
    }
    return data;
  }
}
