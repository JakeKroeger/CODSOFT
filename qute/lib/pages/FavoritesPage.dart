import 'package:flutter/material.dart';
import 'package:qute/models/quote_item.dart';
import 'package:qute/models/quote.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavoritesPage extends StatefulWidget {
  final List<Quote> favoriteQuotes;
  final Function(Quote)
      onUnfavorite; // Callback to update the quote on the main page

  FavoritesPage({required this.favoriteQuotes, required this.onUnfavorite});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    // Load favorites when the page is initialized
    _loadFavorites();
  }

  // Save favorites to SharedPreferences
  Future<void> _saveFavorites(List<Quote> favoriteQuotes) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = favoriteQuotes.map((quote) => quote.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    await prefs.setString('favoriteQuotes', jsonString);
  }

  // Load favorites from SharedPreferences
  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('favoriteQuotes');
    if (jsonString != null) {
      final jsonList = jsonDecode(jsonString) as List;
      final loadedFavorites =
          jsonList.map((json) => Quote.fromJson(json)).toList();
      setState(() {
        widget.favoriteQuotes.clear();
        widget.favoriteQuotes.addAll(loadedFavorites);
      });
    }
  }

  void _handleFavorite(Quote quote) {
    setState(() {
      widget.favoriteQuotes.remove(quote);
      quote.isFavorite = false;
      _saveFavorites(widget.favoriteQuotes); // Save changes
    });
    widget.onUnfavorite(quote);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Quotes',
            style: GoogleFonts.chakraPetch(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                color: Color(0xFFECECEC))),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2D2E35), Color(0xFF383941)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(0), // Rounded corners
        ),
        child: ListView.builder(
          itemCount: widget.favoriteQuotes.length,
          itemBuilder: (context, index) {
            return QuoteItem(
              quote: widget.favoriteQuotes[index],
              favoriteDeleted: () =>
                  _handleFavorite(widget.favoriteQuotes[index]),
            );
          },
        ),
      ),
    );
  }
}
