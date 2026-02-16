import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import '../../../Providers/authProvider.dart';
import '../../Auth_Screens/loginScreen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Admin"),actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            await context.read<AuthProvider>().logout();

            // Navigate to login screen
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) =>  LoginScreen()),
            );
          },
        ),
      ],),
      body: Column(children: [Text("Admin")]),
    );
  }
}
