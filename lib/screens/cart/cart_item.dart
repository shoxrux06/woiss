import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:furniture_app/data/cart.dart';
import 'package:furniture_app/localization/app_localization.dart';
import 'package:furniture_app/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class CartItem extends StatefulWidget {
  final Cart cart;
  final int index;

  const CartItem({Key? key, required this.cart, required this.index}) : super(key: key);

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  double paddingValue = 0.0;
  @override
  Widget build(BuildContext context) {
    final myModel = Provider.of<CartProvider>(context, listen: true);

    String languageCode = Localizations.localeOf(context).languageCode;
    String productName ='';
    double screenWidth = MediaQuery.of(context).size.width;
    if(screenWidth >= 600 && screenWidth <= 700){
      paddingValue = 20.0;
    }else if(screenWidth > 700){
      paddingValue = 50.0;
    }else{
      paddingValue = 20.0;
    }
    return Consumer<CartProvider>(builder: (context, cart, child) {
      if(languageCode == 'en'){
        productName = widget.cart.product.nameEn;
      }else if(languageCode == 'ru'){
        productName = widget.cart.product.nameRu;
      }else if(languageCode == 'tr'){
        productName = widget.cart.product.nameTr;
      }else if(languageCode == 'uz'){
        productName = widget.cart.product.nameUz;
      }
      return cart.cartList.isNotEmpty?Container(
        padding: EdgeInsets.symmetric(horizontal:paddingValue),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FittedBox(
                  child: Container(
                    color: Colors.white,
                    width: 90,
                    height: 90,
                    margin: EdgeInsets.only(bottom: 24),
                    child: CachedNetworkImage(
                      imageUrl:'${widget.cart.product.img}',
                      placeholder: (BuildContext context, String url) => Container(
                        width: 90,
                        height: 90,
                        color: Colors.grey,
                      ),
                      errorWidget: (context,url,error) => new Icon(Icons.error),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SizedBox(
                  width: 24,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      child: Text(
                        (screenWidth >= 600 && screenWidth <= 850)?productName.length > 10? '${productName.substring(0,10)} ...': productName:productName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 8,),
                    FittedBox(
                      child: Text(
                        '${widget.cart.product.categoryName.toLowerCase()}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    SizedBox(height: 8,),
                    FittedBox(
                      child: Text(
                        '${widget.cart.product.branchPrice}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontFamily: 'Roboto',
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(height: 8,),
                    SizedBox(
                      width: 12,
                    ),
                    FittedBox(
                      child: Text(
                            widget.cart.product.color.length > 12?'${AppLocalization.of(context)?.translate('color')?? 'Цвет'}: ${(screenWidth >=0 && screenWidth <=850)?''
                            '${widget.cart.product.color.substring(0,12)} ...':'${widget.cart.product.color}'}':'${AppLocalization.of(context)?.translate('color')?? 'Цвет'}: ${widget.cart.product.color}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontFamily: 'Roboto',
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(height: 8,),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      widget.cart.product.size.length >12?'${AppLocalization.of(context)?.translate('size')?? 'Размер'}: ${(screenWidth >=0 && screenWidth <=850)?
                      '${widget.cart.product.size.substring(0,12)} ...':'${widget.cart.product.size}'}':'${AppLocalization.of(context)?.translate('size')?? 'Размер'}: ${widget.cart.product.size}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontFamily: 'Roboto',
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 8,),
                    Row(
                      children: [
                        ValueListenableBuilder<int>(valueListenable:
                        cart.cartList[widget.index].quantity,
                            builder: (context, value, child){
                          return FittedBox(
                            child: InkWell(
                              onTap:cart.cartList[widget.index].quantity.value <= 1?null: () {
                                myModel.deleteQuantity(cart.cartList[widget.index].id);
                                if(cart.cartList[widget.index].quantity.value >= 1){
                                  myModel.removeTotalPrice(cart.cartList[widget.index].product.intBranchPrice);
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.only(top: 0, right: 4, left: 0, bottom: 8),
                                child: Center(
                                  child: Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                        SizedBox(
                          width: 10,
                        ),
                        ValueListenableBuilder(valueListenable: widget.cart.quantity, builder: (context, value, child){
                          return FittedBox(
                            child: Container(
                              padding: EdgeInsets.only(bottom: 8),
                              child: Text(
                                '$value',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          );
                        }),
                        SizedBox(
                          width: 10,
                        ),
                        ValueListenableBuilder<int>(valueListenable: cart.cartList[widget.index].quantity, builder: (context, value, child){
                          return FittedBox(
                            child: InkWell(
                              onTap: () {
                                myModel.addQuantity(cart.cartList[widget.index].id);
                                myModel.addTotalPrice(cart.cartList[widget.index].product.intBranchPrice, true);
                              },
                              child: Container(
                                padding: EdgeInsets.only(top: 0, right: 8, left: 0, bottom: 8),
                                child: Center(
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
                Spacer(),
                FittedBox(
                  child: InkWell(
                    onTap: () {
                      print('Before CartList ******${cart.cartList}');
                      cart.removeItem(widget.cart.id);
                      print('After ******${cart.cartList}');
                    },
                    child: Image.asset(
                      'assets/icons/delete.png',
                      width: 20,
                      height: 22,
                    ),
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Divider(
              height: 1,
              color: Color.fromRGBO(171, 116, 64, 0.9),
            ),
            SizedBox(
              height: 12,
            ),
          ],
        ),
      ): Container();
    });
  }
}
