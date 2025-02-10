// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'playlists_list_item.dart';

class PlaylistsListScreen extends StatefulWidget {
  const PlaylistsListScreen({super.key});

  @override
  PlaylistsListScreenState createState() => PlaylistsListScreenState();
}

class PlaylistsListScreenState extends State<PlaylistsListScreen> {
  String _searchQuery = '';
  final ApiService apiService = ApiService();

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(
            hintText: 'Buscar playlist...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white60),
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: _updateSearchQuery,
        ),
        backgroundColor: const Color.fromARGB(255, 67, 37, 81),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: apiService.fetchPlaylists(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("No hay playlists disponibles"));
          }

          List<dynamic> filteredPlaylists = snapshot.data!.where((playlist) {
            return playlist['nombre']
                    .toString()
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()) ||
                playlist['artistas']
                    .toString()
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase());
          }).toList();

          return ListView.builder(
            itemCount: filteredPlaylists.length,
            itemBuilder: (context, index) {
              final playlist = filteredPlaylists[index];
              return GestureDetector(
                onTap: () async {
                  print("📡 Navegando a PlaylistListItem con imagen: ${playlist['imagen']}");
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlaylistListItem(
                        index: index,
                        playlist: {
                          'id': playlist['id']?.toString() ?? '',
                          'playlistCover': playlist['imagen'] ?? '',
                          'playlistName': playlist['nombre'] ?? 'Sin nombre',
                        },
                      ),
                    ),
                  );
                  setState(() {});
                },
                child: PlaylistCard(
                  index: index,
                  id: playlist['id']?.toString() ?? '',
                  imageUrl: playlist['imagen'] ?? 'assets/images/album.png',
                  playlistName: playlist['nombre'] ?? 'Sin nombre',
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class PlaylistCard extends StatelessWidget {
  final int index;
  final String id;
  final String imageUrl;
  final String playlistName;

  const PlaylistCard({
    super.key,
    required this.index,
    required this.id,
    required this.imageUrl,
    required this.playlistName,
  });

  @override
  Widget build(BuildContext context) {
    String finalImageUrl = (imageUrl.isNotEmpty && imageUrl.startsWith("http"))
        ? imageUrl
        : 'assets/images/album.png';
    print("🔎 Cargando imagen: $finalImageUrl");
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 10.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Image(
              image: finalImageUrl.startsWith("http")
                  ? NetworkImage(finalImageUrl)
                  : const AssetImage('assets/images/album.png')
                      as ImageProvider,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    playlistName,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
