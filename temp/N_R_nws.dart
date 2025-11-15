import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      initialRoute: '/',
      routes: {
        '/': (context) => NewsListScreen(),
        '/article': (context) => ArticleScreen(),
      },
    );
  }
}

class NewsListScreen extends StatelessWidget {
  final List<Map<String, String>> articles = [
    {'title': 'Tech Breakthrough', 'id': '1'},
    {'title': 'World News Update', 'id': '2'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('News'), backgroundColor: Colors.red),
      body: ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];
          return ListTile(
            title: Text(article['title']!),
            trailing: Icon(Icons.arrow_forward),
            onTap: () => Navigator.pushNamed(
              context,
              '/article',
              arguments: {'title': article['title'], 'id': article['id']},
            ),
          );
        },
      ),
    );
  }
}

class ArticleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    return Scaffold(
      appBar: AppBar(title: Text('Article'), backgroundColor: Colors.red),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Article: ${args['title']}', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            Text('ID: ${args['id']}', style: TextStyle(fontSize: 16)),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}