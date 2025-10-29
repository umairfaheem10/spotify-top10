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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
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
        title: const Text('Top 10 Spotify Artists'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: top10,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data found.'));
          } else {
            final data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final artist = data[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green.shade100,
                      child: Text(artist['rank'].toString()),
                    ),
                    title: Text(artist['artist']),
                    subtitle: Text('${artist['listeners']} monthly listeners'),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
