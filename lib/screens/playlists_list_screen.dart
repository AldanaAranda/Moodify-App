import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/playlist_provider.dart';
import '../models/api_response.dart';
import 'playlists_list_item.dart';

class PlaylistsListScreen extends StatefulWidget {
  const PlaylistsListScreen({super.key});

  @override
  PlaylistsListScreenState createState() => PlaylistsListScreenState();
}

class PlaylistsListScreenState extends State<PlaylistsListScreen> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PlaylistProvider>(context, listen: false).fetchPlaylists();
    });
  }

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistProvider>(
      builder: (context, playlistProvider, child) {
        final List<Playlist> playlists = playlistProvider.playlists.where((playlist) {
          return playlist.nombre.toLowerCase().contains(_searchQuery.toLowerCase());
        }).toList();

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
          body: playlistProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : playlistProvider.errorMessage.isNotEmpty
                  ? Center(child: Text("Error: ${playlistProvider.errorMessage}"))
                  : playlists.isEmpty
                      ? const Center(child: Text("No hay playlists disponibles"))
                      : ListView.builder(
                          itemCount: playlists.length,
                          itemBuilder: (context, index) {
                            final playlist = playlists[index];
                            final bool isFav = playlistProvider.isFavorite(playlist.customId);

                            return GestureDetector(
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PlaylistListItem(
                                      index: index,
                                      playlist: {
                                        'id': playlist.customId.toString(),
                                        'playlistCover': playlist.imagen,
                                        'playlistName': playlist.nombre,
                                      },
                                    ),
                                  ),
                                );
                              },
                              child: PlaylistCard(
                                index: index,
                                id: playlist.customId.toString(),
                                imageUrl: playlist.imagen,
                                playlistName: playlist.nombre,
                                isFavorite: isFav,
                                onFavoritePressed: () {
                                  playlistProvider.toggleFavorite(playlist.customId);
                                },
                              ),
                            );
                          },
                        ),
        );
      },
    );
  }
}

class PlaylistCard extends StatelessWidget {
  final int index;
  final String id;
  final String imageUrl;
  final String playlistName;
  final bool isFavorite;
  final VoidCallback onFavoritePressed;

  const PlaylistCard({
    super.key,
    required this.index,
    required this.id,
    required this.imageUrl,
    required this.playlistName,
    required this.isFavorite,
    required this.onFavoritePressed,
  });

  @override
  Widget build(BuildContext context) {
    String finalImageUrl = (imageUrl.isNotEmpty && imageUrl.startsWith("http"))
        ? imageUrl
        : 'assets/images/album.png';

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
                  : const AssetImage('assets/images/album.png') as ImageProvider,
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
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.purple : Colors.grey,
              ),
              onPressed: onFavoritePressed,
            ),
          ],
        ),
      ),
    );
  }
}
