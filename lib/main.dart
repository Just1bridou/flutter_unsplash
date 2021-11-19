import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unsplashflutter/details.dart';
import 'package:unsplashflutter/server.dart';
import 'package:unsplashflutter/topic.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unsplash',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ServerManager server = ServerManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        FutureBuilder<List<Topic>>(
          future: server.getTopics(),
          builder: (BuildContext context, AsyncSnapshot<List<Topic>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(color: Colors.black),
                );
              default:
                if (snapshot.hasError && snapshot.data != null) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return builderTopics(snapshot);
                }
            }
          },
        ),
        FutureBuilder<List<UnsplashImage>>(
          future: server.getRandomImages(),
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
      ],
    )));
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

  void goToTopic(Topic topic) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => TopicPage(
                topic: topic,
              )),
    );
  }

  Widget builderTopics(AsyncSnapshot<List<Topic>> snapshot) {
    if (snapshot.data == null) {
      return const Text("No datas found");
    }

    return Padding(
        padding: const EdgeInsets.only(
            left: 5.0, right: 5.0, top: 50.0, bottom: 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Topics",
                textAlign: TextAlign.left,
                style: GoogleFonts.varelaRound(
                    textStyle: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 35.0))),
            SizedBox(
                width: double.infinity,
                height: 130,
                child: GridView.count(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(0),
                  shrinkWrap: true,
                  crossAxisCount: 1,
                  crossAxisSpacing: 0,
                  children: List.generate(snapshot.data!.length, (index) {
                    return topicRound(snapshot.data![index]);
                  }),
                )),
          ],
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

  Widget topicRound(Topic image) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              height: 80,
              width: 80,
              child: GestureDetector(
                child: CircleAvatar(foregroundImage: NetworkImage(image.cover)),
                onTap: () {
                  goToTopic(image);
                },
              )),
          Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(image.title,
                  style: GoogleFonts.varelaRound(
                      textStyle: const TextStyle(
                          color: Colors.black87, fontSize: 12))))
        ],
      ),
    ));
  }
}
