![logo](https://i.imgur.com/xOniTxy.png)
# Moodify app 🎵
## Proyecto flutter
### Participantes: Aldana Aranda y Jessica Escobar

### Index

1. Descripción
2. Documentación
    * [Requerimientos previos](#requerimientos-previos)
    * [Instalación](#instalación)
    * [Ejecución](#ejecución)
    * [Estructura del proyecto](#estructura)
    * [Widgets destacados](#widgets)
    * [State Management](#state-management)
    * [Funcionalidades](#funcionalidades)
    * [Roadmap](#roadmap)
3. Ramas
    + [aldi_branch](https://github.com/AldanaAranda/Moodify-App/tree/aldi_branch)
    + [jessi_branch](https://github.com/AldanaAranda/Moodify-App/tree/jessi_branch)

## Descripción
**moodify** es una aplicación desarrollada en Flutter que permite a los usuarios encontrar playlists, canciones y álbums basados en su **estado de ánimo** actual.

## Documentación
### Requerimientos previos
> [!NOTE]
> Tener instalado Flutter SDK y Dart. Editor de código recomendado: Visual Studio Code. Un emulador Android o un dispositivo físico conectado.

### Instalación
> - Clonar repositorio del Frontend: ``https://github.com/AldanaAranda/Moodify-App.git``
> - ``cd Modify-App``
> - Instalar dependencias con: ``flutter pub get``
> - Crear un archivo .env en la raíz del proyecto y definir las variables de entornos necesarias: ``API_URL=http://10.0.2.2:3000``

### Ejecución
> ``flutter run``

### Estructura
> - ``pubspec.yaml``: contiene las dependencias de la app
> - ``lib``: contiene la lógica de la app
> - ``screens``: contiene los archivos de cada pantalla
> - ``widgets``: contiene los widgets de la app
> - ``main.dart``: contiene el punto de entrada de la app

> ### Moodify-App/
> - ├── lib/
> - │   ├── helpers/
> - │   │   ├── preferences.dart
> - │   │   ├── theme_provider.dart
> - │   ├── main.dart
> - │   ├── models/
> - │   │   ├── album.dart
> - │   ├── providers/
> - │   │   ├── favorite_albums_provider.dart
> - │   ├── screens/
> - │   │   ├── album_individual.dart
> - │   │   ├── albumes_list_screen.dart
> - │   │   ├── alert_screen.dart
> - │   │   ├── home_screen.dart
> - │   │   ├── login_screen.dart
> - │   │   ├── playlists_list_item.dart
> - │   │   ├── playlists_list_screen.dart
> - │   │   ├── profile_screen
> - │   │   ├── songs_list_screen.dart
> - │   │   ├── songs_list_item.dart
> - │   ├── services/
> - │   │   ├── api_service.dart
> - │   ├─ themes/
> - │   │   ├── default_theme.dart
> - │   ├── widgets/
> - │   │   ├── drawer_menu.dart
> - │   ├ pubspec.yaml


### Widgets
* destacados

    | widget | descripción |
    |---|---|
    | **drawer menu** | Menú lateral desplegable con opciones dinámicas.
    | **provider** | Manejo del estado globalmente, se utiliza: FavoriteAlbumsProvider y ThemeProvider.
    | **modelo de datos** | Conversión de JSON a clases en Dart (QuickType.io).
    | **Flutter Dotenv** | Manejo de configuraciones externas (URL de la API).
    | **peticiones http** | Se utiliza para consumir la API, un ejemplo es en la obtencion de playlists.
    | **Shared Preferences** | Se utiliza para persistir configuraciones en el almacenamiento local.
    | **FutureBuilder** | Se utiliza para manejar respuestas asíncronas al cargar canciones.


### State Management
* providers implementados

    | provider | descripción |
    |---|---|
    | **theme provider** | Permite alternar entre tema claro y oscuro.   
    | **FavoriteAlbumProvider** | Maneja la lista de álbumes favoritos del usuario.


### Funcionalidades
* funcionalidades implementadas
    | funcionalidad | descripción |
    |---|---|
    | **cambiar tema** | permite cambiar entre tema claro y oscuro.
    | **login** | permite iniciar sesión con usuario y contraseña.
    | **mostrar canciones** | permite mostrar canciones de un álbum.
    | **mostrar canción** | permite mostrar canción individual.
    | **mostrar álbumes** | permite mostrar álbumes.
    | **mostrar álbum** | permite mostrar detalles de un álbum.

### Roadmap
Constituir el backend con ``Node.Js`` para integrar la API de Spotify para obtener información de canciones, playlist, álbumes y artistas.