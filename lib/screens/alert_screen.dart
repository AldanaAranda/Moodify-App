import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AlertScreen extends StatelessWidget {
  const AlertScreen({super.key});

  void displayDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('titulo'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Contenido de la alerta'),
              SizedBox(height: 10),
              FlutterLogo(size: 100)
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar', style: TextStyle(color: Colors.red))),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Aceptar')),
          ],
        );
      });
  }

  void displayDialogAndroid(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          elevation: 5,
          title: const Text('titulo'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.circular(10)
            ), 
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Contenido de la alerta'),
              SizedBox(height: 10),
              FlutterLogo(size: 50)
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar')),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Aceptar')),
          ],
        );
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            shape: const StadiumBorder(),
            elevation: 10
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text('Show alert', style: TextStyle(fontSize: 16)),
        ),
        onPressed: () => Platform.isAndroid ?  displayDialogAndroid(context) : displayDialog(context))),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        )
      );
    }
}