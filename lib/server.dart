import 'dart:convert';
import 'dart:ui';

import 'package:http/http.dart' as http;

class ServerManager {
  String API_KEY = "1d77BmxyP7CIN-itrl8HEYC7fQUiSOaJ2m11C1Ry_ZU";
  String baseURL = "https://api.unsplash.com/";

  Future<List<UnsplashImage>> getRandomImages() async {
    final response = await http.get(Uri.parse(baseURL + "photos?per_page=40"),
        headers: {"Authorization": "Client-ID " + API_KEY});

    var decodeResponse = jsonDecode(response.body);

    return List<UnsplashImage>.from(
        decodeResponse.map((i) => UnsplashImage.fromJson(i)));
  }

  Future<List<Topic>> getTopics() async {
    final response = await http.get(Uri.parse(baseURL + "topics?per_page=20"),
        headers: {"Authorization": "Client-ID " + API_KEY});

    var decodeResponse = jsonDecode(response.body);

    return List<Topic>.from(decodeResponse.map((i) => Topic.fromJson(i)));
  }

  Future<List<UnsplashImage>> getTopicImages(String id) async {
    final response = await http.get(
        Uri.parse(baseURL + "topics/" + id + "/photos?per_page=20"),
        headers: {"Authorization": "Client-ID " + API_KEY});

    var decodeResponse = jsonDecode(response.body);

    return List<UnsplashImage>.from(
        decodeResponse.map((i) => UnsplashImage.fromJson(i)));
  }
}

class Topic {
  String id;
  String title;
  String cover;

  Topic(this.id, this.title, this.cover);

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      json["id"],
      json["title"],
      json["cover_photo"]["urls"]["regular"],
    );
  }
}

class UnsplashImage {
  String id;
  String? description;
  String regularUrl;
  String fullUrl;
  String rawUrl;
  String userName; //Attribution to the photographer
  String userProfileUrl; //Photographer's profile
  String userProfileImage; //Photographer's profile image
  int likes;
  String? blurHash; //Optional
  String? downloadLocation; //Optional

  UnsplashImage(
    this.id,
    this.description,
    this.regularUrl,
    this.fullUrl,
    this.rawUrl,
    this.userName,
    this.userProfileUrl,
    this.userProfileImage,
    this.likes,
    this.blurHash,
    this.downloadLocation,
  );

  factory UnsplashImage.fromJson(Map<String, dynamic> json) {
    return UnsplashImage(
      json["id"],
      json["description"],
      json["urls"]["regular"],
      json["urls"]["full"],
      json["urls"]["raw"],
      json["user"]["username"],
      json["user"]["links"]["self"],
      json["user"]["profile_image"]["medium"],
      json["likes"],
      json["blur_hash"],
      json["downloadLocation"],
    );
  }
}
