import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:qute/models/quote.dart'; // Ensure you have this import if `Quote` is in another file

class QuoteService {
  final String category = 'happiness';
  static const String baseUrl = 'https://api.api-ninjas.com/v1/quotes';
  static const String apiKey =
      'kz7vManrSjhZa6Qzweb8+w==X0syLADUtSfvI2z0'; // Replace with your actual API key

  Future<Quote> fetchQuote() async {
    final response = await http.get(
      Uri.parse('$baseUrl?category=$category'),
      headers: {
        'X-Api-Key': apiKey, // API key header as per api-ninjas documentation
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      if (body.isNotEmpty) {
        return Quote.fromJson(body[0]); // Return the first quote from the list
      } else {
        throw Exception('No quotes found');
      }
    } else {
      throw Exception('Failed to load quotes');
    }
  }
}
