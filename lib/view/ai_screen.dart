import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:news/consts.dart';

class AiScreen extends StatefulWidget {
  const AiScreen({super.key, required this.question, required this.news});
  final String news;
  final String question;

  @override
  State<AiScreen> createState() => _AiScreenState();
}

class _AiScreenState extends State<AiScreen> {
  String generatedString = "";
  bool isLoading = false;

  Future<void> generateInsight() async {
    setState(() {
      isLoading = true;
    });

    try {
      final model =
          GenerativeModel(model: "gemini-1.5-flash-002", apiKey: GEMINI_API_KEY);
      final response =
          await model.generateContent([Content.text("from this given news and the web : ${widget.news} explain for the quesiton ${widget.question}")]);
      final formated_response = response.text;

      if (formated_response != null) {
        setState(() {
          generatedString = formated_response;
        });
      } else {
        setState(() {
          generatedString = "No Data";
        });
      }
    } catch (e) {
      setState(() {
        generatedString = "Exception Occurred";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    generateInsight();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              generatedString.isNotEmpty?
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
              generatedString.isNotEmpty ? 
              Expanded(child: 
              Markdown(data: generatedString)) : Center(child: SpinKitFadingCircle(
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
        ));
  }
}
