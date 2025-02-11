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
  List<Album> _albums = [];
  List<Album> _filteredAlbums = [];
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    _fetchAlbums(); // se llama a la funcion para obtener los albumes al iniciar
  }

  Future<void> _fetchAlbums() async {
    try {
      List<Album> albums = await apiService.fetchAlbums();
      setState(() {
        _albums = albums;
        _filteredAlbums = albums;
      });
    } catch (e) {
      debugPrint("Error al obtener álbumes: $e");
    }
  }

  // filtrar en la lista de albumes con lo que se escribe en el buscador
  void _filterAlbums(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredAlbums = _albums;
      } else {
        _filteredAlbums = _albums
            .where((album) => album.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 67, 37, 81), 
          title: _isSearching
              ? TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: "Buscar álbum...",
                    hintStyle: TextStyle(color: Colors.white70),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(color: Colors.white),
                  onChanged: _filterAlbums,
                )
              : const Text(
                  "Lista de Álbumes",
                  style: TextStyle(color: Colors.white),
                ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(_isSearching ? Icons.close : Icons.search, color: Colors.white),
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                  if (!_isSearching) {
                    _searchController.clear();
                    _filterAlbums('');
                  }
                });
              },
            ),
          ],
        ),
        body: _filteredAlbums.isEmpty
            ? const Center(child: Text("No hay álbumes disponibles."))
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: _filteredAlbums.length,
                itemBuilder: (BuildContext context, int index) {
                  final album = _filteredAlbums[index];

                  // se verifica si el album esta en favoritos
                  final isFavorite = Provider.of<FavoriteAlbumsProvider>(context)
                      .favoriteAlbums
                      .any((favAlbum) => favAlbum['id'] == album.id);

                  return GestureDetector(
                    onTap: () {
                      // para ir a la pantalla de detalle del album
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AlbumDetailScreen(albumId: album.id),
                        ),
                      );
                    },
                    child: AlbumCard(
                      id: album.id,
                      albumName: album.name,
                      bandName: album.artists.isNotEmpty ? album.artists[0] : "Desconocido",
                      year: album.releaseDate,
                      imageUrl: album.image,
                      isFavorite: isFavorite,
                      onFavoriteToggle: () {
                        Provider.of<FavoriteAlbumsProvider>(context, listen: false)
                            .toggleFavorite(album.id, album.name, album.image);
                      },
                    ),
                  );
                },
              ),
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

