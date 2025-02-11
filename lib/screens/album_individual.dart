import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AlbumDetailScreen extends StatefulWidget {
  final String albumId;

  const AlbumDetailScreen({
    super.key,
    required this.albumId,
  });

  @override
  State<AlbumDetailScreen> createState() => _AlbumDetailScreenState();
}

class _AlbumDetailScreenState extends State<AlbumDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _commentController = TextEditingController();
  String? _savedComment;
  Map<String, dynamic>? _albumDetails;
  bool _isLoading = true;
  String? _errorMessage;

  late ApiService apiService;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    _fetchAlbumDetails();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _fetchAlbumDetails() async {
    try {
      final response = await apiService.fetchAlbumById(widget.albumId);
      if (response != null && response['status'] == 'OK' && response['data'] != null) {
        setState(() {
          _albumDetails = response['data'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = "Error en la respuesta del servidor.";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error al cargar el álbum.";
        _isLoading = false;
      });
    }
  }

  void _saveComment() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _savedComment = _commentController.text;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comentario guardado')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_albumDetails?['name'] ?? 'Cargando...'),
        backgroundColor: const Color.fromARGB(255, 67, 37, 81),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child:
                      Text(_errorMessage!, style: TextStyle(color: Colors.red)))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (_albumDetails != null) ...[
                          Image.network(
                            _albumDetails!['image'],
                            width: double.infinity,
                            height: 400,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Artista(s):\n ${_albumDetails!['artists'].join(', ')}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 30,
                              shadows: [
                                Shadow(
                                  offset: Offset(3.0, 3.0),
                                  blurRadius: 5.0,
                                  color: Color.fromARGB(255, 129, 72, 155),
                                ),
                              ],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Total de canciones: ${_albumDetails!['total_tracks']}",
                            style: const TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Fecha de lanzamiento: ${_albumDetails!['release_date']}",
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),

                          // formulario de comentarios
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _commentController,
                                  decoration: const InputDecoration(
                                    labelText: 'Agregar comentario',
                                    border: OutlineInputBorder(),
                                  ),
                                  maxLines: 3,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'El comentario no puede estar vacío';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: _saveComment,
                                  child: const Text("Guardar comentario"),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          if (_savedComment != null) ...[
                            const Text(
                              "Comentario guardado:",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _savedComment!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ],
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Volver"),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}

