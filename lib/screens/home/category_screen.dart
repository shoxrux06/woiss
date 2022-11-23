import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:furniture_app/controller/product_controller.dart';
import 'package:furniture_app/data/model/response/product_model.dart';
import 'package:furniture_app/localization/app_localization.dart';
import 'package:furniture_app/providers/cart_provider.dart';
import 'package:furniture_app/screens/home/product_details_screen.dart';
import 'package:furniture_app/utils/size_config.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../data/repository/product_repository.dart';
import '../../utils/color_resources.dart';
import '../../utils/custom_themes.dart';
import '../cart/cart_screen.dart';
import 'home_screen.dart';

class CategoryScreen extends StatefulWidget {
  final int catId;
  final String catName;

  const CategoryScreen({
    Key? key,
    required this.catId,
    required this.catName,
  }) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  TextEditingController searchController = TextEditingController();
  double paddingValue = 0.0;

  final _controller =
      Get.put(ProductController(productRepo: ProductRepository()));

  String? moneyFormat(String price) {
    if (price.length > 2) {
      var value = price;
      value = value.replaceAll(RegExp(r'\D'), '');
      value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ' ');
      return value;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.getProductList(widget.catId);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    String languageCode =
        Localizations.localeOf(context).languageCode;

    SizeConfig().init(context);
    final isLandscape = MediaQuery.of(context).orientation ==
        Orientation.landscape;

    if(screenWidth >= 600 && screenWidth <=700){
      paddingValue = 20.0;
    }else if(screenWidth > 700){
      paddingValue = 50.0;
    }else{
      paddingValue = 20.0;
    }
    print(
        'LanguageCode>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>${Localizations.localeOf(context).languageCode}');
    print('Category Product Id ----------> ${widget.catId}');
    String productName = '';
    return Scaffold(
      backgroundColor: ColorsResources.PRIMARY_BACKROUND_COLOR,
      body: AnnotatedRegion(child: SafeArea(
          child: Container(
            color: ColorsResources.PRIMARY_BACKROUND_COLOR,
            child: GetBuilder<ProductController>(
              init: ProductController(productRepo: ProductRepository()),
              builder: (prodController) {
                print('@@@@@@@@@@@@@@@ prodController.productList ${prodController.productList}@@@@@@@@@@@@@@@ prodController.productList ');
                return CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      toolbarHeight: screenWidth >= 600 ? 100 : 48,
                      expandedHeight: 80,
                      elevation: 0,
                      title: screenWidth >= 600
                          ? Container(
                        padding: EdgeInsets.only(top: 4, bottom: 8, left: 100),
                        color: ColorsResources.PRIMARY_BACKROUND_COLOR,
                        height: 56,
                        child: TextFormField(
                          style: titleRegular.copyWith(fontSize: 18),
                          controller: searchController,
                          onChanged: (value) =>
                              prodController.updateProductString(value,languageCode),
                          decoration: InputDecoration(
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
                                ?.translate('search_product') ??
                                'Поиск продукта',
                            labelStyle: titleRegular,
                            hintStyle: titleRegular,
                            suffixIcon: IconButton(
                              onPressed: () {
                                searchController.text = '';
                              },
                              icon: Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                          : Text(
                        '${widget.catName}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      centerTitle: true,
                      backgroundColor: ColorsResources.PRIMARY_BACKROUND_COLOR,
                      leadingWidth: screenWidth >= 600?120: 54,
                      actions: [
                        Consumer<CartProvider>(builder: (context, value, child) {
                          return Padding(
                            padding: EdgeInsets.only(left: 24, right: screenWidth >=600?32: 20),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (_) => CartScreen()
                                    )
                                );
                              },
                              child: Align(
                                alignment: Alignment.center,
                                child: value.cartList.length == 0
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
                                        height: 54
                                    ),
                                    Positioned(
                                        top: 12,
                                        right: 4,
                                        child: Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            color:
                                            ColorsResources.PRIMARY_COLOR,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${value.cartList.length}',
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          );
                        })
                      ],
                    ),
                    if (screenWidth < 600)
                      SliverPersistentHeader(
                        floating: true,
                        pinned: true,
                        delegate: SliverDelegate(
                          child: Container(
                            padding: EdgeInsets.only(top: 4, bottom: 8, left: 20, right: 20),
                            color: ColorsResources.PRIMARY_BACKROUND_COLOR,
                            height: 56,
                            child: TextFormField(
                              style: titleRegular.copyWith(fontSize: 18),
                              controller: searchController,
                              onChanged: (value) =>
                                  prodController.updateProductString(value, languageCode),
                              decoration: InputDecoration(
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
                                    ?.translate('search_product') ??
                                    'Поиск продукта',
                                labelStyle: titleRegular,
                                hintStyle: titleRegular,
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    searchController.text = '';
                                  },
                                  icon: Icon(
                                    Icons.search,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    SliverToBoxAdapter(
                      child: Container(
                        padding: EdgeInsets.only(left:paddingValue, right: paddingValue, bottom: paddingValue),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 16,
                            ),
                            Container(
                              child: Text(
                                '${widget.catName}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Container(
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  if (languageCode == 'en') {
                                    productName =
                                        prodController.productList[index].nameEn;
                                  } else if (languageCode == 'ru') {
                                    productName =
                                        prodController.productList[index].nameRu;
                                  } else if (languageCode == 'tr') {
                                    productName =
                                        prodController.productList[index].nameTr;
                                  } else if (languageCode == 'uz') {
                                    productName =
                                        prodController.productList[index].nameUz;
                                  }
                                  return InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                          print(
                                              '${prodController.productList[index]}');
                                          return ProductDetailsScreen(
                                              catName: widget.catName,
                                              productName: productName,
                                              product: prodController
                                                  .productList[index]);
                                        }),
                                      );
                                    },
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Container(
                                            // padding: EdgeInsets.all(4),
                                            decoration:
                                            BoxDecoration(color: Colors.white),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                              '${prodController.productList[index].img}',
                                              placeholder: (BuildContext context,
                                                  String url) =>
                                                  Container(
                                                    width: 320,
                                                    height: 240,
                                                    color: Colors.grey,
                                                  ),
                                              errorWidget: (context, url, error) =>
                                              new Icon(Icons.error),
                                              width: double.infinity,
                                              height: 154,
                                              // fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          Text(
                                            productName,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                              prodController.productList[index].branchPrice.toString(),
                                            // '${moneyFormat(prodController.productList[index].branchPrice.toString())} ${AppLocalization.of(context)?.translate('sum') ?? 'сум'}',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                itemCount: prodController.productList.length,
                                gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: screenWidth >= 600 ? 3 : 2,
                                    childAspectRatio:(isLandscape)?SizeConfig.aspectRatio*0.7: SizeConfig.aspectRatio*1.4,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 4
                                  // mainAxisExtent: 20,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          )),
        value: SystemUiOverlayStyle.light,)
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Future.delayed(Duration.zero, () {
      _controller.updateProductString('','');
    });
  }
}
