import 'package:flutter/material.dart';

import '../../../Models/searchModel.dart';


class PostDetailsScreen extends StatelessWidget {
  final SearchModel post;

  const PostDetailsScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(post.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Author
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: post.authorName != null
                      ? NetworkImage(
                    // Provide a default avatar if null
                      'https://example.com/new-avatar.jpg')
                      : null,
                  child: post.authorName == null ? const Icon(Icons.person) : null,
                ),
                const SizedBox(width: 10),
                Text(
                  post.authorName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Categories
            Text(
              'Categories: ${post.categories.join(', ')}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),

            // Tags
            Text(
              'Tags: ${post.tags.join(', ')}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Body
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  post.body,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
