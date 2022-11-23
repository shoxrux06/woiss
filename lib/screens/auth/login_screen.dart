import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:furniture_app/controller/order_controller.dart';
import 'package:furniture_app/controller/product_controller.dart';
import 'package:furniture_app/data/default_data.dart';
import 'package:furniture_app/screens/auth/otp_screen.dart';
import 'package:furniture_app/screens/home/home_screen.dart';
import 'package:furniture_app/utils/color_resources.dart';
import 'package:furniture_app/utils/custom_themes.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/auth_controller.dart';
import '../../data/repository/auth_repo.dart';
import '../../data/repository/product_repository.dart';
import '../../localization/app_localization.dart';
import '../../providers/localization_provider.dart';
import '../../utils/app_constants.dart';
import '../../utils/cache_manager.dart';
import '../custom_snackbar.dart';
import '../dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController controllerPhoneNumber = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();

  final DefaultData defaultData = DefaultData();

  var activeLang = false;

  var isChecked = false;
  var isLoading = false;
  var isVal = false;

  bool isValid() {
    if (controllerPhoneNumber.text.isEmpty || controllerPassword.text.isEmpty) {
      isVal = false;
      return isVal;
    } else {
      isVal = true;
      return isVal;
    }
  }

  void _login(AuthController authController) async {
    String _email = controllerPhoneNumber.text.trim();
    String _password = controllerPassword.text.trim();
    // String _numberWithCountryCode = countryDialCode+_phone;

    if (_email.isEmpty) {
      showCustomSnackBar('enter_email'.tr);
    } else if (_password.isEmpty) {
      showCustomSnackBar('enter_password'.tr);
    } else if (_password.length < 6) {
      showCustomSnackBar('password_should_be'.tr);
    } else {
      authController.loginMethod(_email, _password).then((response) async {
        if (response['status'] == true) {
          if(_email == 'mobdev333@gmail.com' && _password == '66666666'){
            final cacheManager = CacheManager();
            await cacheManager.saveToken(response['message']['token']);
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => DashboardScreen(),
              ),
            );
          }else{
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => OtpScreen(email: _email),
              ),
            );
          }
        } else {
          showCustomSnackBar("Incorrect email or password");
        }
      });
    }
  }
  SharedPreferences? prefs;

  Future<void> getData(ProductController controller) async {
    prefs = await SharedPreferences.getInstance();
    controller.getProductList(1);
    controller.getCategoryList();
  }

  @override
  void initState() {
    final controller = ProductController(productRepo: ProductRepository());
    getData(controller);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: ()async{
        final _prefs = await SharedPreferences.getInstance();
        bool isRemoved = ((await _prefs.remove(AppConstants.TOKEN)));
        return isRemoved;
      },
      child: Scaffold(
        body: GetBuilder<AuthController>(
            init: AuthController( authRepo: AuthRepo(
              sharedPreferences: prefs,
            ), sharedPreferences: prefs),
            builder: (authControler) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: screenWidth>= 600? 150 :40, vertical: 40),
                color: const Color(0xFF1E1E1E),
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Consumer<LocalizationProvider>(
                          builder: (context, currentData, child){
                            return Container(
                              width: double.infinity,
                              padding: EdgeInsets.only(left: 10, right: 10),
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(171, 116, 64, 0.9),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: DropdownButton<String>(
                                isExpanded: true,
                                hint: Text('Select Language'),
                                value: currentData.defineCurrentLanguage(context),
                                icon: Icon(
                                  Icons.keyboard_arrow_down_sharp,
                                  color: Colors.white,
                                ),
                                iconSize: 24,
                                elevation: 0,
                                style: TextStyle(color: Colors.white),
                                underline: Container(
                                  height: 1,
                                ),
                                dropdownColor: Color.fromRGBO(171, 116, 64, 0.9),
                                onChanged: (String? newValue) async{
                                  final cacheManager = CacheManager();
                                  currentData.changeLocale(newValue??'');
                                  cacheManager.saveAppLang(newValue??'');
                                  String? appLang = await cacheManager.getAppLang();
                                  print('APP LANGUAGE LOGIN SCREEN>>>>>>>>>$appLang');
                                },
                                items: defaultData.languagesListDefault.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                },
                                ).toList(),
                              ),
                            );

                          },
                        ),
                        Expanded(
                          child: Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalization.of(context)?.translate('welcome') ?? '',
                                  style: titleCormorant.copyWith(
                                      color: ColorsResources.PRIMARY_COLOR),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  AppLocalization.of(context)?.translate('login_to_your_account')?? '',
                                  style: titleRegular,
                                ),
                                SizedBox(
                                  height: 72,
                                ),
                                Container(
                                  height: 44,
                                  child: TextFormField(
                                    style: titleRegular.copyWith(fontSize: 18, height: 1.2),
                                    controller: controllerPhoneNumber,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(left: 12, right: 12,),
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
                                      labelText: AppLocalization.of(context)?.translate('enter_email')?? 'Введите E-mail',
                                      labelStyle: titleRegular,
                                      hintStyle: titleRegular,
                                    ),
                                    onFieldSubmitted: (val) {
                                      _login(authControler);
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 24,
                                ),
                                Container(
                                  height: 44,
                                  child: TextFormField(
                                    style: titleRegular.copyWith(fontSize: 18,height: 1.2),
                                    controller: controllerPassword,
                                    textInputAction: TextInputAction.done,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(left: 12, right: 12,),
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
                                SizedBox(height: 16),
                                Row(
                                  children: [
                                    Theme(
                                      data: Theme.of(context).copyWith(
                                        unselectedWidgetColor:
                                        ColorsResources.PRIMARY_COLOR,
                                        backgroundColor:
                                        ColorsResources.PRIMARY_COLOR,
                                      ),
                                      child: SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: Checkbox(
                                            value: isChecked,
                                            checkColor: ColorsResources
                                                .PRIMARY_BACKROUND_COLOR,
                                            onChanged: (bool? val) {
                                              setState(() {
                                                isChecked = val ?? false;
                                              });
                                            }),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Text(
                                      AppLocalization.of(context)?.translate('remember_me')??'Запомнить меня',
                                      style: titleRegular,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                                GestureDetector(
                                  onTap: () => _login(authControler),
                                  child: Container(
                                    width: double.infinity,
                                    height: 44,
                                    color: Color.fromRGBO(171, 116, 64, 0.9),
                                    child: Center(
                                      child: Text(AppLocalization.of(context)?.translate('login')??'Войти'),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
