
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';


class MyHomePage extends StatefulWidget {
  final String fileUrl;
  final String title;
  const MyHomePage({Key? key, required this.fileUrl, this.title = "CV.pdf"}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<String?> getFileFromUrl(String url) async {
    try {
      var data = await http.get(Uri.parse(url));
      var bytes = data.bodyBytes;
      var dir = await getTemporaryDirectory();
      /// '/data/user/0/com.fcai_usc.team_finder/cache/CV.pdf'
      String filePath = "${dir.path}/CV.pdf";
      File file = File(filePath);
      await file.writeAsBytes(bytes);
      return filePath;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 5,
        automaticallyImplyLeading: false,

        title: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black)
            ),

            Text(
              widget.title,
              style: const TextStyle(
                fontWeight: FontWeight.w600
              ),
            ),
          ],
        ),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(20),
          bottomLeft: Radius.circular(20)
        )),
      ),

      body: FutureBuilder(
        future: getFileFromUrl(widget.fileUrl),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return PDFView(filePath: snapshot.data);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      )
    );
  }
}

