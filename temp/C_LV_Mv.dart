import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Recs',
      home: MovieScreen(),
    );
  }
}

class MovieScreen extends StatelessWidget {
  final List<Map<String, String>> movies = [
    {'title': 'Inception', 'genre': 'Sci-Fi', 'rating': '8.8'},
    {'title': 'The Godfather', 'genre': 'Drama', 'rating': '9.2'},
    {'title': 'Pulp Fiction', 'genre': 'Crime', 'rating': '8.9'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Movie Recommendations'), backgroundColor: Colors.indigo),
      body: ListView.builder(
        itemCount: movies.length,
        padding: EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: Colors.indigo[100],
                child: Icon(Icons.movie, color: Colors.indigo),
              ),
              title: Text(movie['title']!, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Genre: ${movie['genre']}', style: TextStyle(color: Colors.grey[600])),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      SizedBox(width: 4),
                      Text('Rating: ${movie['rating']}'),
                    ],
                  ),
                ],
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tapped ${movie['title']}'))),
            ),
          );
        },
      ),
    );
  }
}