
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebView extends StatelessWidget {
  final String url;
  final String? title;
  const WebView({Key? key, required this.url, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));


    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey[100],
        toolbarHeight: 60,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),

        title: Row(
          children: [
            IconButton(
              onPressed: () { Navigator.of(context).pop(); },
              icon: const Icon(Icons.arrow_back_ios)
            ),

            Text(
              title ?? "WebView",
              style: const TextStyle(
                fontWeight: FontWeight.w600
              ),
            ),
          ],
        ),
      ),

      body: WebViewWidget(controller: controller)
    );
  }
}



