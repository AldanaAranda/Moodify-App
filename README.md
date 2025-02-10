![logo](https://i.imgur.com/xOniTxy.png)
# moodify app 🎵
## proyecto flutter
### participantes: Aldana Aranda y Jessica Escobar

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
    + [aldi_branch](https://github.com/FMartine7i/moodify_api/tree/aldi_branch)
    + [jessi_branch](https://github.com/FMartine7i/moodify_api/tree/jessii_branch)

## Descripción
**moodify** es una app que permite a los usuarios encontrar playlists, canciones y álbums basados en su **estado de ánimo** actual.

## Documentación
### Requerimientos previos
> [!NOTE]
> Tener instalado Flutter SDK y Dart. Editor de código recomendado: Visual Studio Code.
### Instalación
> - Clonar repositorio del Frontend: ``https://github.com/AldanaAranda/Moodify-App.git``
> - ``cd flutter_app_2024``
> - Instalar dependencias con: ``flutter pub get``
### Ejecución
> ``flutter run``
### Estructura
> - ``pubspec.yaml``: contiene las dependencias de la app
> - ``lib``: contiene la lógica de la app
> - ``screens``: contiene los archivos de cada pantalla
> - ``widgets``: contiene los widgets de la app
> - ``main.dart``: contiene el punto de entrada de la app

> ### flutter_app_2024
> - ├── lib/
> - │   ├── helpers/
> - │   │   ├── preferences.dart
> - │   │   ├── theme_provider.dart
> - │   ├── main.dart
> - │   ├── mocks/
> - │   │   ├── albumes_mock.dart
> - │   │   ├── songs_mock.dart
> - │   │   ├── usuario_mock.dart
> - │   ├── screens/
> - │   │   ├── album_individual.dart
> - │   │   ├── albu_list_screen.dart
> - │   │   ├── home_screen.dart
> - │   │   ├── login_screen.dart
> - │   │   ├── profile_screen
> - │   │   ├── songs.dart
> - │   │   ├── songs_list_screen.dart
> - │   │   ├── songs_list_item.dart
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



### State Management
* providers implementados

    | provider | descripción |
    |---|---|
    | **theme provider** | Permite alternar entre tema claro y oscuro.   


### Funcionalidades
* funcionalidades implementadas
    | funcionalidad | descripción |
    |---|---|
    | **cambiar tema** | permite cambiar entre tema claro y oscuro.
    | **login** | permite iniciar sesión con usuario y contraseña.
    | **mostrar canciones** | permite mostrar canciones de un álbum.
    | **mostrar canción** | permite mostrar canción individual.
    | **mostrar álbumes** | permite mostrar álbumes de un artista.

### Roadmap
Constituir el backend con ``Node.Js`` para integrar la API de Spotify para obtener información de canciones, álbumes y artistas.