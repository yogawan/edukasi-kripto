import 'dart:math';
import 'package:flutter/material.dart';
import 'package:app/screens/news/news_detail_screen.dart';
import 'package:app/services/api_service.dart';

class CryptoNewsScreen extends StatefulWidget {
  @override
  _CryptoNewsScreenState createState() => _CryptoNewsScreenState();
}

class _CryptoNewsScreenState extends State<CryptoNewsScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> _newsList = [];
  bool _isLoading = true;

  // Daftar path gambar lokal
  final List<String> placeholderImages = [
    'assets/news01.png',
    'assets/news02.png',
    'assets/news03.png',
    'assets/news04.png',
    'assets/news05.png',
    'assets/news06.png',
    'assets/news07.png',
  ];

  @override
  void initState() {
    super.initState();
    _fetchNewsData();
  }

  Future<void> _fetchNewsData() async {
    final news = await _apiService.fetchCryptoNews();
    setState(() {
      _newsList = news;
      _isLoading = false;
    });
  }

  String _getRandomPlaceholderImage() {
    final randomIndex = Random().nextInt(placeholderImages.length);
    return placeholderImages[randomIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _newsList.length,
              itemBuilder: (context, index) {
                final article = _newsList[index];
                final title = article['title'] ?? 'No Title';
                final description = article['description'] ?? 'No Description';

                return ListTile(
                  leading: Image.asset(
                    _getRandomPlaceholderImage(),
                    width: 150,
                  ),
                  title: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  subtitle: Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsDetailScreen(
                          title: title,
                          description: description,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
