import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'dart:html' as html; // Only works on web

void main() {
  runApp(QuoteApp());
}

class QuoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Motivational Quotes',
      theme: ThemeData.dark().copyWith(
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
        ),
      ),
      home: QuoteHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class QuoteHomePage extends StatefulWidget {
  @override
  _QuoteHomePageState createState() => _QuoteHomePageState();
}

class _QuoteHomePageState extends State<QuoteHomePage>
    with SingleTickerProviderStateMixin {
  final List<String> quotes = [
    "Believe in yourself!",
    "Never give up!",
    "Push your limits!",
    "Stay positive, work hard, make it happen.",
    "Success is not for the lazy.",
    "Dream it. Wish it. Do it.",
    "Great things take time.",
    "Your only limit is your mind.",
  ];

  String currentQuote = "Tap Inspire Me to begin!";
  late AnimationController _controller;
  late Animation<double> _animation;

  void showRandomQuote() {
    final random = Random();
    setState(() {
      currentQuote = quotes[random.nextInt(quotes.length)];
      _controller.forward(from: 0); // restart animation
    });
  }

  void copyToClipboard() {
    Clipboard.setData(ClipboardData(text: currentQuote));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Copied to clipboard!')));
  }

  void shareToTwitter() {
    final tweet = Uri.encodeComponent(currentQuote);
    final url = 'https://twitter.com/intent/tweet?text=$tweet';
    html.window.open(url, 'Share Quote');
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                'https://images.unsplash.com/photo-1506784365847-bbad939e9335?auto=format&fit=crop&w=1400&q=80',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.black.withOpacity(0.6),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeTransition(
                    opacity: _animation,
                    child: Text(
                      currentQuote,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Wrap(
                    spacing: 15,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: showRandomQuote,
                        icon: Icon(Icons.format_quote),
                        label: Text("Inspire Me"),
                      ),
                      ElevatedButton.icon(
                        onPressed: copyToClipboard,
                        icon: Icon(Icons.copy),
                        label: Text("Copy"),
                      ),
                      ElevatedButton.icon(
                        onPressed: shareToTwitter,
                        icon: Icon(Icons.share),
                        label: Text("Tweet"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
