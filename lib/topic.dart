import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unsplashflutter/details.dart';
import 'package:unsplashflutter/server.dart';

class TopicPage extends StatefulWidget {
  final Topic topic;
  const TopicPage({Key? key, required this.topic}) : super(key: key);

  @override
  _TopicPageState createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {
  ServerManager server = ServerManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.topic.title),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: FutureBuilder<List<UnsplashImage>>(
            future: server.getTopicImages(widget.topic.id),
            builder: (BuildContext context,
                AsyncSnapshot<List<UnsplashImage>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  );
                default:
                  if (snapshot.hasError && snapshot.data != null) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return builderPhotos(snapshot);
                  }
              }
            },
          ),
        ));
  }

  Widget builderPhotos(AsyncSnapshot<List<UnsplashImage>> snapshot) {
    if (snapshot.data == null) {
      return const Text("No datas found");
    }

    return Padding(
        padding: const EdgeInsets.only(
            left: 5.0, right: 5.0, top: 20.0, bottom: 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Photos",
                textAlign: TextAlign.left,
                style: GoogleFonts.varelaRound(
                    textStyle: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 35.0))),
            GridView.count(
              padding: const EdgeInsets.all(0),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: (.7 / 1),
              crossAxisSpacing: 0,
              children: List.generate(snapshot.data!.length, (index) {
                return photoSquare(snapshot.data![index]);
              }),
            ),
          ],
        ));
  }

  Widget photoSquare(UnsplashImage image) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          height: 500,
          width: 200,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            child: GestureDetector(
              child: Image.network(
                image.regularUrl,
                fit: BoxFit.cover,
              ),
              onTap: () {
                goToDetails(image);
              },
            ),
          ),
        ),
      ),
    );
  }

  void goToDetails(UnsplashImage image) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DetailPage(
                image: image,
              )),
    );
  }
}
