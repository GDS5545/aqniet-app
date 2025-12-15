import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AqnietApp());
}

class AqnietApp extends StatelessWidget {
  const AqnietApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AQNIET',
      home: AqnietWebView(),
    );
  }
}

class AqnietWebView extends StatefulWidget {
  const AqnietWebView({super.key});

  @override
  State<AqnietWebView> createState() => _AqnietWebViewState();
}

class _AqnietWebViewState extends State<AqnietWebView> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) async {
            final url = request.url.toLowerCase();

            // 🔥 ПЕРЕХВАТ PDF И ФАЙЛОВ
            if (url.contains('.pdf') ||
                url.contains('/uploads/') ||
                url.contains('download') ||
                url.contains('wpforms')) {
              await launchUrl(
                Uri.parse(request.url),
                mode: LaunchMode.externalApplication,
              );
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(
        Uri.parse('https://uchet.zdravunion.kz'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebViewWidget(controller: controller),
      ),
    );
  }
}
