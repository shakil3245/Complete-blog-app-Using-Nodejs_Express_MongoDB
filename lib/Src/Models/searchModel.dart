class SearchModel {
  final String id;
  final String title;
  final String body;
  final String authorName;
  final List<String> categories;
  final List<String> tags;

  SearchModel({
    required this.id,
    required this.title,
    required this.body,
    required this.authorName,
    required this.categories,
    required this.tags,
  });

  factory SearchModel.fromJson(Map<String, dynamic> json) {
    return SearchModel(
      id: json['_id'],
      title: json['title'],
      body: json['body'],
      authorName: json['author']['name'],
      categories: List<String>.from(json['categories']),
      tags: List<String>.from(json['tags']),
    );
  }
}
