import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final String baseUrl = dotenv.env['API_URL']?.replaceAll(RegExp(r'/$'), '') ?? 'http://localhost:3000';

  Future<Map<String, dynamic>> fetchPlaylists() async {
    print("📡 Enviando petición GET a la API...");
    print("📡 Usando API_URL: $baseUrl");
    
    final response = await http.get(Uri.parse('$baseUrl/api/v1/playlists'));
    
    print("🔹 Código de respuesta: ${response.statusCode}");
    print("🔹 Respuesta completa: ${response.body}");
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      print("✅ Respuesta JSON de la API: $jsonResponse");
      return jsonResponse; // Devolvemos todo el objeto JSON
    } else {
      throw Exception('Error al cargar las playlists');
    }
  }
}