import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ArticleTile extends StatelessWidget {
  final String imageUrl;
  final String category;
  final String title;
  final String author;
  final String time;
  final VoidCallback onDelete; // Callback to delete the post

  const ArticleTile({
    required this.imageUrl,
    required this.category,
    required this.title,
    required this.author,
    required this.time,
    required this.onDelete, // pass the function from parent
  });

  void _showDeleteDialog() {
    Get.defaultDialog(
      title: 'Delete Post',
      middleText: 'Are you sure you want to delete this blog post?',
      textConfirm: 'Yes',
      textCancel: 'No',
      confirmTextColor: Colors.white,
      onConfirm: () {
        onDelete(); // call the delete function
        Get.back(); // close the dialog
      },
      onCancel: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              width: 90,
              height: 90,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$author • $time',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: _showDeleteDialog,
            child: const Icon(Icons.more_vert),
          ),
        ],
      ),
    );
  }
}
