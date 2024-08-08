import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qute/models/quote.dart'; 
import 'package:qute/services/quote_service.dart';
import 'package:qute/pages/FavoritesPage.dart';
import 'dart:async';

import 'package:qute/services/quote_service.dart';

class QuotesPage extends StatefulWidget {
  @override
  _QuotesPageState createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPage> {
  late Future<Quote> futureQuote;

  @override
  void initState() {
    super.initState();
    futureQuote = QuoteService().fetchQuote()
  }

  void _refreshQuote() {
    setState(() {
      futureQuote = QuoteService().fetchQuote();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1C1D21),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(
            top: 16,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Quotes Application',
                style: GoogleFonts.oswald(
                    fontSize: 30.0,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFFECECEC)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            favoritePage()), // Use your favorite page widget here
                  );
                },
                child: Text(
                  'Favorites',
                  style: GoogleFonts.oswald(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[500]), // Light grey color
                ),
              ),
            ],
          ),
        ),
      ),

      extendBodyBehindAppBar: true, // Extend body behind the AppBar
      body: Center(
        child: FutureBuilder<Quote>(
          future: futureQuote,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData) {
              return Text('No quote available');
            } else {
              Quote quote = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10.0, // Space between items in the wrap
                  runSpacing: 10.0, // Space between rows in the wrap
                  children: [
                    Container(
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2D2E35), Color(0xFF383941)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius:
                            BorderRadius.circular(20), // Rounded corners
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '"${quote.quote}"',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.oswald(
                                fontSize: 35.0,
                                fontWeight: FontWeight.w300,
                                color: Color(0xFFECECEC)),
                          ),
                          const SizedBox(
                              height: 20), // Space between quote and author
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '- ${quote.author}',
                                style: GoogleFonts.oswald(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w100,
                                    color: Color(0xFFECECEC)),
                              ),
                              const SizedBox(width: 20.0),
                            ],
                          ),

                          const SizedBox(
                              height: 20.0), // Space before the button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(
                                    Icons.refresh), // Using the refresh icon
                                onPressed: () {
                                  // Action to perform on tap
                                  _refreshQuote(); // Replace with your refresh method
                                },
                                color: Colors.black54, // Customize icon color
                              ),
                              const SizedBox(height: 10.0),
                              IconButton(
                                icon: Icon(Icons.share),
                                onPressed: () {},
                                color: Colors.black54,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
