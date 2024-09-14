import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news/model/news_model.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsScreen extends StatefulWidget {
  final String source,
      author,
      title,
      description,
      url,
      urlToImage,
      publishedAt,
      content;

  DetailsScreen(
      {super.key,
      required this.source,
      required this.author,
      required this.title,
      required this.description,
      required this.url,
      required this.urlToImage,
      required this.publishedAt,
      required this.content});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  shareUri(String url) async {
    final result = await Share.share(url);

    if (result.status == ShareResultStatus.success) {
      print("Shared Successfully");
    }
  }

  final format = DateFormat("MMM dd, yyyy");

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    DateTime dateTime = DateTime.parse(widget.publishedAt);

    return Scaffold(backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Container(
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                )),
            actions: [
              IconButton(
                icon: Container(
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    Icons.ios_share_rounded,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  shareUri(widget.url);
                },
              ),
            ],
            expandedHeight: height * 0.4,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: widget.urlToImage,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Container(),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.only(top: 20, right: 20, left: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(40))),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.source,
                        style: GoogleFonts.dmSerifDisplay(fontSize: 24),
                      ),
                      Text(format.format(dateTime))
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.title,
                    style: GoogleFonts.ptSerif(
                        fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Text(
                    widget.description,
                    style: GoogleFonts.poppins(
                        fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () async {
                      final url = Uri.parse(widget.url);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {}
                    },
                    child: Text(
                      "Read More on Website",
                      style: GoogleFonts.breeSerif(
                          color: Colors.blue[600],
                          decoration: TextDecoration.underline),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
