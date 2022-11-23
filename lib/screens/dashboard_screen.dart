import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:furniture_app/localization/app_localization.dart';
import 'package:furniture_app/screens/account/account_screen.dart';
import 'package:furniture_app/screens/cart/cart_screen.dart';
import 'package:furniture_app/screens/home/home_screen.dart';
import 'package:furniture_app/utils/images.dart';

import 'account/hero_animation.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int currentIndex = 0;
  final screens = [
    HomeScreen(),
    CartScreen(),
    AccountScreen(),
  ];
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(Images.HOME_IMAGE),
            label: 'Home',
            activeIcon: Image.asset('assets/icons/home_active.png'),
          ),
          BottomNavigationBarItem(
            icon: Image.asset(Images.CART_IMAGE),
            label: AppLocalization.of(context)?.translate('cart')??'Cart',
            activeIcon: Image.asset('assets/icons/cart_active.png'),
          ),
          BottomNavigationBarItem(
            icon: Image.asset(Images.ACCOUNT_IMAGE),
            label: 'Account',
            activeIcon: Image.asset('assets/icons/account_active.png'),
          ),
        ],
        backgroundColor: Color(0xFF565656),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.white,
        onTap: (newIndex){
          setState(() {
            currentIndex = newIndex;
          });
        },
      ),
    );
  }
}
