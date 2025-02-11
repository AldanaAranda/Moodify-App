import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/album.dart';

class ApiService {
  final String baseUrl = dotenv.env['API_URL']?.replaceAll(RegExp(r'/$'), '') ?? 'http://localhost:3000';
  Future<List<dynamic>> fetchPlaylists() async{
    print("📡 Enviando petición GET a la API...");
    print("📡 Usando API_URL: $baseUrl");
    final response = await http.get(Uri.parse('$baseUrl/api/v1/playlists'));
    print("🔹 Código de respuesta: ${response.statusCode}");
    print("🔹 Respuesta completa: ${response.body}");
    if (response.statusCode == 200){
      final jsonResponse = json.decode(response.body);
      print("✅ Respuesta JSON de la API: $jsonResponse");
      return jsonResponse['data'];
    } else {
      throw Exception('Error al cargar las playlists');
    }
  }

  Future<List<Album>> fetchAlbums() async {
    final response = await http.get(Uri.parse('$baseUrl/api/v1/albums'));
    if (response.statusCode == 200) {
      return albumResponseFromJson(response.body).data; // Retorna solo la lista de álbumes
    } else {
      throw Exception('Error al cargar los álbumes');
    }
  }

  Future<Map<String, dynamic>> fetchAlbumById(String id) async {
    print("Obteniendo detalles del álbum con ID: $id");
    final response = await http.get(Uri.parse('$baseUrl/api/v1/albums/$id'));
    print("Respuesta de la API (detalle álbum): ${response.body}");
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse; // Asegúrate de que 'data' contiene el álbum
    } else {
      throw Exception('Error al obtener los detalles del álbum');
    }
  }
}