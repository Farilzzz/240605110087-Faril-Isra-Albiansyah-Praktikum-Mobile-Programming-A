import 'package:flutter/material.dart';
import 'package:game_app/model/game.dart';
import 'package:game_app/viewmodel/fetchgame.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late Future<List<Game>> gameList;

  @override
  void initState() {
    super.initState();
    loadGames();
  }


  Future<List<Game>> loadGames() async {
    gameList = fetchGames();
    return gameList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amberAccent.shade400,
      body: SafeArea(
        child: Column(
          children: [
            _searchBar(),
            const SizedBox(height: 10),
            FutureBuilder<List<Game>>(
              future: fetchGames(), // Memanggil fungsi fetchGames dari viewmodel
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('Tidak ada data game.');
                } else {
                  final games = snapshot.data!.take(25).toList();
                  return Expanded(
                    child: ListView.builder(
                      itemCount: games.length,
                      itemBuilder: (context, index) {
                        final game = games[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/detail', // Route berlabel untuk halaman detail
                              arguments: game.id, // Mengirim id game ke halaman detail
                            );
                          },
                          child: _listItem(
                            game.thumbnail,
                            game.title,
                            game.genre,
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}


TextField _searchBar() {
  return TextField(
    cursorColor: Colors.blue,
    decoration: InputDecoration(
      fillColor: Colors.blue.shade50,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(width: 0, style: BorderStyle.none),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      prefixIcon: const Icon(
        Icons.search_outlined,
        color: Colors.blue,
        size: 30,
      ),
      hintText: 'Cari game',
      hintStyle: TextStyle(fontSize: 14, color: Colors.grey.withValues(alpha: 0.7)),
    ),
  );
}

Card _listItem(String urlCover, String judul, String genre) {
  return Card(
    clipBehavior: Clip.antiAlias,
    elevation: 3,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    child: ListTile(
      tileColor: Colors.blue.shade50,
      leading: SizedBox(
        width: 75,
        height: 75,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(urlCover, scale: 3, fit: BoxFit.cover),
        ),
      ),
      title: Text(judul),
      subtitle: Text(genre),
      trailing: const Icon(Icons.more_vert),
      isThreeLine: false,
      titleAlignment: ListTileTitleAlignment.center,
    ),
  );
}
