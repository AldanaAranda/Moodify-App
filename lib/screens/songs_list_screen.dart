import 'package:flutter_application_base/mocks/songs_mock.dart' show elements;
import 'package:flutter/material.dart';

class SongsListScreen extends StatefulWidget {
  const SongsListScreen({super.key});

  @override
  State<SongsListScreen> createState() => _SongsListScreenState();
}

class _SongsListScreenState extends State<SongsListScreen> {
  List _auxiliarElements = [];
  bool _searchActive = false;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _auxiliarElements = elements.toList();
  }

  @override
  void dispose() {
    // Limpiar el controlador al destruir el widget
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _updateSearch(String query) {
    setState(() {
      _auxiliarElements = elements.where((element) {
        return element[1].toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void _toggleFavorite(int index) {
    setState(() {
      _auxiliarElements[index] = List.from(_auxiliarElements[index]);
      _auxiliarElements[index][5] = !_auxiliarElements[index][5];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
          body: Column(children: [
        searchArea(),
        songsItemsArea(),
      ])),
    );
  }

  Expanded songsItemsArea() {
    return Expanded(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: _auxiliarElements.length,
        itemBuilder: (BuildContext context, int index) {
          final item = _auxiliarElements[index];

          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, 'songs_list_item',
                  arguments: <String, dynamic>{
                    'songCover': item[0],
                    'song': item[1],
                    'artist': item[2],
                    'album': item[3],
                    'length': item[4],
                    'isAdded': item[5]
                  });
              FocusManager.instance.primaryFocus?.unfocus();
            },
           child:SongCard(
              index: index,
              id: item[0],
              songName: item[1],
              artistName: item[2],
              albumName: item[3],
              length: item[4],
              isFavorite: item[5],
              onFavoriteToggle: () => _toggleFavorite(index),
            )
          );
        },
      ),
    );
  }

  AnimatedSwitcher searchArea() {
    return AnimatedSwitcher(
      switchInCurve: Curves.bounceIn,
      switchOutCurve: Curves.bounceOut,
      duration: const Duration(milliseconds: 300),
      child: (_searchActive)
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _searchController,
                      focusNode: _focusNode,
                      onChanged: (value) {
                        _updateSearch(value);
                      },
                      onFieldSubmitted: (value) {
                        _updateSearch(value);
                      },
                      decoration: const InputDecoration(hintText: 'Buscar...'),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _searchController.clear();
                      FocusManager.instance.primaryFocus?.unfocus();
                      _updateSearch('');
                    },
                    icon: const Icon(Icons.clear),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _searchActive = false;
                      });
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                ],
              ),
            )
          : Container(
              padding: const EdgeInsets.all(2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.keyboard_arrow_left_outlined)),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _searchActive = !_searchActive;
                      });
                      _focusNode.requestFocus();
                    },
                    icon: const Icon(Icons.search)),
                ],
              ),
            ),
    );
  }
}

class SongCard extends StatelessWidget {
  final int index;
  final String id;
  final String songName;
  final String artistName;
  final String albumName;
  final String length;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const SongCard({
    super.key,
    required this.index,
    required this.id,
    required this.songName,
    required this.artistName,
    required this.albumName,
    required this.length,
    required this.isFavorite,
    required this.onFavoriteToggle
  });

  @override
  Widget build (BuildContext context) {
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
              borderRadius: BorderRadius.circular(12),
              child: Image.asset( 'assets/songs/$id.jpg', width: 100, height: 100, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) {
                return Image.asset( 'assets/images/album.jpg', width: 100, height: 100, fit: BoxFit.cover );
              })
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text( songName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold) ),
                  Text( artistName, style: const TextStyle(fontSize: 17) ),
                  Text( albumName ),
                  Text( length )
                ],
              ),
            ),
          IconButton(
            icon: Icon(
              isFavorite ? Icons.add_box : Icons.add_box_outlined,
              color: isFavorite ? const Color.fromARGB(255, 186, 88, 242) : Colors.grey
            ),
            onPressed: onFavoriteToggle,
          ),
        ],
      ),
    );
  }
}