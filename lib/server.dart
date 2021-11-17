import 'dart:convert';
import 'dart:ui';

import 'package:http/http.dart' as http;

class ServerManager {
  String API_KEY = "1d77BmxyP7CIN-itrl8HEYC7fQUiSOaJ2m11C1Ry_ZU";
  String baseURL = "https://api.unsplash.com/photos";

  Future<List<UnsplashImage>> getRandomImages() async {
    final response = await http.get(Uri.parse(baseURL + "/random?count=20"),
        headers: {"Authorization": "Client-ID " + API_KEY});

    var decodeResponse = jsonDecode(response.body);

    print(decodeResponse);

    return List<UnsplashImage>.from(
        decodeResponse.map((i) => UnsplashImage.fromJson(i)));

    /*UnsplashImage img = UnsplashImage.fromJson(decodeResponse);

    imgsList.add(img);

    return imgsList;*/
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
  //Color? color; //Optional

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
    //this.color,
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
      // json["color"],
    );
  }
}
