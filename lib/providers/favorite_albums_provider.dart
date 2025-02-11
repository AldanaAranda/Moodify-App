import 'package:flutter/material.dart';

class FavoriteAlbumsProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _favoriteAlbums = [];

  List<Map<String, dynamic>> get favoriteAlbums => _favoriteAlbums;

  // añadir un album a favs
  void addFavoriteAlbum(Map<String, dynamic> album) {
    _favoriteAlbums.add(album);
    notifyListeners();
  }

  // eliminar un album de favs
  void removeFavoriteAlbum(Map<String, dynamic> album) {
    _favoriteAlbums.remove(album);
    notifyListeners();
  }

  // metodo para añadir o quitar un album fav
  void toggleFavorite(String albumId, String albumName, String albumImageUrl) {
    final albumIndex =
        _favoriteAlbums.indexWhere((album) => album['id'] == albumId);

    if (albumIndex >= 0) {
      // si ya es favorito se elimina
      _favoriteAlbums.removeAt(albumIndex);
    } else {
      // si no es fav, se agrega
      _favoriteAlbums.add({
        'id': albumId,
        'albumName': albumName,
        'image': albumImageUrl,
      });
    }

    notifyListeners();
  }
}
