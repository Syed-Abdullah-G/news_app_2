import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news/model/news_model.dart';
import 'package:news/view/view_model/new_view_model.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  final format = DateFormat("MMM dd, yyyy");
  NewsViewModel newsViewModel = NewsViewModel();
  String categoryName = "General";





  List<String> categoriesList = [
    "General",
    "Entertainment",
    "Health",
    "Sports",
    "Business",
    "Technology"
  ];
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home",
          style: GoogleFonts.poppins(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SizedBox(height: 40,
            child: ListView.builder(scrollDirection: Axis.horizontal,itemCount: categoriesList.length,itemBuilder: 
            (context, index) {
                return InkWell(
                  onTap: () {
                    categoryName = categoriesList[index];
                    setState(() {
                      
                    });
                  },
                  child: Padding(padding: EdgeInsets.only(right: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: categoryName == categoriesList[index] ? Colors.blueAccent : Color.fromRGBO(220, 220, 220, 1),
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Padding(padding: 
                    EdgeInsets.symmetric(horizontal: 12),
                    child: Center(child: Text(categoriesList[index].toString(),style: GoogleFonts.poppins(fontSize: 13,
                    color: Colors.black54),),),),
                  ),),
                );
            }),),
          ),
          SizedBox(height: height* .001,),
          Expanded(child: 
          FutureBuilder<NewsModel>(future: newsViewModel.fetchNews(), builder: (BuildContext context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: SpinKitCircle(
                  size: 50,
                  color: Colors.black,
                ),
              );
            } else {
              
              final results = snapshot.data!.articles!;
              return ListView.builder(itemCount: snapshot.data!.articles!.length,itemBuilder: (context, index) {

                DateTime dateTime = DateTime.parse(results[index].publishedAt.toString());
                  return ListTile(
          title: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                children: [
                  Text(results[index].source!.name.toString())
                  
                ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    Text(results[index].title.toString()),
                    
                  ],
                ),
              ),
            ],
          ),subtitle: Text(format.format(dateTime)),
                  );
              });
            }
          }))
        ],
      ),
    );
  }
}

