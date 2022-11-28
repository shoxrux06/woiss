import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:furniture_app/localization/app_localization.dart';
import 'package:furniture_app/providers/cart_provider.dart';
import 'package:provider/provider.dart';

import '../../data/model/response/order_get_model.dart';


class OrderItemWidget extends StatefulWidget {
  final OrderItem orderItem;
  final int index;

  const OrderItemWidget({Key? key, required this.orderItem, required this.index}) : super(key: key);

  @override
  State<OrderItemWidget> createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {

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
    String languageCode = Localizations.localeOf(context).languageCode;
    String productName ='productName';
    String productColor = 'red';

    final screenWidth = MediaQuery.of(context).size.width;

    print('widget.orderItem))))))))${widget.orderItem}');
    return Consumer<CartProvider>(builder: (context, cart, child) {
      if(languageCode == 'en') {
        productName = widget.orderItem.productId.nameEn;
      }else if(languageCode == 'ru'){
        productName = widget.orderItem.productId.nameRu;
      }else if(languageCode == 'tr'){
        productName = widget.orderItem.productId.nameTr;
      }else if(languageCode == 'uz'){
        productName = widget.orderItem.productId.nameUz;
      }
      productColor = widget.orderItem.color;

      return Container(
        padding: EdgeInsets.symmetric(horizontal: screenWidth>600?50: 20),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  color: Colors.white,
                  width: 90,
                  height: 90,
                  margin: EdgeInsets.only(bottom: 16),
                  child: CachedNetworkImage(
                    imageUrl:widget.orderItem.productId.img,
                    placeholder: (BuildContext context, String url) => Container(
                      width: 320,
                      height: 240,
                      color: Colors.grey,
                    ),
                    errorWidget: (context,url,error) => new Icon(Icons.error),
                    fit: BoxFit.fill,
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
                    (screenWidth >= 600 && screenWidth <= 850)?productName.length >10?'${productName.substring(0,10)} ...':productName: productName ,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontFamily: 'Roboto',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 8,),
                    Text(
                      widget.orderItem.productId.categoryId.name,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8,),
                    Text(
                      '${moneyFormat(widget.orderItem.iodp.round().toString())}${widget.orderItem.productId.price.branchPrice.substring(widget.orderItem.productId.price.branchPrice.lastIndexOf(' '),widget.orderItem.productId.price.branchPrice.length)}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontFamily: 'Roboto',
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 8,),
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                    widget.orderItem.color.length>12?'${AppLocalization.of(context)?.translate('color')?? 'Цвет'}: '
                    '${(screenWidth >= 0 && screenWidth <= 850)? '${widget.orderItem.color.substring(0,12)} ...':
                    '${widget.orderItem.color}'}':'${AppLocalization.of(context)?.translate('color')?? 'Цвет'}: ${widget.orderItem.color}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontFamily: 'Roboto',
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 8,),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                  widget.orderItem.size.length>12?'${AppLocalization.of(context)?.translate('size')?? 'Размер'}: ${(screenWidth >= 0 &&
                  screenWidth < 850)?'${widget.orderItem.size.substring(0,12)} ...':'${widget.orderItem.size}'}':'${AppLocalization.of(context)?.translate('size')?? 'Размер'}: ${widget.orderItem.size}',
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
                        Text(
                          '${AppLocalization.of(context)?.translate('quantity')?? 'Quantity'}:',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontFamily: 'Roboto',
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '${widget.orderItem.quantity}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontFamily: 'Roboto',
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Spacer(),
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
      );
    });
  }
}
