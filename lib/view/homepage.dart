import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news/model/news_model.dart';
import 'package:news/view/details_screen.dart';
import 'package:news/view/view_model/new_view_model.dart';
import 'package:share_plus/share_plus.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  shareUri(String url) async {
    final result = await Share.share(url);

    if (result.status == ShareResultStatus.success) {
      print("Shared Successfully");
    }
  }

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
            child: SizedBox(
              height: 40,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categoriesList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        categoryName = categoriesList[index];
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
                                categoriesList[index].toString(),
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: categoryName == categoriesList[index]
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
                  future: newsViewModel.fetchNews(),
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
                            print(results[index].urlToImage.toString());
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
                                                  CircularProgressIndicator(),
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
                                          IconButton(
                                              onPressed: () {
                                                shareUri(results[index].url.toString());
                                              },
                                              icon: Icon(Icons.ios_share_rounded))
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
    );
  }
}
