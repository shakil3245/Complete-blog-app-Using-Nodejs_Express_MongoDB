// To parse this JSON data, do
//
//     final fetchBlogModel = fetchBlogModelFromJson(jsonString);

import 'dart:convert';

FetchBlogModel fetchBlogModelFromJson(String str) => FetchBlogModel.fromJson(json.decode(str));

String fetchBlogModelToJson(FetchBlogModel data) => json.encode(data.toJson());

class FetchBlogModel {
  int total;
  int page;
  int pages;
  List<Post> posts;

  FetchBlogModel({
    required this.total,
    required this.page,
    required this.pages,
    required this.posts,
  });

  factory FetchBlogModel.fromJson(Map<String, dynamic> json) => FetchBlogModel(
    total: json["total"],
    page: json["page"],
    pages: json["pages"],
    posts: List<Post>.from(json["posts"].map((x) => Post.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "page": page,
    "pages": pages,
    "posts": List<dynamic>.from(posts.map((x) => x.toJson())),
  };
}

class Post {
  String id;
  String title;
  String body;
  Author? author;
  List<String> categories;
  List<String> tags;
  String status;
  List<dynamic> likes;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  Post({
    required this.id,
    required this.title,
    required this.body,
    required this.author,
    required this.categories,
    required this.tags,
    required this.status,
    required this.likes,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    id: json["_id"],
    title: json["title"],
    body: json["body"],
    author: json["author"] == null ? null : Author.fromJson(json["author"]),
    categories: List<String>.from(json["categories"].map((x) => x)),
    tags: List<String>.from(json["tags"].map((x) => x)),
    status: json["status"],
    likes: List<dynamic>.from(json["likes"].map((x) => x)),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "body": body,
    "author": author?.toJson(),
    "categories": List<dynamic>.from(categories.map((x) => x)),
    "tags": List<dynamic>.from(tags.map((x) => x)),
    "status": status,
    "likes": List<dynamic>.from(likes.map((x) => x)),
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}

class Author {
  String id;
  String name;
  String? avatar;

  Author({
    required this.id,
    required this.name,
    this.avatar,
  });

  factory Author.fromJson(Map<String, dynamic> json) => Author(
    id: json["_id"],
    name: json["name"],
    avatar: json["avatar"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "avatar": avatar,
  };
}
