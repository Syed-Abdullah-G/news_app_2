import 'dart:convert';

import 'package:news/model/news_model.dart';
import "package:http/http.dart" as http;

class NewsRepo {

  Future<NewsModel> fetchNews() async {
    String url = "https://newsapi.org/v2/top-headlines?sources=the-hindu,the-times-of-india&apiKey=0688714009f74cacaefca3e171eeb7e8";
    final response = await http.get(Uri.parse(url));

    if(response.statusCode == 200) {
      final body = jsonDecode(response.body);

      return NewsModel.fromJson(body);
    }
    throw Exception("Error");
  }





}