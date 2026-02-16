import 'package:blogapp/Src/Screens/Users/ProfileScreen/updateProfileScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:provider/provider.dart';

import '../../../Providers/authProvider.dart';
import '../../../Providers/profileProvider.dart';
import '../../Auth_Screens/loginScreen.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<ProfileProvider>().fetchProfile());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
                Get.defaultDialog(
                  title: 'LogOut?',
                  middleText: 'Are you sure you want to LogOut?',
                  textConfirm: 'Yes',
                  textCancel: 'No',
                  confirmTextColor: Colors.white,
                  onConfirm: () async {
                    await context.read<AuthProvider>().logout();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) =>  LoginScreen()),
                    );
                    // call the delete function
                    Get.back(); // close the dialog
                  },
                  onCancel: () {},
                );

            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Consumer<ProfileProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final profile = provider.profile;
                if (profile == null) {
                  return const Center(child: Text('No profile data'));
                }

                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Profile Picture
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: profile.avatarUrl.isNotEmpty
                            ? NetworkImage(profile.avatarUrl)
                            : null,
                        child: profile.avatarUrl.isEmpty
                            ? const Icon(Icons.person, size: 50, color: Colors.white)
                            : null,
                      ),
                      const SizedBox(height: 20),

                      // Profile Info
                      _ProfileTile(label: 'Name', value: profile.name),
                      _ProfileTile(label: 'Email', value: profile.email),
                      _ProfileTile(label: 'Role', value: profile.role),
                      _ProfileTile(label: 'Joined', value: profile.createdAt.toLocal().toString()),
                      _ProfileTile(label: 'Bio', value: profile.bio),
                    ],
                  ),
                );
              },
            ),

            SizedBox(height: 10,),
            ElevatedButton(
              onPressed: () {
                // your action here
                Get.to(ProfileUpdateScreen());
              },
              child: const Text('Update profile'
                  ''),
            )
          ],
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileTile({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(label),
        subtitle: Text(value),
      ),
    );
  }
}
