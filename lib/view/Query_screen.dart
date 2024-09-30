import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart';
import 'package:news/consts.dart';
import 'package:news/view/ai_screen.dart';

class QueryScreen extends StatefulWidget {
  const QueryScreen(
      {super.key, required this.title, required this.description});

  final String title;
  final String description;

  @override
  State<QueryScreen> createState() => _QueryScreenState();
}

class _QueryScreenState extends State<QueryScreen> {
  final TextEditingController _searchcontroller = TextEditingController();
  bool isLoading = false;
  List<String> generatedQuestions = [];

  Future<void> getQuestions() async {
    setState(() {
      isLoading = true;
    });

    try {
      final model = GenerativeModel(
          model: "gemini-1.5-flash-002", apiKey: GEMINI_API_KEY);
      final response = await model.generateContent([
        Content.text(
            "Image yourself as a bot which provides real time questions about a given news headline, you need to provide questions that are useful for the users in order to understand the news headline completely, this is the news headline: ${widget.title} and this is the news content: ${widget.description}, also give answer in the form of quesitons and tiles, dont let the user know that you are a bot, behave like an article ,i dont want any title , i want only questions")
      ]);
      final formated_response = response.text;
      print(formated_response);

      if (formated_response != null) {
        setState(() {
          generatedQuestions = formated_response
              .split('\n')
              .map((question) => question.trim())
              .where((question) => question.isNotEmpty)
              .toList();
        });
      } else {
        setState(() {
          generatedQuestions = ["Error : Failed to generate questions"];
        });
      }
    } catch (e) {
      setState(() {
        generatedQuestions = ["Error : $e"];
      });
    } finally {
      setState(() {
        isLoading = false;
        //print(generatedQuestions);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            generatedQuestions.isNotEmpty?
            IconButton(
                onPressed: Navigator.of(context).pop,
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
                )): Container(),
            generatedQuestions.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                        itemCount: generatedQuestions.length,
                        itemBuilder: (context, index) {
                          String question = generatedQuestions[index];

                          return Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                    color:
                                        const Color.fromARGB(255, 71, 54, 132),
                                    width: 2)),
                            child: ListTile(
                              title: Text(
                                question,
                                style: GoogleFonts.breeSerif(fontSize: 17),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AiScreen(
                                            question:
                                                question.replaceAll("#*", ""),
                                            news: widget.title)));
                              },
                            ),
                          );
                        }),
                  )
                : Center(child: SpinKitFadingCircle(
                    itemBuilder: (BuildContext context, int index) {
                      return DecoratedBox(
                        decoration: BoxDecoration(
                          color: index.isEven ? Colors.red : Colors.green,
                        ),
                      );
                    },
                  ))
          ],
        ),
      ),
    );
  }
}
