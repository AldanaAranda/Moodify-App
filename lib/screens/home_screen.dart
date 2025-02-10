import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_application_base/widgets/drawer_menu.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Image(image: AssetImage('assets/images/moodify_1.png'), height: 60)
        ),
        centerTitle: true,
        leadingWidth: 40,
        toolbarHeight: 80
      ),
      drawer: const DrawerMenu(),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/wave.png', height: 250),
            const SizedBox(height: 40),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 139, 44, 191), Colors.blueAccent
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight 
                ).createShader(bounds),
                child: const Text('Listen to music according to your mood!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white))
              ),
            const SizedBox(height: 20),
            const Text('discover songs based on your mood and emotions', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
            const Text('Select your mood and let the music play!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
            const SizedBox(height: 20),
            ShaderMask(shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 139, 44, 191), Colors.blueAccent
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight
                ).createShader(bounds),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom( 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    side: const BorderSide(color: Color.fromARGB(255, 108, 192, 228), width: 2)
                    ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/songs_list');
                  },
                  child: const Text('Get started', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white))
                )
              )
            ]
          )
        ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.plus_one),
        onPressed: () {
          log('click button');
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}