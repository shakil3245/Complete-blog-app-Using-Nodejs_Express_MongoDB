import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../Providers/postProviderss.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController tagController = TextEditingController();

  List<String> categories = [];
  List<String> tags = [];
  File? selectedImage;

  /// Pick image
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null && mounted) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  /// Submit Post
  void submitPost() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    if (selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an image")),
      );
      return;
    }

    context.read<PostProvider>().createPost(
      title: titleController.text.trim(),
      body: bodyController.text.trim(),
      categories: categories,
      tags: tags,
      image: selectedImage!,
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    categoryController.dispose();
    tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Create Post"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// Title
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: "Title",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                  value!.trim().isEmpty ? "Title is required" : null,
                ),

                const SizedBox(height: 16),

                /// Body
                TextFormField(
                  controller: bodyController,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    labelText: "Body",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                  value!.trim().isEmpty ? "Body is required" : null,
                ),

                const SizedBox(height: 16),

                /// Categories
                const Text("Categories"),
                Wrap(
                  spacing: 8,
                  children: categories
                      .map((cat) => Chip(
                    label: Text(cat),
                    onDeleted: () {
                      setState(() {
                        categories.remove(cat);
                      });
                    },
                  ))
                      .toList(),
                ),
                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(
                    hintText: "Add category & press done",
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (value) {
                    final val = value.trim();
                    if (val.isNotEmpty && !categories.contains(val)) {
                      setState(() {
                        categories.add(val);
                        categoryController.clear();
                      });
                    }
                  },
                ),

                const SizedBox(height: 16),

                /// Tags
                const Text("Tags"),
                Wrap(
                  spacing: 8,
                  children: tags
                      .map((tag) => Chip(
                    label: Text(tag),
                    onDeleted: () {
                      setState(() {
                        tags.remove(tag);
                      });
                    },
                  ))
                      .toList(),
                ),
                TextField(
                  controller: tagController,
                  decoration: const InputDecoration(
                    hintText: "Add tag & press done",
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (value) {
                    final val = value.trim();
                    if (val.isNotEmpty && !tags.contains(val)) {
                      setState(() {
                        tags.add(val);
                        tagController.clear();
                      });
                    }
                  },
                ),

                const SizedBox(height: 16),

                /// Image Picker
                const Text("Post Image"),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: pickImage,
                  child: Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: selectedImage == null
                        ? const Center(child: Text("Tap to select image"))
                        : ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        selectedImage!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                /// Submit Button
                Consumer<PostProvider>(
                  builder: (context, provider, _) {
                    return SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed:
                        provider.isLoading ? null : submitPost,
                        child: provider.isLoading
                            ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                            : const Text("Create Post"),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
