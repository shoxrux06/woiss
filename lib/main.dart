import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:furniture_app/controller/auth_controller.dart';
import 'package:furniture_app/controller/client_controller.dart';
import 'package:furniture_app/controller/invoice_controller.dart';
import 'package:furniture_app/controller/order_controller.dart';
import 'package:furniture_app/controller/product_controller.dart';
import 'package:furniture_app/data/repository/client_repo.dart';
import 'package:furniture_app/data/repository/invoice_repo.dart';
import 'package:furniture_app/data/repository/product_repository.dart';
import 'package:furniture_app/providers/cart_provider.dart';
import 'package:furniture_app/providers/invoice_provider.dart';
import 'package:furniture_app/providers/localization_provider.dart';
import 'package:furniture_app/screens/splash_screen.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/repository/order_repository.dart';
import 'localization/app_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  init();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => CartProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => LocalizationProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => InvoiceProvider(invoiceRepo: InvoiceRepo()),
      ),
    ],
    child: MyApp(),
  ));
}

init() async {
  final prefs = await SharedPreferences.getInstance();
  Get.lazyPut(
    () => AuthController,
  );
  Get.lazyPut(() => InvoiceController(InvoiceRepo()));
  Get.lazyPut(() => ClientController(clientRepo: ClientRepo()));
  Get.lazyPut(() => ProductController(productRepo: ProductRepository()));
  Get.lazyPut(() => CartProvider());
  Get.lazyPut(() => LocalizationProvider());
  Get.lazyPut(() => OrderController(OrderRepository()));
  // Get.lazyPut(() => Cart());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static MaterialColor generateMaterialColorFromColor(Color color) {
    return MaterialColor(color.value, {
      50: Color.fromRGBO(color.red, color.green, color.blue, 0.1),
      100: Color.fromRGBO(color.red, color.green, color.blue, 0.2),
      200: Color.fromRGBO(color.red, color.green, color.blue, 0.3),
      300: Color.fromRGBO(color.red, color.green, color.blue, 0.4),
      400: Color.fromRGBO(color.red, color.green, color.blue, 0.5),
      500: Color.fromRGBO(color.red, color.green, color.blue, 0.6),
      600: Color.fromRGBO(color.red, color.green, color.blue, 0.7),
      700: Color.fromRGBO(color.red, color.green, color.blue, 0.8),
      800: Color.fromRGBO(color.red, color.green, color.blue, 0.9),
      900: Color.fromRGBO(color.red, color.green, color.blue, 1.0),
    });
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Consumer(builder: (context, provider, child) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        localizationsDelegates: [
          const AppLocalizationDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en'),
          const Locale('ru'),
          const Locale('tr'),
          const Locale('uz'),
        ],
        locale: Provider.of<LocalizationProvider>(context).locale,
        theme: ThemeData(
          primaryColor: const Color.fromRGBO(171, 116, 64, 0.9),
          primarySwatch: generateMaterialColorFromColor(Color.fromRGBO(171, 116, 64, 0.9)),
          unselectedWidgetColor: const Color.fromRGBO(171, 116, 64, 0.9),
          accentColor: const Color.fromRGBO(171, 116, 64, 0.9),
        ),
        home: SplashScreen(),
      );
    });
  }
}
