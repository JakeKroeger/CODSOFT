import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qute/models/quote.dart';
import 'package:qute/services/quote_service.dart';
import 'package:qute/pages/FavoritesPage.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:share_plus/share_plus.dart';

class QuotesPage extends StatefulWidget {
  @override
  _QuotesPageState createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPage> {
  late Future<Quote> futureQuote;
  List<Quote> favQuotes = [];

  @override
  void initState() {
    super.initState();
    futureQuote = QuoteService().fetchQuote();
  }

  void _refreshQuote() {
    setState(() {
      futureQuote = QuoteService().fetchQuote();
    });
  }

  Future<void> _saveFavorites(List<Quote> favoriteQuotes) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = favoriteQuotes.map((quote) => quote.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    await prefs.setString('favoriteQuotes', jsonString);
  }

  void _handleFavorite(Quote quote) {
    setState(() {
      quote.isFavorite = !quote.isFavorite;
      if (quote.isFavorite) {
        favQuotes.add(quote);
      } else {
        favQuotes.remove(quote);
      }
      _saveFavorites(favQuotes);
    });
  }

  void _navigateToFavorites() async {
    final updatedFavorites = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FavoritesPage(
          favoriteQuotes: favQuotes,
          onUnfavorite: (Quote quote) {
            setState(() {
              // Update the main page state with the unfavorited quote
              quote.isFavorite = false;
            });
          },
        ),
      ),
    );

    if (updatedFavorites != null) {
      setState(() {
        favQuotes = updatedFavorites;
      });
    }
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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Quotes Application',
                style: GoogleFonts.chakraPetch(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFFECECEC)),
              ),
              Spacer(),
              TextButton(
                onPressed: _navigateToFavorites,
                child: Text(
                  'Favorites',
                  style: GoogleFonts.chakraPetch(
                      fontSize: 15.0,
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
                padding: const EdgeInsets.all(12.0),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2D2E35), Color(0xFF383941)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius:
                            BorderRadius.circular(0), // Rounded corners
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //-------------------QUOTE-----------------------
                          SizedBox(height: 50.0),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 30.0, left: 30, top: 30),
                            child: Text(
                              '"${quote.quote}"',
                              textAlign: TextAlign.justify,
                              style: GoogleFonts.chakraPetch(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFFECECEC)),
                            ),
                          ),
                          // Space between quote and author
                          //-----------------Author--------------------
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 30, top: 10),
                                child: Text(
                                  '~${quote.author}',
                                  style: GoogleFonts.chakraPetch(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w100,
                                      color: Color(0xFFECECEC)),
                                ),
                              ),
                            ],
                          ),

                          //-------------------Button---------------------
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
                                color: Colors.grey[700], // Customize icon color
                              ),
                              IconButton(
                                icon: Icon(Icons.share),
                                onPressed: () {
                                  Share.share(
                                      '${quote.quote} - ${quote.author}');
                                },
                                color: Colors.grey[700],
                              ),
                              IconButton(
                                onPressed: () {
                                  _handleFavorite(quote);
                                },
                                icon: Icon(quote.isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border),
                                color: Colors.grey[700],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          )
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
