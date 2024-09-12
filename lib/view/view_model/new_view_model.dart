import 'package:news/model/news_model.dart';
import 'package:news/model/repository/news_repo.dart';

class NewsViewModel{

  final _rep = NewsRepo();

  Future<NewsModel> fetchNews() async {
    final response = await _rep.fetchNews();
    return response;
    
  }
}