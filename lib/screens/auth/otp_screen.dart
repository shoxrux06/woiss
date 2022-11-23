import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:furniture_app/controller/auth_controller.dart';
import 'package:furniture_app/localization/app_localization.dart';
import 'package:furniture_app/screens/dashboard_screen.dart';
import 'package:furniture_app/screens/home/home_screen.dart';
import 'package:get/get.dart';

import '../../utils/color_resources.dart';
import '../../utils/custom_themes.dart';
import '../custom_snackbar.dart';
class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key, required this.email}) : super(key: key);

  final String email;
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController controllerPassword = TextEditingController();

  void checkPassword(AuthController authController) async{
    String otpPassword = controllerPassword.text.trim();

    if (otpPassword.isEmpty) {
      showCustomSnackBar('enter_email'.tr);
    } else if (otpPassword.length < 6) {
      showCustomSnackBar('password_should_be'.tr);
    } else {
      authController.checkPassword(widget.email, otpPassword).then((response) async {
        if (response['status'] == true) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => DashboardScreen(),
            ),
          );
        } else {
          showCustomSnackBar(AppLocalization.of(context)?.translate('error_occurred')?? 'error_occurred');
        }
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: GetBuilder<AuthController>(builder: (authController) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: screenWidth >= 600? 150 : 40, vertical: 40),
          color: const Color(0xFF1E1E1E),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    AppLocalization.of(context)?.translate('welcome')??'Добро пожаловать',
                    style: titleCormorant.copyWith(
                        color: ColorsResources.PRIMARY_COLOR),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    AppLocalization.of(context)?.translate('one_time_password')?? 'Введите одноразовый пароль отправленный на почту',
                    style: titleRegular,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 52,),
                  SizedBox(height: 24,),
                  Container(
                    height: 44,
                    child: TextFormField(
                      style: titleRegular.copyWith(fontSize: 18),
                      controller: controllerPassword,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: AppLocalization.of(context)?.translate('enter_password')??'Введите пароль',
                        labelStyle: titleRegular,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: Color.fromRGBO(171, 116, 64, 0.9),
                          ),
                          borderRadius: BorderRadius.circular(0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 1,
                            color: ColorsResources.PRIMARY_COLOR,
                          ),
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 100),
                  GestureDetector(
                    onTap: ()=> checkPassword(authController),
                    child: Container(
                      width: double.infinity,
                      height: 44,
                      color: Color(0XFFAB7440),
                      child: Center(
                        child: Text(AppLocalization.of(context)?.translate('login')??'Войти'),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },)
    );
  }
}
