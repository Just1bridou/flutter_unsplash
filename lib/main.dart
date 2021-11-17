import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unsplashflutter/server.dart';

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
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ServerManager server = ServerManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Unsplash")),
      body: FutureBuilder<List<UnsplashImage>>(
        future: server.getRandomImages(), // async work
        builder: (BuildContext context,
            AsyncSnapshot<List<UnsplashImage>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(color: Colors.black),
              );
            default:
              if (snapshot.hasError && snapshot.data != null)
                return Text('Error: ${snapshot.error}');
              else {
                return view(snapshot);
              }
          }
        },
      ),
    );
  }
}

Widget view(AsyncSnapshot<List<UnsplashImage>> snapshot) {
  if (snapshot.data == null) {
    return Text("No datas found");
  }

  return SingleChildScrollView(
      child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("Photos",
          textAlign: TextAlign.left,
          style: GoogleFonts.rubik(
              textStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 50.0))),
      GridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        childAspectRatio: (.7 / 1),
        crossAxisSpacing: 0,
        children: List.generate(snapshot.data!.length, (index) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                height: 500,
                width: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Image.network(
                    snapshot.data![index].fullUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    ],
  ));
}
