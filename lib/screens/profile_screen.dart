import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_base/mocks/usuario_mock.dart' show usuario;
import 'package:flutter_application_base/mocks/songs_mock.dart' show elements;
import 'package:provider/provider.dart';
import '../providers/favorite_albums_provider.dart';
import '../services/api_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  dynamic _image;
  String? assetImage;
  String _username = "Usuario";
  List<Map<String, dynamic>> _favoriteAlbums = [];
  List<Map<String, dynamic>> _likedSongs = [];

  bool _showFavorites = false;

  late ApiService apiService;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    _loadProfileData();
  }

  //carga los datos del perfil desde SharedPreferences

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      final imagePath = prefs.getString('profileImage');
      if (imagePath != null) {
        if (imagePath.startsWith('assets/')) {
          assetImage = imagePath;
        } else {
          _image = File(imagePath);
        }
      }
      _username = prefs.getString('username') ?? usuario[0];
      _likedSongs = elements
          .where((song) => song[5] == true)
          .map((song) => {
                'songCover': 'assets/songs/${song[0]}.jpg',
                'songName': song[1],
                'artist': song[2],
                'album': song[3],
              })
          .toList();
    });
  }

  //guarda los datos del perfil en SharedPreferences

  Future<void> _saveProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', _username);
    await prefs.setStringList(
      'favoriteAlbums',
      _favoriteAlbums.map((album) => album['albumName']!.toString()).toList(),
    );
    await prefs.setStringList(
      'likedSongs',
      _likedSongs.map((song) => song['songName']!.toString()).toList(),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imagePath = pickedFile.path;

      setState(() {
        _image = File(imagePath);
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profileImage', imagePath);
    }
  }

  void _pickAvatar(BuildContext context, String avatarPath) async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      assetImage = avatarPath;
      _image = null; // Guardamos la ruta del asset como String
    });

    await prefs.setString('profileImage', avatarPath);
    Navigator.pop(context);
  }

  void _showImageOptions(BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('elegir avatar',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('gallery'),
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage();
                    }),
                ListTile(
                    leading: const Icon(Icons.face),
                    title: const Text('avatars'),
                    onTap: () {
                      Navigator.pop(context);
                      _showAvatarSelection(context);
                    }),
              ],
            ),
          );
        });
  }

  void _showAvatarSelection(BuildContext context) {
    final avatars = [
      'assets/avatars/avatar1.png',
      'assets/avatars/avatar2.png',
      'assets/avatars/avatar3.png',
      'assets/avatars/avatar4.png',
      'assets/avatars/avatar5.png',
      'assets/avatars/avatar6.png',
      'assets/avatars/avatar7.png',
      'assets/avatars/avatar8.png',
      'assets/avatars/avatar9.png'
    ];

    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Text('elegir avatar',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Expanded(
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: avatars.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                            onTap: () => _pickAvatar(context, avatars[index]),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                avatars[index],
                                fit: BoxFit.cover,
                              ),
                            ));
                      }))
            ]),
          );
        });
  }

  Widget _buildProfileImg() {
    if (_image != null) {
      return CircleAvatar(
        radius: 50,
        backgroundImage: FileImage(_image!),
      );
    } else if (assetImage != null) {
      return CircleAvatar(
        radius: 50,
        backgroundImage: AssetImage(assetImage!),
      );
    } else {
      return const CircleAvatar(
        radius: 50,
        backgroundColor: Colors.transparent,
        child: Icon(Icons.add_a_photo, size: 40, color: Colors.white),
      );
    }
  }

  void _toggleFavoriteAlbums() {
    setState(() {
      _showFavorites = !_showFavorites;
    });
  }

  void _changeUsername() {
    showDialog(
      context: context,
      builder: (context) {
        String newUsername = _username;
        return AlertDialog(
          title: const Text("cambiar nombre de usuario"),
          content: TextField(
            onChanged: (value) {
              newUsername = value;
            },
            decoration: const InputDecoration(
              focusColor: Color.fromARGB(255, 112, 18, 195),
              labelText: "Nuevo nombre de usuario",
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                side: const BorderSide(
                    color: Color.fromARGB(0, 147, 10, 238), width: 2),
              ),
              onPressed: () {
                setState(() {
                  _username = newUsername;
                });
                _saveProfileData();
                Navigator.of(context).pop();
              },
              child: const Text("Guardar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final favoriteAlbumsProvider = Provider.of<FavoriteAlbumsProvider>(context);
    final favoriteAlbums = favoriteAlbumsProvider.favoriteAlbums;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 67, 37, 81), 
        centerTitle: true,
        title: const Text('Profile',
            style: TextStyle(fontSize: 22, fontFamily: 'Poppins')),
        elevation: 10,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Perfil de usuario
            SizedBox(
              width: double.infinity,
              height: size.height * 0.3,
              child: Center(
                child: GestureDetector(
                  onTap: () => _showImageOptions(context),
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color.fromARGB(255, 96, 18, 206),
                        width: 2,
                      ),
                    ),
                    child: _buildProfileImg(),
                  ),
                ),
              ),
            ),
            // info de perfil y botones
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  // nombre de usuario y el boton para editarlo
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _username,
                        style: const TextStyle(
                          fontSize: 28,
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
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: _changeUsername,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _toggleFavoriteAlbums,
                    child: Ink(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 112, 18, 195),
                            Color.fromARGB(255, 84, 86, 235),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        width: 180,
                        height: 50,
                        child: Text(
                          _showFavorites ? "Ocultar" : "Ver álbumes favoritos",
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  if (_showFavorites) ...[
                    const SizedBox(height: 20),
                    favoriteAlbums.isEmpty
                        ? const Text("No tienes álbumes favoritos.")
                        : SizedBox(
                            height: 300,
                            child: ListView.builder(
                              itemCount: favoriteAlbums.length,
                              itemBuilder: (context, index) {
                                final album = favoriteAlbums[index];
                                return ListTile(
                                  leading: Image.network(
                                    album['image']!,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                  title: Text(album['albumName']!),
                                );
                              },
                            ),
                          ),
                  ],
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Column(
                            children: [
                              const SizedBox(height: 10),
                              const Text(
                                "Playlist personalizada",
                                style: TextStyle(
                                  fontSize: 18,
                                  letterSpacing: 1.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Divider(),
                              Expanded(
                                child: _likedSongs.isEmpty
                                    ? const Center(
                                        child: Text("No hay canciones"))
                                    : ListView.builder(
                                        itemCount: _likedSongs.length,
                                        itemBuilder: (context, index) {
                                          final song = _likedSongs[index];
                                          return ListTile(
                                            leading: Image.asset(
                                              song['songCover']!,
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                            ),
                                            title: Text(song['songName']!),
                                            subtitle: Text(song['artist']!),
                                          );
                                        },
                                      ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text("Ver canciones favoritas"),
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