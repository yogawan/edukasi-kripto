import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:3100', // URL Proxy Node.js
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<List<dynamic>> fetchCryptoListings() async {
    try {
      final response = await _dio.get('/api/crypto');
      return response.data['data'];
    } on DioException catch (e) {
      print('Error: ${e.response?.data ?? e.message}');
      return [];
    } catch (e) {
      print('Unexpected error: $e');
      return [];
    }
  }

  Future<List<dynamic>> fetchCryptoNews() async {
    try {
      final response = await _dio.get('/api/news');
      return response.data['articles']; // NewsAPI returns articles in "articles" key
    } on DioException catch (e) {
      print('Error: ${e.response?.data ?? e.message}');
      return [];
    } catch (e) {
      print('Unexpected error: $e');
      return [];
    }
  }
}
