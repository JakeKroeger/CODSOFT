import 'package:flutter/material.dart';
import 'package:qute/models/quote_item.dart';
import 'package:qute/models/quote.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavoritesPage extends StatefulWidget {
  final List<Quote> favoriteQuotes;
  final Function(Quote) onUnfavorite;

  FavoritesPage({required this.favoriteQuotes, required this.onUnfavorite});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

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

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList =
        widget.favoriteQuotes.map((quote) => quote.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    await prefs.setString('favoriteQuotes', jsonString);
  }

  void _handleUnfavorite(Quote quote) {
    setState(() {
      widget.favoriteQuotes.removeWhere((q) => q.quote == quote.quote);
      _saveFavorites();
    });
    widget.onUnfavorite(quote); // Notify the parent
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
        ),
        child: ListView.builder(
          itemCount: widget.favoriteQuotes.length,
          itemBuilder: (context, index) {
            final quote = widget.favoriteQuotes[index];
            return QuoteItem(
              quote: quote,
              favoriteDeleted: () => _handleUnfavorite(quote),
            );
          },
        ),
      ),
    );
  }
}
