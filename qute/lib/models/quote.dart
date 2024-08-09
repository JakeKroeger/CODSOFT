class Quote {
  final String quote;
  final String author;
  final String category;
  bool isFavorite = false;

  Quote(
      {required this.quote,
      required this.author,
      required this.category,
      required this.isFavorite});

  Map<String, dynamic> toJson() => {
        'quote': quote,
        'author': author,
        'category': category,
        'isFavorite': isFavorite,
      };

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      quote: json['quote'],
      author: json['author'],
      category: json['category'] ?? '',
      isFavorite: json['isFavorite'] ?? false, // Handle missing isFavorite key
    );
  }
}
