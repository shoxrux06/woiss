import 'package:flutter/material.dart';
import 'package:furniture_app/controller/auth_controller.dart';
import 'package:furniture_app/screens/auth/login_screen.dart';
import 'package:furniture_app/screens/dashboard_screen.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class OnBoard extends StatelessWidget {
  const OnBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
        builder: (controller) {
      return controller.isLogged ? DashboardScreen(): LoginScreen();
    });
  }
}
