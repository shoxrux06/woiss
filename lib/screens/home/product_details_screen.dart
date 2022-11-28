import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:furniture_app/controller/order_controller.dart';
import 'package:furniture_app/controller/product_controller.dart';
import 'package:furniture_app/data/cart.dart';
import 'package:furniture_app/data/model/response/custom_product_model.dart';
import 'package:furniture_app/data/model/response/product_model.dart';
import 'package:furniture_app/localization/app_localization.dart';
import 'package:furniture_app/providers/cart_provider.dart';
import 'package:furniture_app/screens/cart/cart_screen.dart';
import 'package:furniture_app/screens/custom_snackbar.dart';
import 'package:furniture_app/utils/app_constants.dart';
import 'package:furniture_app/utils/color_resources.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/custom_themes.dart';
import 'category_screen.dart';
import 'hero_animation_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;
  final String productName;
  final String catName;

  const ProductDetailsScreen(
      {Key? key,
      required this.catName,
      required this.productName,
      required this.product})
      : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  var isStandart1 = false;
  var isStandart2 = false;
  var isCustom1 = false;
  var isCustom2 = false;

  var isDiscount = false;
  var isIncrease = false;

  double productPrice = 0.0;

  String enteredDisIncValue = '';
  bool isEnteredDisIncValueEmpty = true;

  bool isTouched = false;

  double paddingValue = 0.0;

  TextEditingController colorController = TextEditingController();
  TextEditingController sizeController = TextEditingController();
  TextEditingController priceDecreaseOrIncreaseController = TextEditingController();

  String? moneyFormat(String price) {
    if (price.length > 2) {
      var value = price;
      value = value.replaceAll(RegExp(r'\D'), '');
      value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ' ');
      return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth >= 600 && screenWidth <= 700) {
      paddingValue = 20.0;
    } else if (screenWidth > 700) {
      paddingValue = 50.0;
    } else {
      paddingValue = 0.0;
    }
    String languageCode = Localizations.localeOf(context).languageCode;
    String productName = '';
    if (languageCode == 'en') {
      productName = widget.product.nameEn;
    } else if (languageCode == 'ru') {
      productName = widget.product.nameRu;
    } else if (languageCode == 'tr') {
      productName = widget.product.nameTr;
    } else if (languageCode == 'uz') {
      productName = widget.product.nameUz;
    }
    final cartModel = Provider.of<CartProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
              cartModel.updateCounter();
            },
            child: Icon(
              Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          backgroundColor: ColorsResources.PRIMARY_BACKROUND_COLOR,
          leadingWidth: screenWidth >= 600 ? 100 : 54,
          actions: [
            Padding(
              padding: EdgeInsets.only(left: 24, right: screenWidth >= 600 ? 38 : 12),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => CartScreen()));
                  cartModel.updateCounter();
                },
                child: Align(
                  alignment: Alignment.center,
                  child: cartModel.cartList.length == 0
                      ? Image.asset(
                          'assets/icons/cart_active.png',
                          width: 54,
                          height: 54,
                        )
                      : Stack(
                          children: [
                            Image.asset(
                              'assets/icons/cart_active.png',
                              width: 54,
                              height: 54,
                            ),
                            Positioned(
                                top: 12,
                                right: 4,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: ColorsResources.PRIMARY_COLOR,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${cartModel.cartList.length}',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ))
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
        body: Consumer<CartProvider>(
          builder: (context, provider, child) {
            return Container(
              padding: EdgeInsets.only(
                  left: paddingValue,
                  right: paddingValue,
                  bottom: paddingValue,
                  top: paddingValue),
              color: ColorsResources.PRIMARY_BACKROUND_COLOR,
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Container(
                      color: ColorsResources.PRIMARY_BACKROUND_COLOR,
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => HeroAnimationScreen(
                                    product: widget.product,
                                  ),
                                ),
                              );
                            },
                            child: Hero(
                              tag: 'heroOne',
                              child: Container(
                                color: Colors.white,
                                child: CachedNetworkImage(
                                  imageUrl: '${widget.product.img}',
                                  width: double.infinity,
                                  height: screenWidth >= 600 ? 407 : 307,
                                  placeholder:
                                      (BuildContext context, String url) =>
                                          Container(
                                    width: 320,
                                    height: 240,
                                    color: Colors.grey,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      new Icon(Icons.error),
                                  // fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: screenWidth >= 600
                                ? const EdgeInsets.symmetric(vertical: 20)
                                : const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          productName,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 15),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          widget.product.branchPrice.toString(),
                                          // '${moneyFormat(widget.product.intBranchPrice.toString())} ${AppLocalization.of(context)?.translate('sum') ?? 'сум'}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 12,
                                        ),
                                        (isDiscount || isIncrease)?Text(
                                            (isEnteredDisIncValueEmpty)?'':'${moneyFormat('${productPrice.round()}')?? ''} '
                                                '${widget.product.branchPrice.substring(widget.product.branchPrice.lastIndexOf(' '),widget.product.branchPrice.length)}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ): SizedBox(),
                                      ],
                                    ),
                                    Spacer(),
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            cartModel.removeCounter();
                                          },
                                          child: Container(
                                            // color: Colors.blueAccent,
                                            padding: EdgeInsets.only(
                                                top: 0,
                                                right: 8,
                                                left: 8,
                                                bottom: 8),
                                            child: Container(
                                              width: 24,
                                              height: 24,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.white,
                                                  width: 1,
                                                ),
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.remove,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(bottom: 8),
                                          child: Text(
                                            '${cartModel.counter}',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 18),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            cartModel.addCounter();
                                          },
                                          child: Container(
                                            padding: EdgeInsets.only(top: 0,
                                                right: 8,
                                                left: 8,
                                                bottom: 8),
                                            child: Container(
                                              width: 24,
                                              height: 24,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.white,
                                                  width: 1,
                                                ),
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 24,
                                ),
                                screenWidth >= 600
                                    ? colorWidgetTablet(
                                        AppLocalization.of(context)?.translate('color') ?? 'Цвета')
                                    : colorWidget(AppLocalization.of(context)?.translate('color') ?? 'Цвета'),
                                const SizedBox(
                                  height: 12,
                                ),
                                screenWidth >= 600
                                    ? sizeWidgetTablet(
                                        AppLocalization.of(context)?.translate('size') ??'Размер')
                                    : sizeWidget(AppLocalization.of(context)?.translate('size') ?? 'Размер'),
                                const SizedBox(
                                  height: 24,
                                ),
                                Divider(
                                  height: 2,
                                  color: ColorsResources.PRIMARY_COLOR,
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: InkWell(
                                        child: ListTileTheme(
                                          contentPadding: EdgeInsets.all(0),
                                          child: CheckboxListTile(
                                            contentPadding: EdgeInsets.all(0),
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            title: const Text(
                                              // AppLocalization.of(context)?.translate('standart') ??
                                              //     'Standart',
                                              'Discount',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 11,
                                              ),
                                            ),
                                            value: isDiscount,
                                            onChanged: (bool? val) {
                                              setState(() {
                                                isIncrease = false;
                                                isDiscount = val!;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: CheckboxListTile(
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        contentPadding: EdgeInsets.all(0),
                                        title: const Text(
                                          // AppLocalization.of(context)?.translate('custom') ??
                                          //     'Custom',
                                          'Increase',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 11,
                                          ),
                                        ),
                                        value: isIncrease,
                                        onChanged: (bool? val) {
                                          setState(() {
                                            isDiscount = false;
                                            isIncrease = val!;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: (isDiscount || isIncrease) ? 20 : 0,
                                ),
                                (isDiscount || isIncrease)
                                    ? Container(
                                        height: 48,
                                        child: TextFormField(
                                          onChanged: (value) {
                                            enteredDisIncValue = value;
                                            if(isDiscount && value.isNotEmpty){
                                              setState(() {
                                                if(int.parse(value.trim()) == 100){
                                                  productPrice = 0;
                                                }else{
                                                  productPrice = widget.product.intBranchPrice - widget.product.intBranchPrice * (int.parse(value) /100);
                                                }
                                                print('isDiscount  -->$productPrice');
                                              });
                                            }else if(isIncrease && value.isNotEmpty){
                                              setState(() {
                                                productPrice = widget.product.intBranchPrice + widget.product.intBranchPrice * (int.parse(value) /100);
                                                print('isIncrease --> $productPrice');
                                              });
                                            }else{
                                              setState(() {
                                                productPrice = widget.product.intBranchPrice.roundToDouble();
                                              });
                                              print(productPrice);

                                            }

                                            if(value.isEmpty){
                                              setState((){
                                                isEnteredDisIncValueEmpty = true;
                                              });
                                            }
                                            if(value.isNotEmpty){
                                              setState((){
                                                isEnteredDisIncValueEmpty = false;
                                              });
                                            }

                                          },
                                          style: titleRegular.copyWith(fontSize: 18),
                                          controller: priceDecreaseOrIncreaseController,
                                          decoration: InputDecoration(
                                            suffixIcon: InkWell(
                                              onTap: (){
                                                if(priceDecreaseOrIncreaseController.text.isEmpty &&(isDiscount || isIncrease)){
                                                  showCustomSnackBar('Please enter discount or increase value');
                                                }
                                                setState(() {});
                                                if(isDiscount){
                                                  productPrice = widget.product.intBranchPrice - widget.product.intBranchPrice * (int.parse(enteredDisIncValue) /100);
                                                  print('8***productPrice$productPrice***');
                                                }else if(isIncrease){
                                                  productPrice = widget.product.intBranchPrice + widget.product.intBranchPrice * (int.parse(enteredDisIncValue) /100);
                                                }else{
                                                  productPrice = widget.product.intBranchPrice.roundToDouble();
                                                }
                                              },
                                              child: Container(
                                                width: 54,
                                                height: 48,
                                                decoration: const BoxDecoration(
                                                  color: ColorsResources
                                                      .PRIMARY_COLOR,
                                                ),
                                                child: const Center(
                                                  child: Text(
                                                    'Ok',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
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
                                            labelText: AppLocalization.of(context)?.translate('your_preferences') ?? 'Ваши предпочтения',
                                            labelStyle: titleRegular,
                                            hintStyle: titleRegular,
                                          ),
                                        ),
                                      )
                                    : Container(),
                                SizedBox(
                                  height: 60,
                                ),
                                // Spacer(),
                                SizedBox(
                                  height: 60,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    if(priceDecreaseOrIncreaseController.text.isEmpty && (isDiscount || isIncrease)){
                                      showCustomSnackBar('Please enter discount or increase value');
                                    }
                                    if(isDiscount){
                                      productPrice = widget.product.intBranchPrice - widget.product.intBranchPrice * (int.parse(enteredDisIncValue) /100);
                                    }else if(isIncrease){
                                      productPrice = productPrice + widget.product.intBranchPrice * (int.parse(enteredDisIncValue) /100);
                                    }else{
                                      productPrice = widget.product.intBranchPrice.roundToDouble();
                                    }
                                    if (languageCode == 'en') {
                                      isStandart1
                                          ? widget.product.colorEn =
                                              AppLocalization.of(context)?.translate('standart') ?? 'Standart'
                                          : AppLocalization.of(context)?.translate('custom') ?? 'Custom';
                                      isCustom1
                                          ? widget.product.colorEn = colorController.text : '';
                                    } else if (languageCode == 'ru') {
                                      isStandart1
                                          ? widget.product.colorRu =
                                              AppLocalization.of(context)?.translate('standart') ?? 'Standart'
                                          : AppLocalization.of(context)?.translate('custom') ?? 'Custom';
                                      isCustom1
                                          ? widget.product.colorRu = colorController.text : '';
                                    } else if (languageCode == 'tr') {
                                      isStandart1
                                          ? widget.product.colorTr =
                                              AppLocalization.of(context)?.translate('standart') ?? 'Standart'
                                          : AppLocalization.of(context)?.translate('custom') ??
                                              'Custom';
                                      isCustom1
                                          ? widget.product.colorTr = colorController.text : '';
                                    } else if (languageCode == 'uz') {
                                      isStandart1
                                          ? widget.product.colorUz =
                                              AppLocalization.of(context)?.translate('standart') ?? 'Standart': AppLocalization.of(context)?.translate('custom') ?? 'Custom';
                                      isCustom1
                                          ? widget.product.colorUz = colorController.text : '';
                                    }

                                    isStandart1
                                        ? widget.product.colorEn =
                                            AppLocalization.of(context)?.translate('standart') ?? 'Standart'
                                        : AppLocalization.of(context)?.translate('custom') ?? 'Custom';
                                    isCustom1
                                        ? widget.product.colorEn = colorController.text : '';
                                    if (isStandart1) {}
                                    isStandart2
                                        ? widget.product.size =
                                            AppLocalization.of(context)?.translate('standart') ?? 'Standart'
                                        : AppLocalization.of(context)?.translate('custom') ?? 'Custom';
                                    isCustom2
                                        ? widget.product.size = sizeController.text : '';

                                    if ((isStandart1 == true || isCustom1 == true) && (isStandart2 == true || isCustom2 == true)) {
                                      CustomProductModel? myProductModel;
                                      if (isStandart1 && isStandart2) {
                                        myProductModel = CustomProductModel(
                                          id: widget.product.id,
                                          nameEn: widget.product.nameEn,
                                          nameRu: widget.product.nameRu,
                                          nameTr: widget.product.nameTr,
                                          nameUz: widget.product.nameUz,
                                          price: widget.product.price,
                                          branchPrice: widget.product.branchPrice,
                                          intBranchPrice: productPrice.round(),
                                          img: widget.product.img,
                                          color: AppLocalization.of(context)?.translate('standart') ?? 'Standart',
                                          size: AppLocalization.of(context)?.translate('standart') ?? 'Standart',
                                          iodp: productPrice,
                                          categoryName: widget.product.categoryName,
                                        );
                                      } else if (isCustom1 && isCustom2) {
                                        myProductModel = CustomProductModel(
                                          id: widget.product.id,
                                          nameEn: widget.product.nameEn,
                                          nameRu: widget.product.nameRu,
                                          nameTr: widget.product.nameTr,
                                          nameUz: widget.product.nameUz,
                                          price: widget.product.price,
                                          branchPrice: widget.product.branchPrice,
                                          intBranchPrice: productPrice.round(),
                                          img: widget.product.img,
                                          color: colorController.text,
                                          size: sizeController.text,
                                          iodp: productPrice,
                                          categoryName: widget.product.categoryName,
                                        );
                                      } else if (isStandart1 && isCustom2) {
                                        myProductModel = CustomProductModel(
                                          id: widget.product.id,
                                          nameEn: widget.product.nameEn,
                                          nameRu: widget.product.nameRu,
                                          nameTr: widget.product.nameTr,
                                          nameUz: widget.product.nameUz,
                                          price: widget.product.price,
                                          branchPrice: widget.product.branchPrice,
                                          intBranchPrice: productPrice.round(),
                                          img: widget.product.img,
                                          color: AppLocalization.of(context)?.translate('standart') ?? 'Standart',
                                          size: sizeController.text,
                                          iodp: productPrice,
                                          categoryName: widget.product.categoryName,
                                        );
                                      } else if (isCustom1 && isStandart2) {
                                        myProductModel = CustomProductModel(
                                          id: widget.product.id,
                                          nameEn: widget.product.nameEn,
                                          nameRu: widget.product.nameRu,
                                          nameTr: widget.product.nameTr,
                                          nameUz: widget.product.nameUz,
                                          price: widget.product.price,
                                          branchPrice: widget.product.branchPrice,
                                          intBranchPrice: productPrice.round(),
                                          img: widget.product.img,
                                          color: colorController.text,
                                          size: AppLocalization.of(context)?.translate('standart') ?? 'Standart',
                                          iodp: productPrice,
                                          categoryName: widget.product.categoryName,
                                        );
                                      }

                                      cartModel.addToCart(
                                        Cart(
                                          id: cartModel.productCounter,
                                          product: myProductModel ??
                                              CustomProductModel(
                                                id: widget.product.id,
                                                nameEn: widget.product.nameEn,
                                                nameRu: widget.product.nameRu,
                                                nameTr: widget.product.nameTr,
                                                nameUz: widget.product.nameUz,
                                                price: widget.product.price,
                                                branchPrice: widget.product.branchPrice,
                                                intBranchPrice:productPrice.round(),
                                                img: widget.product.img,
                                                color: colorController.text,
                                                size: AppLocalization.of(context)?.translate('standart') ?? 'Standart',
                                                iodp: productPrice,
                                                categoryName: widget.product.categoryName,
                                              ),
                                          quantity: ValueNotifier(cartModel.counter),
                                        ),
                                      );
                                      Navigator.of(context).pop();
                                      cartModel.addTotalPrice(productPrice.round(), false);
                                      cartModel.addProductCounter();
                                      cartModel.updateCounter();
                                      showCustomSuccessSnackBar(AppLocalization.of(context)?.translate('product_added_to_cart') ?? 'Товар добавлен в корзину');
                                    } else {
                                      showCustomSnackBar(AppLocalization.of(context)?.translate('color_or_size_not_selected') ?? 'Цвет или размер не выбраны');
                                    }
                                  },
                                  onTapDown: (details){
                                    setState(() {
                                      isTouched = true;
                                    });
                                  },
                                  onTapUp: (details){
                                    setState(() {
                                      isTouched = false;
                                    });
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: 54,
                                    color: isTouched? Color.fromRGBO(171, 116, 64, 1):Color.fromRGBO(171, 116, 64, 0.9),
                                    child: Center(
                                      child: Text(AppLocalization.of(context)?.translate('add_to_cart') ??'Добавить в корзину'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ));
  }

  Widget colorWidget(String text) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: InkWell(
                  child: ListTileTheme(
                    contentPadding: EdgeInsets.all(0),
                    child: CheckboxListTile(
                      contentPadding: EdgeInsets.all(0),
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(
                        AppLocalization.of(context)?.translate('standart') ??
                            'Standart',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 11,
                        ),
                      ),
                      value: isStandart1,
                      onChanged: (bool? val) {
                        setState(() {
                          isCustom1 = false;
                          isStandart1 = val!;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.all(0),
                  title: Text(
                    AppLocalization.of(context)?.translate('custom') ?? 'Custom',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 11,
                    ),
                  ),
                  value: isCustom1,
                  onChanged: (bool? val) {
                    setState(() {
                      isStandart1 = false;
                      isCustom1 = val!;
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: isCustom1 ? 20 : 0,
          ),
          isCustom1
              ? Container(
                  height: 48,
                  child: TextFormField(
                    style: titleRegular.copyWith(fontSize: 18),
                    controller: colorController,
                    decoration: InputDecoration(
                      suffixIcon: Padding(
                        padding: EdgeInsets.only(top: 13, left: 20),
                        child: Text(
                          '*',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: Color.fromRGBO(171, 116, 64, 0.9),
                        ),
                        borderRadius: BorderRadius.circular(0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: ColorsResources.PRIMARY_COLOR,
                        ),
                        borderRadius: BorderRadius.circular(0),
                      ),
                      labelText: AppLocalization.of(context)
                              ?.translate('your_preferences') ??
                          'Ваши предпочтения',
                      labelStyle: titleRegular,
                      hintStyle: titleRegular,
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  Widget sizeWidget(String text) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.all(0),
                  title: Text(
                    AppLocalization.of(context)?.translate('standart') ??
                        'Standart',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 11,
                    ),
                  ),
                  value: isStandart2,
                  onChanged: (bool? val) {
                    setState(() {
                      isCustom2 = false;
                      isStandart2 = val!;
                    });
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.all(0),
                  title: Text(
                    AppLocalization.of(context)?.translate('custom') ??
                        'Custom',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 11,
                    ),
                  ),
                  value: isCustom2,
                  onChanged: (bool? val) {
                    setState(() {
                      isStandart2 = false;
                      isCustom2 = val!;
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: isCustom2 ? 20 : 0,
          ),
          isCustom2
              ? Container(
                  height: 48,
                  child: TextFormField(
                    style: titleRegular.copyWith(fontSize: 18),
                    controller: sizeController,
                    decoration: InputDecoration(
                      suffixIcon: Padding(
                        padding: EdgeInsets.only(top: 13, left: 20),
                        child: Text(
                          '*',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: Color.fromRGBO(171, 116, 64, 0.9),
                        ),
                        borderRadius: BorderRadius.circular(0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: ColorsResources.PRIMARY_COLOR,
                        ),
                        borderRadius: BorderRadius.circular(0),
                      ),
                      labelText: AppLocalization.of(context)
                              ?.translate('your_preferences') ??
                          'Ваши предпочтения',
                      labelStyle: titleRegular,
                      hintStyle: titleRegular,
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  Widget colorWidgetTablet(String text) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: InkWell(
                  child: ListTileTheme(
                    contentPadding: EdgeInsets.all(0),
                    child: CheckboxListTile(
                      contentPadding: EdgeInsets.all(0),
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(
                        AppLocalization.of(context)?.translate('standart') ??
                            'Standart',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 11,
                        ),
                      ),
                      value: isStandart1,
                      onChanged: (bool? val) {
                        setState(() {
                          isCustom1 = false;
                          isStandart1 = val!;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.all(0),
                  title: Text(
                    AppLocalization.of(context)?.translate('custom') ??
                        'Custom',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 11,
                    ),
                  ),
                  value: isCustom1,
                  onChanged: (bool? val) {
                    setState(() {
                      isStandart1 = false;
                      isCustom1 = val!;
                    });
                  },
                ),
              ),
              Expanded(
                  flex: 2,
                  child: isCustom1
                      ? Container(
                          height: 48,
                          child: TextFormField(
                            style: titleRegular.copyWith(fontSize: 18),
                            controller: colorController,
                            decoration: InputDecoration(
                              suffixIcon: Padding(
                                padding: EdgeInsets.only(top: 13, left: 20),
                                child: Text(
                                  '*',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Color.fromRGBO(171, 116, 64, 0.9),
                                ),
                                borderRadius: BorderRadius.circular(0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                  color: ColorsResources.PRIMARY_COLOR,
                                ),
                                borderRadius: BorderRadius.circular(0),
                              ),
                              labelText: AppLocalization.of(context)
                                      ?.translate('your_preferences') ??
                                  'Ваши предпочтения',
                              labelStyle: titleRegular,
                              hintStyle: titleRegular,
                            ),
                          ),
                        )
                      : Container())
            ],
          ),
        ],
      ),
    );
  }

  Widget sizeWidgetTablet(String text) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: InkWell(
                  child: ListTileTheme(
                    contentPadding: EdgeInsets.all(0),
                    child: CheckboxListTile(
                      contentPadding: EdgeInsets.all(0),
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(
                        AppLocalization.of(context)?.translate('standart') ??
                            'Standart',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 11,
                        ),
                      ),
                      value: isStandart2,
                      onChanged: (bool? val) {
                        setState(() {
                          isCustom2 = false;
                          isStandart2 = val!;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.all(0),
                  title: Text(
                    AppLocalization.of(context)?.translate('custom') ??
                        'Custom',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 11,
                    ),
                  ),
                  value: isCustom2,
                  onChanged: (bool? val) {
                    setState(() {
                      isStandart2 = false;
                      isCustom2 = val!;
                    });
                  },
                ),
              ),
              Expanded(
                  flex: 2,
                  child: isCustom2
                      ? Container(
                          height: 48,
                          child: TextFormField(
                            style: titleRegular.copyWith(fontSize: 18),
                            controller: sizeController,
                            decoration: InputDecoration(
                              suffixIcon: Padding(
                                padding: EdgeInsets.only(top: 13, left: 20),
                                child: Text(
                                  '*',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Color.fromRGBO(171, 116, 64, 0.9),
                                ),
                                borderRadius: BorderRadius.circular(0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                  color: ColorsResources.PRIMARY_COLOR,
                                ),
                                borderRadius: BorderRadius.circular(0),
                              ),
                              labelText: AppLocalization.of(context)
                                      ?.translate('your_preferences') ??
                                  'Ваши предпочтения',
                              labelStyle: titleRegular,
                              hintStyle: titleRegular,
                            ),
                          ),
                        )
                      : Container())
            ],
          ),
        ],
      ),
    );
  }
}
