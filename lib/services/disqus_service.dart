import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/review_model.dart';

class DisqusService {
  // API Key kamu
  final String _publicKey = 'f9NLfCN8SZKDuhMlbvJOCREyJo2ksWSBB0pQgwtWVauu8xCrMfJeZfJOVWsylozn'; 
  
  // Pastikan nama forum ini benar
  final String _forumShortname = 'blog-android'; 

  Future<List<Review>> fetchReviews() async {
    // PERBAIKAN: Mengubah 'threads' menjadi 'forums' agar tidak error 400
    final url = Uri.parse(
        'https://disqus.com/api/3.0/forums/listPosts.json?api_key=$_publicKey&forum=$_forumShortname');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> responseList = data['response'];
        
        return responseList.map((e) => Review.fromJson(e)).toList();
      } else {
        throw Exception('Gagal mengambil data: Kode ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error jaringan: $e');
    }
  }
}