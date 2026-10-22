import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'screen_arguments.dart';
import 'tujuan.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  var title, thumbnail, shortDescription, description;
  var genre, platform, release, cover, gameid, publisher;

  Future getGame(String id) async {
    try {
      http.Response response = await http.get(
        Uri.parse('https://www.freetogame.com/api/game?id=$id'),
        // Menggunakan User-Agent untuk menghindari blokir dari API publik
        headers: {
          "Accept": "application/json",
          "User-Agent": "Mozilla/5.0"
        }
      );

      if (response.statusCode == 200) {
        var results = jsonDecode(response.body);
        setState(() {
          gameid = id;
          title = results['title'];
          thumbnail = results['thumbnail'];
          shortDescription = results['short_description'];
          description = results['description'];
          genre = results['genre'];
          platform = results['platform'];
          publisher = results['publisher'];
          release = results['release_date'];
          cover = results['screenshots'][0]['image'];
        });
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getGame('475'); // Ambil 1 game default
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0081c9),
      body: SafeArea(
        child: Center(
          child: gameid == null
              ? const CircularProgressIndicator(color: Colors.white)
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Navigasi ke halaman tujuan dengan argumen
                        Navigator.pushNamed(
                          context,
                          Tujuan.routeName,
                          arguments: ScreenArguments(
                            cover,
                            title,
                            description,
                            shortDescription,
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        margin: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            Image.network(thumbnail),
                            const SizedBox(height: 15),
                            Text(
                              title,
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Genre: $genre"),
                                    Text("Platform: $platform"),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Publisher: $publisher"),
                                    Text("Release: $release"),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}