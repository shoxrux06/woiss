import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:furniture_app/controller/invoice_controller.dart';
import 'package:furniture_app/data/model/response/order_get_model.dart';
import 'package:furniture_app/localization/app_localization.dart';
import 'package:furniture_app/providers/cart_provider.dart';
import 'package:furniture_app/screens/cart/print_commercial_screen.dart';
import 'package:furniture_app/utils/color_resources.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../data/model/client_model.dart';
import 'custom_item_widget.dart';

class SubmitCommercialScreen extends StatefulWidget {
  const SubmitCommercialScreen({Key? key,required this.orderId,
    required this.clientModel, required this.order}) : super(key: key);
  final int? orderId;
  final Result? clientModel;
  final Order? order;

  @override
  State<SubmitCommercialScreen> createState() => _SubmitCommercialScreenState();
}

class _SubmitCommercialScreenState extends State<SubmitCommercialScreen> {
  File? file;

  final controller = Get.find<InvoiceController>();

  var subTotal;
  var total;

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
    double screenWidth = MediaQuery.of(context).size.width;
    print('buildMethod Order in Commercial>>>>>>>>${widget.order}');
    print('OrderId in Commercial>>>>>>>>${widget.orderId}');
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leadingWidth: screenWidth >= 600?240:54,
          leading: Container(
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Platform.isIOS? Icons.arrow_back_ios:Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
          backgroundColor: ColorsResources.PRIMARY_BACKROUND_COLOR,
        ),
        body: Consumer<CartProvider>(
          builder: (BuildContext context, cart, Widget? child) {
            print('ClientMode>>>>>>>>>>>>>>>>>>>>${widget.clientModel}');
            if(cart.cartList.isNotEmpty){
              subTotal = cart.totalPrice - cart.totalPrice * ((widget.clientModel?.discount??0)/100);
              total = cart.totalPrice;
            }else{
              total = widget.order?.orderItems.map((e) => e.quantity * e.productId.price.intBranchPrice).reduce((value, element) => value + element);
              subTotal = total - total * ((widget.clientModel?.discount??0)/100);
            }

            print('subTotal>>>>>>>>>>>>>>>> in submit comericial$subTotal');
            print('subTotal>>>>>>>>>>>>>>>> in submit discount${widget.clientModel?.discount??0}');
            return Container(
              color: ColorsResources.PRIMARY_BACKROUND_COLOR,
              padding: screenWidth >= 600? EdgeInsets.only(left: 120, right: 120, top: 30,bottom: 50):EdgeInsets.all(20),
              child: Column(
                children: [
                  CustomItemWidget(startText: AppLocalization.of(context)?.translate('price')??'Цена', endText: '${moneyFormat(total.toInt().toString())} ${widget.order != null? widget.order?.orderItems[0].productId.price.branchPrice.substring(widget.order!.orderItems[0].productId.price.branchPrice.lastIndexOf(' ',widget.order?.orderItems[0].productId.price.branchPrice.length)): ''}'),
                  CustomItemWidget(startText: AppLocalization.of(context)?.translate('discount')?? 'Скидка', endText: '${widget.clientModel?.discount}%'),
                  CustomItemWidget(startText: AppLocalization.of(context)?.translate('to_sum_it_up')??'Под итог', endText:  '${moneyFormat((subTotal.toInt().toString()))} ${widget.order != null? widget.order?.orderItems[0].productId.price.branchPrice.substring(widget.order!.orderItems[0].productId.price.branchPrice.lastIndexOf(' ',widget.order?.orderItems[0].productId.price.branchPrice.length)): ''}',),
                  SizedBox(
                    height: 24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalization.of(context)?.translate('total')??'Итог',
                        style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 0.9),
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          height: 16 / 14,
                        ),
                      ),
                      Text(
                        '${moneyFormat((subTotal.toInt().toString()))} ${widget.order != null? widget.order?.orderItems[0].productId.price.branchPrice.substring(widget.order!.orderItems[0].productId.price.branchPrice.lastIndexOf(' ',widget.order?.orderItems[0].productId.price.branchPrice.length)): ''}',
                        style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 0.8),
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          height: 19 / 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Divider(
                    height: 1,
                    color: Color.fromRGBO(171, 116, 64, 0.9),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () async {
                      print('OnTap Order in Commercial>>>>>>>>${widget.order}');
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => PrintCommercialScreen(discount: widget.clientModel?.discount??0,clientModel: widget.clientModel,order: widget.order, orderItems:widget.order?.orderItems?? [],),
                      ));
                    },
                    child: Container(
                      width: double.infinity,
                      height: 54,
                      color: Color.fromRGBO(171, 116, 64, 0.9),
                      child: Center(
                        child: Text(AppLocalization.of(context)?.translate('submit_commercial')??'Подать коммерческое'),
                      ),
                    ),
                  ),
                  SizedBox(height: 32,)
                ],
              ),
            );
          },
        ));
  }

}
