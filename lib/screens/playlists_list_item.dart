import 'package:flutter/material.dart';

class PlaylistListItem extends StatefulWidget {
  final int index;
  final Map<String, dynamic> playlist;

  const PlaylistListItem({
    super.key,
    required this.index,
    required this.playlist,
  });

  @override
  State<PlaylistListItem> createState() => _PlaylistListItemState();
}

class _PlaylistListItemState extends State<PlaylistListItem> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _commentController = TextEditingController();
  String? _savedComment;
  bool _isFavorite = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("🔎 Imagen recibida en PlaylistListItem: ${widget.playlist['playlistCover']}");
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.playlist['playlistName']),
        backgroundColor: const Color.fromARGB(255, 67, 37, 81),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Imagen principal
              Container(
                width: double.infinity,
                height: 400,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: widget.playlist['playlistCover'] != null &&
                            widget.playlist['playlistCover'].isNotEmpty
                        ? NetworkImage(widget.playlist['playlistCover'])
                        : const AssetImage('assets/images/album.png')
                            as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Text(
                "${widget.playlist['playlistName']}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),

              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        labelText: 'Añadir un comentario',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingresa un comentario';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Marcar como favorito',
                          style: TextStyle(fontSize: 16),
                        ),
                        Switch(
                          value: _isFavorite,
                          onChanged: (value) {
                            setState(() {
                              _isFavorite = value;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _savedComment = _commentController.text;
                              _commentController.clear();
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Comentario guardado'),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 67, 37, 81),
                        ),
                        child: const Text('Guardar comentario'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (_savedComment != null)
                Text(
                  'Comentario guardado: $_savedComment',
                  style: const TextStyle(
                      fontSize: 16, fontStyle: FontStyle.italic),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
