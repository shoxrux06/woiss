import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:furniture_app/data/model/client_model.dart';
import 'package:furniture_app/localization/app_localization.dart';
import 'package:furniture_app/screens/cart/cart_item.dart';
import 'package:furniture_app/screens/cart/submit_order_screen.dart';
import 'package:furniture_app/screens/dashboard_screen.dart';
import 'package:furniture_app/utils/color_resources.dart';
import 'package:furniture_app/utils/size_config.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';
import '../../utils/cache_manager.dart';
import '../../utils/custom_themes.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({this.client});

  final Result? client;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var currentIndex = 0;

  bool isSum = false;
  int subTotalValue = 0;
  CartProvider cartProvider = CartProvider();
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  String? moneyFormat(String price) {
    if (price.length > 2) {
      var value = price;
      value = value.replaceAll(RegExp(r'\D'), '');
      value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ' ');
      return value;
    }
  }

  double paddingValue = 0.0;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    SizeConfig().init(context);
    final isLandScape = MediaQuery.of(context).orientation == Orientation.landscape;
    if(screenWidth >= 600 && screenWidth <= 700){
      paddingValue = 20.0;
    }else if(screenWidth > 700){
      paddingValue = 50.0;
    }else{
      paddingValue = 20.0;
    }
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        leadingWidth: screenWidth >= 600?110:54,
        backgroundColor: ColorsResources.PRIMARY_BACKROUND_COLOR,
        actions: [
          Container(
            padding: EdgeInsets.only(right: screenWidth >=600? 32: 0),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const DashboardScreen()));
              },
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          )
        ],
        title: Text(
          AppLocalization.of(context)?.translate('cart') ?? 'Корзина',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Cormorant',
            fontSize: 28,
            fontWeight: FontWeight.w500,
            height: 28 / 34,
          ),
        ),
      ),
      body: Consumer<CartProvider>(
        builder: ((context, cart, child) {
          print('CartList<<<<<<<<<${cart.cartList}>>>>>>>>>>>>>');
          return LayoutBuilder(builder: (context, constraints) {
            return Container(
              color: ColorsResources.PRIMARY_BACKROUND_COLOR,
              child: cart.cartList.isNotEmpty
                  ? CustomScrollView(slivers: [
                      screenWidth >= 600
                          ? SliverGrid(
                              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: screenWidth / 2,
                                mainAxisSpacing: 10.0,
                                crossAxisSpacing:(screenWidth>= 600 && screenWidth <= 700)?0: 10.0,
                                childAspectRatio:(isLandScape)? SizeConfig.aspectRatio *2.0: SizeConfig.aspectRatio *2.5,
                              ),
                              delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                return CartItem(cart: cart.cartList[index], index: index);
                              }, childCount: cart.cartList.length),
                            )
                          : SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) => CartItem(
                                    cart: cart.cartList[index], index: index),
                                  childCount: cart.cartList.length
                              ),
                            ),
                      SliverFillRemaining(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Spacer(),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal:screenWidth>600?50: 20,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Divider(
                                    height: 1,
                                    color: Color.fromRGBO(171, 116, 64, 0.9),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            FittedBox(
                                              child: Text(
                                                AppLocalization.of(context)
                                                        ?.translate('total') ??
                                                    'Итого',
                                                style: TextStyle(
                                                  color: Colors.white
                                                      .withOpacity(0.8),
                                                  fontFamily: 'Roboto',
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            FittedBox(
                                              child: Text(
                                                // '${cart.totalPrice.toInt()} ',
                                                '${moneyFormat(cart.totalPrice.toInt().toString())}${cart.cartList.isNotEmpty ?
                                                cart.cartList[0].product.branchPrice.substring(cart.cartList[0].product.branchPrice.lastIndexOf(' '),cart.cartList[0].product.branchPrice.length): ''}',
                                                style: TextStyle(
                                                  color: Colors.white
                                                      .withOpacity(0.8),
                                                  fontFamily: 'Roboto',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      isSum
                                          ? Expanded(
                                              flex: 1,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  FittedBox(
                                                    child: Text(
                                                      AppLocalization.of(
                                                                  context)
                                                              ?.translate(
                                                                  'subtotal') ??
                                                          'Итого',
                                                      style: TextStyle(
                                                        color: Colors.white
                                                            .withOpacity(0.8),
                                                        fontFamily: 'Roboto',
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  FittedBox(
                                                    child: Text(
                                                      '${moneyFormat(subTotalValue.toString())}${cart.cartList.isNotEmpty ?
                                                      cart.cartList[0].product.branchPrice.substring(cart.cartList[0].product.branchPrice.lastIndexOf(' '),cart.cartList[0].product.branchPrice.length): ''}',
                                                      style: TextStyle(
                                                        color: Colors.white
                                                            .withOpacity(0.8),
                                                        fontFamily: 'Roboto',
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          : Container(),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          height: 44,
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            style: titleRegular.copyWith(
                                                fontSize: 18, height: 1),
                                            controller: controller,
                                            maxLength: 2,
                                            enabled: true,
                                            scrollPadding:
                                                EdgeInsets.only(bottom: 150),
                                            onFieldSubmitted: (val) {
                                              setState(() {
                                                subTotalValue =
                                                    ((cart.totalPrice.toInt() -
                                                            ((int.parse(val) *
                                                                    0.01) *
                                                                cart.totalPrice
                                                                    .toInt())))
                                                        .toInt();
                                              });
                                            },
                                            decoration: InputDecoration(
                                                counterText: '',
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    width: 1,
                                                    color: Color.fromRGBO(
                                                        171, 116, 64, 0.9),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(0),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    width: 1,
                                                    color: ColorsResources
                                                        .PRIMARY_COLOR,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(0),
                                                ),
                                                labelText: '10 %',
                                                labelStyle: titleRegular,
                                                hintStyle: titleRegular,
                                                suffixIcon: SizedBox(
                                                  width: 16,
                                                  height: 16,
                                                  child: IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          isSum = true;
                                                        });
                                                        subTotalValue = ((cart
                                                                    .totalPrice
                                                                    .toInt() -
                                                                ((int.parse(controller
                                                                            .text) *
                                                                        0.01) *
                                                                    cart.totalPrice
                                                                        .toInt())))
                                                            .toInt();
                                                        print(
                                                            'subTotalValue>>>>>>$subTotalValue');
                                                        print(
                                                            'subTotalValue>>>>>>${cart.totalPrice.toInt()}');
                                                        print(
                                                            'subTotalValue>>>>>>${(int.parse(controller.text) * 0.01) * cart.totalPrice}');
                                                      },
                                                      icon: Icon(
                                                        Icons.check_box,
                                                        color: Colors.white,
                                                      )),
                                                )
                                                // suffix: InkWell(
                                                //   onTap: (){
                                                //
                                                //   },
                                                //   child: Container(
                                                //     child: Center(
                                                //       child: Text('Ok', style: TextStyle(color: Colors.white),),
                                                //     ),
                                                //   ),
                                                // )
                                                ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 21,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (_) => SubmitOrderScreen(
                                            client: widget.client),
                                      ));
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      height: 54,
                                      color: Color.fromRGBO(171, 116, 64, 0.9),
                                      child: Center(
                                        child: Text(AppLocalization.of(context)
                                                ?.translate('next') ??
                                            'Cледующий'),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 48,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        hasScrollBody: false,
                      )
                    ])
                  : Container(
                      padding: EdgeInsets.all(paddingValue),
                      child: Center(
                        child: Text(
                          AppLocalization.of(context)
                                  ?.translate('no_product_at_cart') ??
                              'У вас нет ни одного товара в корзине',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Roboto',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            height: 18 / 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
            );
          });
        }),
      ),
    );
  }
}
