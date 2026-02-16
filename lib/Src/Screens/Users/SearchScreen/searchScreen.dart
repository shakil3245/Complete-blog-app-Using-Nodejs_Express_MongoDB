import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Providers/searchProvider.dart';
import '../DetailsScreens/postdetailsScreen.dart';


class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final searchProvider = context.watch<SearchProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Real-time Search')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                searchProvider.onSearchChanged(value.trim());
              },
              decoration: InputDecoration(
                hintText: 'Search by category...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    // Clear text field and results
                    searchProvider.onSearchChanged('');
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            if (searchProvider.isLoading)
              const Center(child: CircularProgressIndicator()),

            if (!searchProvider.isLoading)
              Expanded(
                child: searchProvider.posts.isEmpty
                    ? const Center(child: Text('No posts found'))
                    : ListView.builder(
                  itemCount: searchProvider.posts.length,
                  itemBuilder: (context, index) {
                    final post = searchProvider.posts[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(post.title),
                        subtitle: Text(
                          post.body,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Text(post.authorName),
                        onTap: () {
                          // Navigate to Details Screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PostDetailsScreen(post: post),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),

          ],
        ),
      ),
    );
  }
}
