import 'dart:convert';
import 'package:http/http.dart' as http;

const API_KEY = 'API_KEY';

class LocationHelper {
  //retornamos uma URL que representa uma imagem estática do mapa com base nas informações do Google
  static String generateLocationPreviewImage(
      {double? latitude, double? longitude}) {
    print(latitude);
    print(longitude);
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=13&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%$latitude,$longitude&key=$API_KEY';
  }

  //TRANSFORMAMOS A LATITUDE E LONGITUDE EM ENDEREÇO QUE PODE SER LIDO POR HUMANOS
  static Future<String> getPlaceAddress(
      double latitude, double longitude) async {
    //reverse geocoding com essa uri
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$API_KEY');
    //usamos o package http para fazer a request
    var response = await http.get(url);
    print(json.decode(response.body));
    //o resultado é em JSON e pegamos o endereço mais relevante
    return json.decode(response.body)['results'][0]['formatted_address'];
  }
}
