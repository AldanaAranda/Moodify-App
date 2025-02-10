import 'package:flutter/material.dart';

class AlbumDetailScreen extends StatefulWidget {
  final int index;
  final Map<String, dynamic> album;

  const AlbumDetailScreen({
    super.key,
    required this.index,
    required this.album,
  });

  @override
  State<AlbumDetailScreen> createState() => _AlbumDetailScreenState();
}

class _AlbumDetailScreenState extends State<AlbumDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _commentController = TextEditingController();
  String? _savedComment;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
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
        title: Text(widget.album['albumName']),
        backgroundColor: const Color.fromARGB(255, 67, 37, 81),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                height: 400,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/albumes/${widget.album['id']}.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Banda:\n ${widget.album['bandName']}",
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
                "Canción principal: ${widget.album['song']}",
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                "Año: ${widget.album['year']}",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              //formulario para agregar comentario sobre el album 
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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  _savedComment!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
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

