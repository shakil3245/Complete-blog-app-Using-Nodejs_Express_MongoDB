// screens/register_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Providers/authProvider.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String role = "reader";
@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(border: OutlineInputBorder(),labelText: "Name"),
                validator: (v) => v!.isEmpty ? "Enter name" : null,
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(border: OutlineInputBorder(),labelText: "Email"),
                validator: (v) => v!.isEmpty ? "Enter email" : null,
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(border: OutlineInputBorder(),labelText: "Password"),
                obscureText: true,
                validator: (v) =>
                v!.length < 8 ? "Min 8 characters" : null,
              ),
              const SizedBox(height: 10),

              DropdownButtonFormField<String>(
                value: role,
                items: const [
                  DropdownMenuItem(value: "reader", child: Text("Reader")),
                  DropdownMenuItem(value: "author", child: Text("Author")),
                  DropdownMenuItem(value: "admin", child: Text("Admin")),
                ],
                onChanged: (value) {
                  setState(() => role = value!);
                },
                decoration: InputDecoration(border: OutlineInputBorder(),labelText: "Email"),
              ),

              const SizedBox(height: 20),

              authProvider.isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    authProvider.registerUser(nameController.text,
                        emailController.text,
                        passwordController.text,role);
                  }
                },
                child: const Text("Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
