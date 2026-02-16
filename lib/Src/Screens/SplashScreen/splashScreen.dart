import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:provider/provider.dart';

import '../../Providers/authProvider.dart';


class SplashScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context);
    Future.delayed(Duration(seconds: 1), () {
      // authController.checkLogin();
      provider.checkLogin();

    });

    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Welcome",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
          SpinKitRotatingCircle(
            color: Colors.white,
            size: 50.0,
          ),
        ],
      )),
    );
  }
}