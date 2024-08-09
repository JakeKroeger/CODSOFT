import 'package:flutter/material.dart';
import 'package:qute/models/quote.dart';
import 'package:google_fonts/google_fonts.dart';

class QuoteItem extends StatefulWidget {
  final Quote quote;
  final VoidCallback favoriteDeleted;

  QuoteItem({required this.quote, required this.favoriteDeleted});

  @override
  State<QuoteItem> createState() => _QuoteItemState();
}

class _QuoteItemState extends State<QuoteItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Color(0xFF1C1D21),
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.only(bottom: 5),
        child: ListTile(
          title: Text(
            widget.quote.quote,
            textAlign: TextAlign.justify,
            style: GoogleFonts.chakraPetch(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                color: Color(0xFFECECEC)),
          ),
          subtitle: Row(
            children: [
              Text(
                '~ ${widget.quote.author}',
                style: GoogleFonts.chakraPetch(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w300,
                    color: Color(0xFFECECEC)),
              ),
              Spacer(),
              IconButton(
                onPressed: () {
                  widget.favoriteDeleted();
                },
                icon: Icon(
                  widget.quote.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: widget.quote.isFavorite ? Colors.red : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
