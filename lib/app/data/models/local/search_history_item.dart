import 'dart:convert';

class SearchHistoryItem {
  final String query;
  final String category;

  SearchHistoryItem({
    required this.query,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'query': query,
      'category': category,
    };
  }

  factory SearchHistoryItem.fromMap(Map<String, dynamic> map) {
    return SearchHistoryItem(
      query: map['query'] ?? '',
      category: map['category'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SearchHistoryItem.fromJson(String source) =>
      SearchHistoryItem.fromMap(json.decode(source));
}
