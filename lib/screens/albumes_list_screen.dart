import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../providers/favorite_albums_provider.dart';
import 'album_individual.dart';
import '../models/album.dart';

class AlbumesListScreen extends StatefulWidget {
  const AlbumesListScreen({super.key});

  @override
  State<AlbumesListScreen> createState() => _AlbumesListScreenState();
}

class _AlbumesListScreenState extends State<AlbumesListScreen> {
  late ApiService apiService;
  List<Album> allAlbums = [];
  List<Album> filteredAlbums = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    _fetchAlbums();
  }

  Future<void> _fetchAlbums() async {
    final response = await apiService.fetchAlbums();
    setState(() {
      allAlbums = response;
      filteredAlbums = allAlbums; 
    });
  }

  void _filterAlbums(String query) {
    setState(() {
      filteredAlbums = allAlbums
          .where((album) =>
              album.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Álbumes'),
          backgroundColor: Colors.purple, 
        ),
        body: Column(
          children: [
            searchArea(),
            Expanded(
              child: FutureBuilder<List<Album>>(
                future: apiService.fetchAlbums(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No hay álbumes disponibles.'));
                  }

                  List<Album> albums = filteredAlbums;
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: albums.length,
                    itemBuilder: (BuildContext context, int index) {
                      final album = albums[index];

                      final isFavorite =
                          Provider.of<FavoriteAlbumsProvider>(context)
                              .favoriteAlbums
                              .any((favAlbum) => favAlbum['id'] == album.id);

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AlbumDetailScreen(albumId: album.id),
                            ),
                          );
                        },
                        child: AlbumCard(
                          id: album.id,
                          albumName: album.name,
                          bandName: album.artists.isNotEmpty
                              ? album.artists[0]
                              : "Desconocido",
                          year: album.releaseDate,
                          imageUrl: album.image,
                          isFavorite: isFavorite,
                          onFavoriteToggle: () {
                            Provider.of<FavoriteAlbumsProvider>(context,
                                    listen: false)
                                .toggleFavorite(
                                    album.id, album.name, album.image);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget searchArea() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.keyboard_arrow_left_outlined),
          ),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: _filterAlbums,
              decoration: const InputDecoration(
                hintText: 'Buscar álbum...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AlbumCard extends StatelessWidget {
  final String id;
  final String albumName;
  final String bandName;
  final String year;
  final String imageUrl;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const AlbumCard({
    super.key,
    required this.id,
    required this.albumName,
    required this.bandName,
    required this.year,
    required this.imageUrl,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: const Color.fromARGB(31, 206, 219, 246),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/placeholder.png',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(albumName,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                Text(bandName),
                Text('Año: $year'),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.purple : Colors.grey,
            ),
            onPressed: onFavoriteToggle,
          ),
        ],
      ),
    );
  }
}