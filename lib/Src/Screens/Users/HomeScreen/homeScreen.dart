import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Providers/blogsProviders.dart';
import '../Widgets/ArticleCard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<BlogProvider>().getBlogs();
    });
  }

  @override
  Widget build(BuildContext context) {
    final blogProvider = context.watch<BlogProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Blogs"),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text(
              'Hi, Good Day!',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: blogProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: blogProvider.posts.length,
                      itemBuilder: (context, index) {
                        final post = blogProvider.posts[index];

                        return ArticleTile(
                          imageUrl:
                              'https://images.unsplash.com/photo-1581291518857-4e27b48ff24e',
                          category: post.categories.join(', '),
                          title: post.title,
                          author: post.authorName,
                          time: post.createdAt, onDelete: () {
                          blogProvider.deletePost(post.id);
                        },
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
