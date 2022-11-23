import 'package:flutter/material.dart';
import 'package:furniture_app/controller/auth_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/repository/auth_repo.dart';
import 'on_board.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> initializeSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final AuthController _authController = Get.put(
        AuthController(sharedPreferences: prefs, authRepo: AuthRepo(sharedPreferences: prefs)));
    _authController.checkLoginStatus();

    //Simulate other services for 3 seconds
    await Future.delayed(Duration(milliseconds: 1000));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializeSettings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return waitingView();
        } else {
          if (snapshot.hasError)
            return errorView(snapshot);
          else
            return OnBoard();
        }
      },
    );
  }

  Scaffold waitingView() {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/icons/logo.png', width: 150,height: 150,),
      ),
    );
  }

  Scaffold errorView(AsyncSnapshot<Object?> snapshot) {
    return Scaffold(
      body: Center(
        child: Text('Error: ${snapshot.error}'),
      ),
    );
  }
}
