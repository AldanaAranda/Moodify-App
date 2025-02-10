import 'package:flutter/material.dart';

class SongsListItem extends StatefulWidget {
  const SongsListItem({ super.key });

  @override
  State<SongsListItem> createState() => _SongsListItemState();
}

class _SongsListItemState extends State<SongsListItem> {
  double currentTime = 0;
  double volume = 0.5;
  bool isPlaying = false;
  Map<String, dynamic>? currentSong;
  
  @override
  void initState() {
    super.initState();
    currentSong = {
      'song': 'song',
      'artist': 'artist',
      'album': 'album',
      'cover': 'cover',
    };
  }

  void playPause(){
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void nextSong() {
    setState(() {
      currentSong = {
        'song': 'song',
        'artist': 'artist',
        'album': 'album',
        'cover': 'cover',
      };
      currentTime = 0;
      isPlaying = true;
    });
  }

  void previousSong() {
    setState(() {
      currentSong = {
        'song': 'song',
        'artist': 'artist',
        'album': 'album',
        'cover': 'cover',
      };
      currentTime = 0;
      isPlaying = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Obtiene los argumentos pasados
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    // Accede a cada argumento con su clave
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('songs'),
        titleTextStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 26, fontWeight: FontWeight.bold),
        elevation: 10,
        backgroundColor: const Color.fromARGB(255, 150, 16, 216),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderProfileCustomItem(
              size: size,
              songCover: args['songCover'],
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: BodyProfileCustomItem(args: args),
            ),
          const SizedBox(height: 10),
          Column(
            children: [
              Slider(
                activeColor: const Color.fromARGB(255, 118, 17, 206),
                value: currentTime,
                max: 100,
                onChanged: (value) {
                  setState(() {
                    currentTime = value;
                  });
                }
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.skip_previous_rounded, size: 35),
                    onPressed: previousSong,
                  ),
                  IconButton(
                    icon: Icon(isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded, size: 50),
                    onPressed: playPause,
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_next_rounded, size: 35),
                    onPressed: nextSong,
                  )
                ] 
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(padding: EdgeInsets.only(left: 20), child: Icon(Icons.volume_down_rounded)),
                  Expanded(
                    child: Slider(
                      activeColor: const Color.fromARGB(208, 70, 113, 231),
                      value: volume,
                      max: 1,
                      onChanged: (value) {
                        setState(() {
                          volume = value;
                        });
                      }
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(right: 20), child: Icon(Icons.volume_up_rounded))
                  ]
                )
              ],
            )
          ]
        )  
      ),
    );
  }
}

class BodyProfileCustomItem extends StatelessWidget {
  final Map<String, dynamic> args;

  const BodyProfileCustomItem({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          args['song'],
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          args['artist'],
          style: const TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          args['album'], 
          style: const TextStyle(fontSize: 18)
        )
      ],
    );
  }

  InputDecoration decorationInput(
      {IconData? icon, String? hintText, String? helperText, String? label}) {
    return InputDecoration(
      fillColor: Colors.black,
      label: Text(label ?? ''),
      hintText: hintText,
      helperText: helperText,
      helperStyle: const TextStyle(fontSize: 16),
      prefixIcon: (icon != null) ? Icon(icon) : null,
    );
  }
}

class HeaderProfileCustomItem extends StatelessWidget {
  final Size size;
  final String? songCover;

  const HeaderProfileCustomItem({
    super.key,
    this.songCover,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: size.height * 0.40,
      margin: const EdgeInsets.all(20),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: songCover != ""
              ? Image.asset('assets/songs/$songCover.jpg', fit: BoxFit.cover)
              : Image.asset('assets/images/album.png', fit: BoxFit.cover),
        ),
      ),
    );
  }
}
