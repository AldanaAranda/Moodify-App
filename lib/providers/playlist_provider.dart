import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/api_response.dart';
import '../services/api_service.dart';

class PlaylistProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Playlist> _playlists = [];
  List<int> _favoritePlaylists = []; // Lista de favoritos
  bool _isLoading = false;
  String _errorMessage = '';

  List<Playlist> get playlists => _playlists;
  List<int> get favoritePlaylists => _favoritePlaylists;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  PlaylistProvider() {
    _loadFavorites(); // Cargar favoritos al iniciar
  }

  Future<void> fetchPlaylists() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.fetchPlaylists();
      final apiResponse = ApiResponse.fromJson(response);
      _playlists = apiResponse.data;
    } catch (e) {
      _errorMessage = 'Error al obtener playlists: $e';
      _playlists = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Cargar favoritos desde SharedPreferences
  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _favoritePlaylists = prefs.getStringList('favorites')?.map(int.parse).toList() ?? [];
    notifyListeners();
  }

  /// Guardar favoritos en SharedPreferences
  Future<void> _saveFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', _favoritePlaylists.map((e) => e.toString()).toList());
  }

  /// Agregar o quitar favoritos
  void toggleFavorite(int playlistId) {
    if (_favoritePlaylists.contains(playlistId)) {
      _favoritePlaylists.remove(playlistId);
    } else {
      _favoritePlaylists.add(playlistId);
    }
    _saveFavorites();
    notifyListeners();
  }

  /// Verificar si una playlist es favorita
  bool isFavorite(int playlistId) {
    return _favoritePlaylists.contains(playlistId);
  }
}
