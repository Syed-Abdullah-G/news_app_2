import 'dart:convert';

import 'package:news/model/news_model.dart';
import "package:http/http.dart" as http;

class NewsRepo {
  Future<NewsModel> fetchNewsInternational() async {
    String url =
        "https://newsapi.org/v2/everything?sources=cnn,msnbc,fox-news,bbc-news&pageSize=100&sortBy=publishedAt&language=en&apiKey=0688714009f74cacaefca3e171eeb7e8";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
// Create NewsModel object
      NewsModel newsModel = NewsModel.fromJson(body);

      // Filter out articles containing "[removed]"
      newsModel.articles = newsModel.articles!.where((article) {
        return !((article.title ?? "").toLowerCase().contains("gmt") ||
            (article.title ?? "").toLowerCase().contains("[removed]") ||
            (article.description ?? "").toLowerCase().contains("[removed]"));
      }).toList();

      return newsModel;
    }
    throw Exception("Error");
  }

  Future<NewsModel> fetchNewsCategory(String category) async {
    String url =
        "https://newsapi.org/v2/top-headlines?category=${category.toLowerCase()}&language=en&apiKey=0688714009f74cacaefca3e171eeb7e8";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
// Create NewsModel object
      NewsModel newsModel = NewsModel.fromJson(body);

      // Filter out articles containing "[removed]"
      newsModel.articles = newsModel.articles!.where((article) {
        return !(article.title?.toLowerCase().contains('[removed]') ??
            false || article.description!.toLowerCase().contains('[removed]') ??
            false);
      }).toList();

      return newsModel;
    }
    throw Exception("Error");
  }
}
