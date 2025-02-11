import 'package:flutter/material.dart';
import 'package:flutter_application_base/helpers/preferences.dart';
import 'package:flutter_application_base/screens/playlists_list_screen.dart';
import 'package:flutter_application_base/screens/screens.dart';
import 'package:flutter_application_base/helpers/theme_provider.dart';
import 'package:flutter_application_base/themes/default_theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'providers/playlist_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Preferences.initShared();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => PlaylistProvider()),
        ],
        child:
            Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
          return MaterialApp(
              title: 'Flutter Demo',
              debugShowCheckedModeBanner: false,
              initialRoute: 'login',
              theme: DefaultTheme.lightTheme,
              darkTheme: DefaultTheme.darkTheme,
              themeMode:
                  Preferences.darkmode ? ThemeMode.dark : ThemeMode.light,
              routes: {
                'login': (context) => const LoginScreen(),
                'home': (context) => const HomeScreen(),
                'songs_list': (context) => const SongsListScreen(),
                'profile': (context) => const ProfileScreen(),
                'songs_list_item': (context) => const SongsListItem(),
                'albums_list': (context) => const AlbumesListScreen(),
                'playlists_list': (context) => const PlaylistsListScreen(),
              });
        }));
  }
}
