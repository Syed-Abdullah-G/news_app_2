import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news/model/news_model.dart';
import 'package:news/view/Query_screen.dart';
import 'package:news/view/details_screen.dart';
import 'package:news/view/view_model/new_view_model.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  


  shareUri(String url) async {
    final result = await Share.share(url);

    if (result.status == ShareResultStatus.success) {
    }
  }

  final format = DateFormat("MMM dd, yyyy");
  NewsViewModel newsViewModel = NewsViewModel();
  String countryName = "International";

  List<String> countryList = [
    "International",
    "Business",
    "Entertainment",
    "General",
    "Health",
    "Science",
    "Sports",
    "Technology"
  ];

  @override
  
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                height: 40,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: countryList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          countryName = countryList[index];
                          setState(() {});
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: 12),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Center(
                                child: Text(
                                  countryList[index].toString(),
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      color: countryName == countryList[index]
                                          ? Colors.black
                                          : Colors.grey),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
            SizedBox(
              height: height * .001,
            ),
            Expanded(
                child: FutureBuilder<NewsModel>(
                    future: newsViewModel.fetchNewsByCountry(countryName),
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: SpinKitCircle(
                            size: 50,
                            color: Colors.black,
                          ),
                        );
                      } else {
                        final results = snapshot.data!.articles!;
                        return ListView.builder(
                            itemCount: snapshot.data!.articles!.length,
                            itemBuilder: (context, index) {
                              DateTime dateTime = DateTime.parse(
                                  results[index].publishedAt.toString());
                              return Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => DetailsScreen(
                                                  source: results[index]
                                                      .source!
                                                      .name
                                                      .toString(),
                                                  author: results[index]
                                                      .author
                                                      .toString(),
                                                  title: results[index]
                                                      .title
                                                      .toString(),
                                                  description: results[index]
                                                      .description
                                                      .toString(),
                                                  url: results[index]
                                                      .url
                                                      .toString(),
                                                  urlToImage: results[index]
                                                      .urlToImage
                                                      .toString(),
                                                  publishedAt: results[index]
                                                      .publishedAt
                                                      .toString(),
                                                  content: results[index]
                                                      .content
                                                      .toString())));
                                    },
                                    child: Container(
                                      child: ListTile(
                                        title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            //add poster image
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                imageUrl: results[index]
                                                    .urlToImage
                                                    .toString(),
                                                placeholder: (context, url) =>
                                                    Container(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Container(),
                                              ),
                                            ),
                                            Text(
                                              results[index].title.toString(),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.faustina(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                          ],
                                        ),
                                        subtitle: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              format.format(dateTime),
                                              textAlign: TextAlign.start,
                                            ),
                                            Row(
                                              children: [
                                                IconButton(
                                                    onPressed: () {
                                                      shareUri(results[index]
                                                          .url
                                                          .toString());
                                                    },
                                                    icon:
                                                        Icon(Icons.ios_share_rounded)),
                                                        TextButton(onPressed: (){
                                                      Navigator.push(context, MaterialPageRoute(builder:  (context) => QueryScreen(title : results[index].title.toString(), description: results[index].content.toString(),),));

                                                    }, child: GradientText("AI", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),colors: [
                                                      Colors.blue,Colors.red,Colors.teal
                                                    ],))
                                              ],
                                            ),
                                                    

                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Divider()
                                ],
                              );
                            });
                      }
                    }))
          ],
        ),
      ),
    );
  }
}
