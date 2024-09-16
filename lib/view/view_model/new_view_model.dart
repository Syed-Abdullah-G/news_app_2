import 'package:news/model/news_model.dart';
import 'package:news/model/repository/news_repo.dart';

class NewsViewModel{

  final _rep = NewsRepo();

  Future<NewsModel> fetchNewsByCountry(String country) async {
   if (country == "International"){
      return await _rep.fetchNewsInternational();
    } else {
      return await _rep.fetchNewsCategory(country);
    }
 
    
  }

  

}