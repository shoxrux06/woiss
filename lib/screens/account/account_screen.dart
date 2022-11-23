import 'package:flutter/material.dart';
import 'package:furniture_app/localization/app_localization.dart';
import 'package:furniture_app/providers/invoice_provider.dart';
import 'package:furniture_app/screens/account/commercial_screen.dart';
import 'package:furniture_app/screens/account/contract_screen.dart';
import 'package:furniture_app/screens/auth/change_account_screen.dart';
import 'package:furniture_app/screens/auth/login_screen.dart';
import 'package:furniture_app/utils/app_constants.dart';
import 'package:furniture_app/utils/color_resources.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../providers/cart_provider.dart';
import '../../utils/cache_manager.dart';
import '../dashboard_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key, this.userName = 'U'}) : super(key: key);

  final String userName;
  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  TextEditingController commercialController = TextEditingController();
  TextEditingController contractController = TextEditingController();

  void clearOrderId() async{
  final cacheManager = CacheManager();
  await cacheManager.clearOrderId();
}

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    clearOrderId();
    initializeLength();
  }

  Future<void> initializeLength() async{
    final cacheManager = CacheManager();
    int userId = await cacheManager.getUserId() ?? 0;
    await context.read<InvoiceProvider>().getCommercials(userId);
    await context.read<InvoiceProvider>().getContracts(userId);
  }

  double paddingValue = 0.0;

  @override
  Widget build(BuildContext context) {
    final myModel = Provider.of<CartProvider>(context, listen: false);

    final screenWidth=MediaQuery.of(context).size.width;

    if(screenWidth >= 600 && screenWidth <= 700){
      paddingValue = 20.0;
    }else if(screenWidth > 700){
      paddingValue = 50.0;
    }else{
      paddingValue = 20.0;
    }
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: screenWidth >=600?100:56,
          leadingWidth: screenWidth >=600?150: 80,
          elevation: 0,
          backgroundColor: ColorsResources.PRIMARY_BACKROUND_COLOR,
          leading: InkWell(
            onTap: (){
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => DashboardScreen()));
            },
            child: Image.asset(
              'assets/icons/logotwo.png',
              width: 300,
              height: 80,
            ),
          ),
          actions: [
            InkWell(
              onTap: () async{
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => ChangeAccountScreen()));
              },
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black45
                ),
                child: Center(child: Icon(
                  Icons.person,
                  color: Colors.white,
                ),),
              ),
            ),
            IconButton(
              onPressed: () async {
                return showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: ColorsResources.PRIMARY_BACKROUND_COLOR,
                    title: Text(
                      AppLocalization.of(context)?.translate('log_out')??  "Выйти",
                      style: TextStyle(
                        color: Color.fromRGBO(
                            255, 255, 255, 0.9),
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 15 / 13.4,
                      ),
                    ),
                    content: Text(
                      AppLocalization.of(context)?.translate('log_message')??  "Вы уверены, что хотите выйти? Это удалит все учетные записи в филиале",
                      style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 0.9),
                        fontFamily: 'Roboto',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        height: 15 / 13.4,
                      ),
                    ),
                    actions: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: Text(
                          AppLocalization.of(context)?.translate('no')??  "Нет",
                          style: TextStyle(
                            color: Color.fromRGBO(
                                255, 255, 255, 0.9),
                            fontFamily: 'Roboto',
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            height: 15 / 13.4,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          myModel.clearCart();
                          myModel.clearTotalPrice();
                          myModel.updateProductCounter();
                          Navigator.of(ctx).pop();
                          bool isRemoved = await tokenIsRemoved();
                          if (isRemoved) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => LoginScreen(),
                              ),
                            );
                          }
                        },
                        child: Text(
                          AppLocalization.of(context)?.translate('yes')??"Да",
                          style: TextStyle(
                            color: Color.fromRGBO(
                                255, 255, 255, 0.9),
                            fontFamily: 'Roboto',
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            height: 15 / 13.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
            )
          ],
        ),
        body: Consumer<InvoiceProvider>(
          builder: (context, provider,child){
          return screenWidth>=600?Container(
            height: double.infinity,
            padding: EdgeInsets.all(paddingValue),
            color: ColorsResources.PRIMARY_BACKROUND_COLOR,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => CommercialScreen(),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          height: 52,
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Color.fromRGBO(171, 116, 64, 0.9),
                              )),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalization.of(context)?.translate('commercial') ?? 'Коммерческие',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  height: 12 / 14,
                                  color: Color.fromRGBO(255, 255, 255, 0.9),
                                ),
                              ),
                              Text(
                                '${provider.quantityOfCommercials}',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  height: 12 / 14,
                                  color: Color.fromRGBO(255, 255, 255, 0.9),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 24,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ContractScreen(),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          height: 52,
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Color.fromRGBO(171, 116, 64, 0.9),
                              )),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalization.of(context)?.translate('contract') ??
                                    'Договора',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  height: 12 / 14,
                                  color: Color.fromRGBO(255, 255, 255, 0.9),
                                ),
                              ),
                              Text(
                                '${provider.quantityOfContracts}',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  height: 12 / 14,
                                  color: Color.fromRGBO(255, 255, 255, 0.9),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          ): Container(
            padding: EdgeInsets.all(paddingValue),
            color: ColorsResources.PRIMARY_BACKROUND_COLOR,
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => CommercialScreen(),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Color.fromRGBO(171, 116, 64, 0.9),
                        )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalization.of(context)?.translate('commercial') ?? 'Коммерческие',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            height: 12 / 14,
                            color: Color.fromRGBO(255, 255, 255, 0.9),
                          ),
                        ),
                        Text(
                          '${provider.quantityOfCommercials}',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            height: 12 / 14,
                            color: Color.fromRGBO(255, 255, 255, 0.9),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ContractScreen(),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Color.fromRGBO(171, 116, 64, 0.9),
                        )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalization.of(context)?.translate('contract') ??
                              'Договора',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            height: 12 / 14,
                            color: Color.fromRGBO(255, 255, 255, 0.9),
                          ),
                        ),
                        Text(
                          '${provider.quantityOfContracts}',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            height: 12 / 14,
                            color: Color.fromRGBO(255, 255, 255, 0.9),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },)
        );
  }

  Future<bool> tokenIsRemoved() async {
    final _prefs = await SharedPreferences.getInstance();
    bool isRemoved = ((await _prefs.remove(AppConstants.TOKEN)));
    return isRemoved;
  }

  // Future<bool> userIsChanged() async {
  //   final _prefs = await SharedPreferences.getInstance();
  //   bool isRemoved = await _prefs.remove(AppConstants.USER);
  //   return isRemoved;
  // }
}
