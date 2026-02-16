class BlogPost {
  final String id;
  final String title;
  final String body;
  final String authorName;
  final String createdAt;
  final List<String> categories;
  final List<String> tags;

  BlogPost({
    required this.id,
    required this.title,
    required this.body,
    required this.authorName,
    required this.createdAt,
    required this.categories,
    required this.tags,
  });

  factory BlogPost.fromJson(Map<String, dynamic> json) {
    return BlogPost(
      id: json['_id'],
      title: json['title'],
      body: json['body'],
      authorName: json['author'] != null
          ? json['author']['name'] ?? 'Unknown'
          : 'Unknown',
      createdAt: json['createdAt'],
      categories: List<String>.from(json['categories'] ?? []),
      tags: List<String>.from(json['tags'] ?? []),
    );
  }
}
