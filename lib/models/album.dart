import 'dart:convert';

AlbumResponse albumResponseFromJson(String str) => AlbumResponse.fromJson(json.decode(str));

String albumResponseToJson(AlbumResponse data) => json.encode(data.toJson());

class AlbumResponse {
    String status;
    List<Album> data;

    AlbumResponse({
        required this.status,
        required this.data,
    });

    factory AlbumResponse.fromJson(Map<String, dynamic> json) => AlbumResponse(
        status: json["status"],
        data: List<Album>.from(json["data"].map((x) => Album.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Album {
    int customId;
    String name;
    List<String> artists;
    String releaseDate;
    int totalTracks;
    String image;
    String id;

    Album({
        required this.customId,
        required this.name,
        required this.artists,
        required this.releaseDate,
        required this.totalTracks,
        required this.image,
        required this.id,
    });

    factory Album.fromJson(Map<String, dynamic> json) => Album(
        customId: json["customId"],
        name: json["name"],
        artists: List<String>.from(json["artists"].map((x) => x)),
        releaseDate: json["release_date"],
        totalTracks: json["total_tracks"],
        image: json["image"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "customId": customId,
        "name": name,
        "artists": List<dynamic>.from(artists.map((x) => x)),
        "release_date": releaseDate,
        "total_tracks": totalTracks,
        "image": image,
        "id": id,
    };
}
