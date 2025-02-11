class ApiResponse {
  String status;
  List<Playlist> data;

  ApiResponse({
    required this.status,
    required this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
        status: json["status"],
        data: List<Playlist>.from(json["data"].map((x) => Playlist.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Playlist {
  int customId;
  String nombre;
  String imagen;
  String enlaceSpotify;

  Playlist({
    required this.customId,
    required this.nombre,
    required this.imagen,
    required this.enlaceSpotify,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) => Playlist(
        customId: json["customId"],
        nombre: json["nombre"],
        imagen: json["imagen"],
        enlaceSpotify: json["enlaceSpotify"],
      );

  Map<String, dynamic> toJson() => {
        "customId": customId,
        "nombre": nombre,
        "imagen": imagen,
        "enlaceSpotify": enlaceSpotify,
      };
}
