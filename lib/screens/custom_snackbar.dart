import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';

void showCustomSnackBar(String? message, {bool? isError = true}) {
  if(message != null && message.isNotEmpty) {
    Get.showSnackbar(GetSnackBar(
      backgroundColor: isError! ? Colors.red : Colors.green,
      message: message,
      duration: Duration(seconds: 3),
      snackStyle: SnackStyle.FLOATING,
      margin: EdgeInsets.all(10),
      borderRadius: 5,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
    ));
  }
}

void showCustomSuccessSnackBar(String? message, {bool? isError = true}) {
  if(message != null && message.isNotEmpty) {
    Get.showSnackbar(GetSnackBar(
      backgroundColor: isError! ? Colors.green : Colors.green,
      message: message,
      duration: Duration(seconds: 3),
      snackStyle: SnackStyle.FLOATING,
      margin: EdgeInsets.all(10),
      borderRadius: 5,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
    ));
  }
}