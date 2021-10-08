const API_KEY = 'AIzaSyA9oDvffVfUyOLZZLBN9LpCDusk-aue9Zc';

class LocationHelper {
  //retornamos uma URL que representa uma imagem estática do mapa com base nas informações do Google
  static String generateLocationPreviewImage(
      {double? latitude, double? longitude}) {
    print(latitude);
    print(longitude);
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=13&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%$latitude,$longitude&key=$API_KEY';
  }
}
