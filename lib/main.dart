import 'package:flutter/material.dart';
import 'services/api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Spotify Top 10',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D1117),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF1DB954),
          secondary: Color(0xFF1DB954),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            color: Color(0xFFD0D0D0),
            fontFamily: 'FiraCode', // gives terminal vibe if available
          ),
        ),
      ),
      home: const Top10Page(),
    );
  }
}

class Top10Page extends StatefulWidget {
  const Top10Page({super.key});

  @override
  State<Top10Page> createState() => _Top10PageState();
}

class _Top10PageState extends State<Top10Page> {
  late Future<List<dynamic>> top10;

  @override
  void initState() {
    super.initState();
    top10 = ApiService.fetchTop10();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '🎧 Spotify Top 10',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF1DB954),
            fontFamily: 'FiraCode',
          ),
        ),
        backgroundColor: const Color(0xFF161B22),
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: top10,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Text(
                'Fetching latest data...',
                style: TextStyle(
                  color: Color(0xFF58A6FF),
                  fontFamily: 'FiraCode',
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.redAccent),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No data found.',
                style: TextStyle(color: Color(0xFF8B949E)),
              ),
            );
          } else {
            final data = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final artist = data[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF161B22),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF30363D)),
                    ),
                    child: Row(
                      children: [
                        Text(
                          '${artist['rank']}.',
                          style: const TextStyle(
                            color: Color(0xFF1DB954),
                            fontWeight: FontWeight.bold,
                            fontFamily: 'FiraCode',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            artist['artist'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'FiraCode',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Text(
                          '${artist['listeners']}',
                          style: const TextStyle(
                            color: Color(0xFF8B949E),
                            fontSize: 13,
                            fontFamily: 'FiraCode',
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
