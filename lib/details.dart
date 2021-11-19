import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:unsplashflutter/server.dart';
import 'package:url_launcher/url_launcher.dart';
import 'main.dart';

class DetailPage extends StatefulWidget {
  final UnsplashImage image;

  const DetailPage({Key? key, required this.image}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.network(
              widget.image.regularUrl,
              fit: BoxFit.cover,
            )),
        Positioned(
            left: MediaQuery.of(context).size.width * 0.08,
            top: 50,
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  color: Color(0xFF111111), shape: BoxShape.circle),
              child: GestureDetector(
                child: Icon(Icons.arrow_back, color: Colors.white),
                onTap: () {
                  goToHomePage();
                },
              ),
            )),
        Positioned(
            bottom: 30,
            child: ClipRect(
                child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: MediaQuery.of(context).size.height * 0.25,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: SingleChildScrollView(
                            child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5),
                                        child: Container(
                                            height: 30,
                                            width: 30,
                                            child: CircleAvatar(
                                              radius: 45,
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(45),
                                                  child: Image.network(
                                                    widget
                                                        .image.userProfileImage,
                                                    //fit: BoxFit.cover,
                                                  )),
                                            ))),
                                    Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5),
                                        child: Text("by",
                                            style: GoogleFonts.varelaRound(
                                                textStyle: TextStyle(
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.w100,
                                                    fontSize: 15)))),
                                    Flexible(
                                        child: Text(widget.image.userName,
                                            style: GoogleFonts.varelaRound(
                                                textStyle: TextStyle(
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15))))
                                  ],
                                )),
                            widget.image.description != null
                                ? Padding(
                                    padding: const EdgeInsets.all(3),
                                    child: Container(
                                      child: Flexible(
                                          child: Text(widget.image.description!,
                                              style: GoogleFonts.varelaRound(
                                                  textStyle: TextStyle(
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w100,
                                                      fontSize: 15)))),
                                    ))
                                : Container(),
                            Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: Row(
                                  children: [
                                    Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5),
                                        child: customButton(context, 'Download',
                                            Color(0xFF111111), () {
                                          print('download');
                                          downloadImage(
                                              widget.image.regularUrl);
                                        })),
                                    customButton(
                                        context, 'Profile', Colors.transparent,
                                        () {
                                      openProfile(widget.image.userProfileUrl);
                                    }, border: Colors.white)
                                  ],
                                ))
                          ],
                        )),
                      ),
                    ))))
      ],
    ));
  }

  Widget customButton(
      BuildContext context, String text, Color background, Function() onPress,
      {Color? border}) {
    return RawMaterialButton(
      fillColor: background,
      onPressed: onPress,
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Text(text,
              style: GoogleFonts.varelaRound(
                  textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              )))),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: BorderSide(
              color: border != null ? border : background, width: 2)),
    );
  }

  void goToHomePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  void downloadImage(String url) async {
    var response = await get(Uri.parse(url));
    var documentDirectory = await getApplicationDocumentsDirectory();
    var firstPath = documentDirectory.path + "/images";
    var filePathAndName = documentDirectory.path + '/images/pic.jpg';

    await Directory(firstPath).create(recursive: true);
    File file2 = new File(filePathAndName);
    file2.writeAsBytesSync(response.bodyBytes);

    print(filePathAndName);
    print("download end");
  }

  void openProfile(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("can't open url");
    }
  }
}
