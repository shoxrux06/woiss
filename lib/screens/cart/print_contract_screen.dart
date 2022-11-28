import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:furniture_app/data/model/client_model.dart';
import 'package:furniture_app/data/model/client_payment.dart';
import 'package:furniture_app/providers/invoice_provider.dart';
import 'package:furniture_app/utils/color_resources.dart';
import 'package:furniture_app/utils/custom_themes.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../data/cart.dart';
import '../../data/model/invoice.dart';
import '../../data/model/response/custom_product_model.dart';
import '../../data/model/response/product_model.dart';
import '../../data/model/supplier_model.dart';
import '../../localization/app_localization.dart';
import '../../providers/cart_provider.dart';
import '../../utils/cache_manager.dart';
import '../pdf/pdf_review.dart';
import 'cart_screen.dart';
import 'package:furniture_app/data/model/response/order_get_model.dart';
import 'custom_item_widget.dart';
import 'oder_item_widget.dart';

class PrintContractScreen extends StatefulWidget {
  const PrintContractScreen(
      {Key? key,
      required this.discount,
      required this.order,
        this.amount = 0,
        this.orderId,
      required this.clientModel,
      required this.orderItems
      })
      : super(key: key);

  final int discount;
  final Order? order;
  final int amount;
  final int? orderId;
  final Result? clientModel;
  final List<OrderItem> orderItems;

  @override
  State<PrintContractScreen> createState() => _PrintContractScreenState();
}

class _PrintContractScreenState extends State<PrintContractScreen> {
  int totalPrice = 0;
  int totalSum = 0;
  int editedTotalSum = 0;

  double paddingValue = 0.0;

  List<OrderItem> myOrderItems = [];

  List<Cart> cartItems = [];

  bool isPayedPrePayment = false;

  double prePayment1 = 0;
  double remainingPayment1 = 0;
  double remainingPayment2 = 0;

  final paymentController = TextEditingController();

  @override
  void initState() {

    if(widget.order != null){
      for(int i = 0;i<widget.order!.orderItems.length;i++){
        totalSum += (widget.order!.orderItems[i].iodp.round() * widget.order!.orderItems[i].quantity) ;
      }
    }else{
      for(int i = 0;i<widget.orderItems.length;i++){
        editedTotalSum += (widget.orderItems[i].iodp.round() * widget.orderItems[i].quantity);
      }
    }

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('orderItems>>>>${widget.orderItems}');

    myOrderItems = widget.orderItems;

    totalPrice = myOrderItems.map((e) => e.quantity * e.productId.price.intBranchPrice).reduce((value, element) => value + element);

    for (int i = 0; i <myOrderItems.length; i++) {
      cartItems.add(
        Cart(
          id: myOrderItems[i].id,
          product: CustomProductModel(
            id: myOrderItems[i].productId.id,
            nameEn: myOrderItems[i].productId.nameEn,
            nameRu: myOrderItems[i].productId.nameRu,
            nameUz: myOrderItems[i].productId.nameUz,
            nameTr: myOrderItems[i].productId.nameTr,
            price: myOrderItems[i].productId.price.price,
            branchPrice: myOrderItems[i].productId.price.branchPrice,
            intBranchPrice: myOrderItems[i].productId.price.intBranchPrice,
            img: myOrderItems[i].productId.img,
            color: myOrderItems[i].color,
            size: myOrderItems[i].size,
            iodp: myOrderItems[i].iodp,
            categoryName: myOrderItems[i].productId.categoryId.name,
          ),
          quantity: ValueNotifier(
            myOrderItems[i].quantity,
          ),
        ),
      );
    }


    String? moneyFormat(String price) {
      if (price.length > 2) {
        var value = price;
        value = value.replaceAll(RegExp(r'\D'), '');
        value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ' ');
        return value;
      }
    }

    final screenWidth=MediaQuery.of(context).size.width;

    String valyutaName = 'sum';

    if(screenWidth >= 600 && screenWidth <= 700){
      paddingValue = 20.0;
    }else if(screenWidth > 700){
      paddingValue = 50.0;
    }else{
      paddingValue = 20.0;
    }
    double totalSumTwo = totalSum- totalSum * (widget.discount / 100);
    double editedTotalSumTwo = editedTotalSum - (editedTotalSum * (widget.discount / 100));
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.order != null? 'WOISS-${widget.order?.orderNumber}':'WOISS-${widget.orderId}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 14 / 16,
          ),
        ),
        leadingWidth: screenWidth >=600?120: 54,
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
        actions: [
          SizedBox(width: 48,),
          InkWell(
            onTap: () {
              context.read<CartProvider>().setItemsToCart(cartItems);
              context.read<CartProvider>().updateTotalPrice(totalPrice);
              context.read<InvoiceProvider>().setContractEditOrNot(true);
              if(widget.order != null){
                context.read<InvoiceProvider>().setContractOrderId(widget.order?.id ?? 0);
              }else{
                context.read<InvoiceProvider>().setContractOrderId(widget.orderId?? 0);
              }
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => CartScreen(client: widget.clientModel,)),
                (route) => false,
              );
            },
            child: Container(
              // color: Colors.red,
              width: 48,
              height: 48,
              padding: EdgeInsets.all(14),
              child: Image.asset(
                'assets/icons/edit.png',
                width: 16,
                height: 16,
              ),
            ),
          ),
          SizedBox(
            width: screenWidth >= 600?32:8,
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: ((context, cart, child) {
          var subTotal = cart.totalPrice - cart.totalPrice * (widget.discount / 100);
          print('valyutaName---->$valyutaName');
          if(cart.cartList.isNotEmpty){
            valyutaName = cart.cartList[0].product.branchPrice.substring(cart.cartList[0].product.branchPrice.lastIndexOf(' ',cart.cartList[0].product.branchPrice.length));
            print('valyutaName---->$valyutaName');
          }
          if(widget.orderItems.isNotEmpty){
            valyutaName = widget.orderItems[0].productId.price.branchPrice.substring(widget.orderItems[0].productId.price.branchPrice.lastIndexOf(' '),widget.orderItems[0].productId.price.branchPrice.length);
          }
          return Container(
            color: ColorsResources.PRIMARY_BACKROUND_COLOR,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return ConstrainedBox(
                  constraints: BoxConstraints(minHeight: (constraints.maxHeight)),
                  child: CustomScrollView(
                    slivers: [
                      screenWidth>=600?SliverGrid(
                        gridDelegate:
                        SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: screenWidth / 2,
                          mainAxisSpacing: 10.0,
                          crossAxisSpacing: 10.0,
                          childAspectRatio: (screenWidth>=600 && screenWidth <= 700)?1.6: 2.0,
                        ),
                        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                          return OrderItemWidget(index: index,orderItem: widget.orderItems[index]);
                        },
                            childCount: widget.orderItems.length,),
                      )
                          : SliverList(
                        delegate: SliverChildBuilderDelegate(
                                (context, index) => OrderItemWidget(index: index,orderItem: widget.orderItems[index]),
                            childCount: widget.orderItems.length
                        ),
                      ),
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child:  screenWidth>600? Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: paddingValue,
                            vertical: paddingValue
                          ),
                          child: Column(
                            children:[
                              Spacer(),
                              Row(
                                children: [
                                  Expanded(child:  CustomItemWidget(
                                      startText: AppLocalization.of(context)
                                          ?.translate('price') ??
                                          'Цена',
                                      endText:
                                      '${moneyFormat(widget.order != null?(totalSum.toString()): (editedTotalSum.toString()))}$valyutaName'),),
                                  SizedBox(width: 24,),
                                  Expanded(child:  CustomItemWidget(
                                    startText: AppLocalization.of(context)
                                        ?.translate('to_sum_it_up') ??
                                        'Под итог',
                                    endText:
                                    '${moneyFormat(widget.order != null? ((totalSum- totalSum * (widget.discount / 100)).toInt().toString()):
                                    ((editedTotalSum - (editedTotalSum * (widget.discount / 100))).toInt()).toString())}$valyutaName',
                                  ),)
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(child: CustomItemWidget(
                                      startText: AppLocalization.of(context)
                                          ?.translate('discount') ??
                                          'Скидка',
                                      endText: '${widget.discount}%'),),
                                  SizedBox(width: 24,),
                                  Expanded(child: Column(
                                    children:[
                                      SizedBox(height: 28,),
                                      Divider(
                                        height: 1,
                                        color: Color.fromRGBO(171, 116, 64, 0.9),
                                      ),
                                      SizedBox(height: 12,),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            AppLocalization.of(context)?.translate('total') ?? 'Итог',
                                            style: TextStyle(
                                              color: Color.fromRGBO(255, 255, 255, 0.9),
                                              fontFamily: 'Roboto',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              height: 16 / 14,
                                            ),
                                          ),
                                          Text(
                                            '${moneyFormat(widget.order != null? ((totalSum- totalSum * (widget.discount / 100)).toInt().toString()):
                                            ((editedTotalSum - (editedTotalSum * (widget.discount / 100))).toInt()).toString())}$valyutaName',
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
                                    ]
                                  )),
                                ],
                              ),
                              SizedBox(height: 24,),
                              InkWell(
                                onTap: () async {
                                  return showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      backgroundColor: ColorsResources
                                          .PRIMARY_BACKROUND_COLOR,
                                      title: Text(
                                        AppLocalization.of(context)?.translate(
                                            'do_you_want_to_print') ??
                                            "Хотите распечатать?",
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
                                        AppLocalization.of(context)?.translate('this_contract_is_ready_for_printing') ??
                                            "Этот договор готов к печатиx",
                                        style: TextStyle(
                                          color: Color.fromRGBO(
                                              255, 255, 255, 0.9),
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
                                            AppLocalization.of(context)
                                                ?.translate('no') ??
                                                "Нет",
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
                                            final cacheManager = CacheManager();

                                            String userName = await cacheManager.getUserName() ?? 'MUSTAFA TULGAR';
                                            String userEmail = await cacheManager.getUserEmail() ?? 'woiss.uz@gmail.com';
                                            String branchPhone = await cacheManager.getBranchPhone() ?? '93 844 00 06';

                                            Navigator.of(ctx).pop();
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) => PdfPreviewPage(
                                                  invoice: Invoice(
                                                    id: widget.order?.orderItems[0].orderId ?? 0,
                                                    client: widget.clientModel,
                                                    supplier: SupplierModel(
                                                        supplierName: userName,
                                                        supplierEmail: userEmail,
                                                        supplierPhoneNumber: branchPhone
                                                    ),
                                                    order: widget.order,
                                                    orderItems:widget.order != null? widget.order?.orderItems??[] : widget.orderItems,
                                                    dateTime: DateTime.now(),
                                                    clientPayment: ClientPayment(prepaidAmount: 0,remainingAmount: 0),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            AppLocalization.of(context)
                                                ?.translate('yes') ??
                                                "Да",
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
                                child: Container(
                                  width: double.infinity,
                                  height: 54,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1,
                                        color: Color.fromRGBO(171, 116, 64, 0.9),
                                      )),
                                  child: Container(
                                    padding:
                                    EdgeInsets.symmetric(horizontal: 24),
                                    color:
                                    ColorsResources.PRIMARY_BACKROUND_COLOR,
                                    height: 54,
                                    child: Center(
                                      child: Text(
                                        AppLocalization.of(context)
                                            ?.translate('print_contract') ??
                                            'Распечатать договор',
                                        style: TextStyle(
                                          color: Color.fromRGBO(
                                              255, 255, 255, 0.9),
                                          fontFamily: 'Roboto',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          height: 16 / 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 24,),
                            ]
                          ),
                        ):Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Spacer(),
                              CustomItemWidget(
                                  startText: AppLocalization.of(context)
                                      ?.translate('price') ??
                                      'Цена',
                                  endText:
                                  '${moneyFormat(widget.order != null?(totalSum.toString()): (editedTotalSum.toString()))}$valyutaName'),
                              CustomItemWidget(
                                  startText: AppLocalization.of(context)
                                      ?.translate('discount') ??
                                      'Скидка',
                                  endText: '${widget.discount}%'),
                              CustomItemWidget(
                                startText: AppLocalization.of(context)
                                    ?.translate('to_sum_it_up') ??
                                    'Под итог',
                                endText:
                                '${moneyFormat(widget.order != null? ((totalSum- totalSum * (widget.discount / 100)).toInt().toString()):
                                ((editedTotalSum - (editedTotalSum * (widget.discount / 100))).toInt()).toString())}$valyutaName',
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppLocalization.of(context)?.translate('total') ?? 'Итог',
                                    style: TextStyle(
                                      color: Color.fromRGBO(255, 255, 255, 0.9),
                                      fontFamily: 'Roboto',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      height: 16 / 14,
                                    ),
                                  ),
                                  Text(
                                    '${moneyFormat(widget.order != null? totalSumTwo.toInt().toString(): (editedTotalSumTwo.toInt()).toString())}$valyutaName',
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
                                height: 24,
                              ),
                              SizedBox(
                                height: 48,
                                child: TextFormField(
                                  onChanged: (value) {

                                  },
                                  style: titleRegular.copyWith(fontSize: 18),
                                  controller: paymentController,
                                  decoration: InputDecoration(
                                    suffixIcon: InkWell(
                                      onTap: (){
                                        if(paymentController.text.isNotEmpty){
                                          prePayment1 = double.parse(paymentController.text);
                                          remainingPayment1 = totalSumTwo - double.parse(paymentController.text);
                                          remainingPayment2 = editedTotalSumTwo - double.parse(paymentController.text);
                                          print('Pre Payment---> $prePayment1');
                                          print('remainingPayment1-> $remainingPayment1');
                                          print('remainingPayment2--> $remainingPayment2');
                                          setState(() {
                                            isPayedPrePayment = true;
                                          });
                                        }
                                      },
                                      child: Container(
                                        width: 54,
                                        height: 48,
                                        decoration: const BoxDecoration(
                                          color: ColorsResources.PRIMARY_COLOR,
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'Ok',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
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
                                    labelText: 'Prepayment',
                                    labelStyle: titleRegular,
                                    hintStyle: titleRegular,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              CustomItemWidget(
                                // startText: AppLocalization.of(context)?.translate('to_sum_it_up') ?? 'Под итог',
                                  startText: 'Предоплата',
                                  endText:
                                  '${isPayedPrePayment? moneyFormat(widget.order != null ? (prePayment1.round().toString()) : (prePayment1.round().toString())): prePayment1}'
                                      '${(widget.order != null? widget.order!.orderItems[0].productId.price.branchPrice.
                                  substring(widget.order!.orderItems[0].productId.price.branchPrice.lastIndexOf(' '),
                                      widget.order!.orderItems[0].productId.price.branchPrice.length) : '') }'
                              ),
                              CustomItemWidget(
                                // startText: AppLocalization.of(context)?.translate('to_sum_it_up') ?? 'Под итог',
                                  startText: 'Остаток платежа',
                                  endText:
                                  '${isPayedPrePayment?moneyFormat(widget.order != null ? (remainingPayment1.round().toString()) : (remainingPayment2.round()).toString()): remainingPayment1}'
                                      '${(widget.order != null? widget.order!.orderItems[0].productId.price.branchPrice.
                                  substring(widget.order!.orderItems[0].productId.price.branchPrice.lastIndexOf(' '),
                                      widget.order!.orderItems[0].productId.price.branchPrice.length) : '') }'),

                              SizedBox(
                                height: 8,
                              ),
                              Divider(
                                height: 1,
                                color: Color.fromRGBO(171, 116, 64, 0.9),
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              InkWell(
                                onTap: () async {
                                  return showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      backgroundColor: ColorsResources.PRIMARY_BACKROUND_COLOR,
                                      title: Text(
                                        AppLocalization.of(context)?.translate('do_you_want_to_print') ?? "Хотите распечатать?",
                                        style: TextStyle(
                                          color: Color.fromRGBO(255, 255, 255, 0.9),
                                          fontFamily: 'Roboto',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          height: 15 / 13.4,
                                        ),
                                      ),
                                      content: Text(
                                        AppLocalization.of(context)?.translate('this_contract_is_ready_for_printing') ??
                                            "Этот договор готов к печатиx",
                                        style: TextStyle(
                                          color: Color.fromRGBO(
                                              255, 255, 255, 0.9),
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
                                            AppLocalization.of(context)
                                                ?.translate('no') ??
                                                "Нет",
                                            style: TextStyle(
                                              color: Color.fromRGBO(255, 255, 255, 0.9),
                                              fontFamily: 'Roboto',
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              height: 15 / 13.4,
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            final cacheManager = CacheManager();

                                            String userName = await cacheManager.getUserName() ?? 'MUSTAFA TULGAR';
                                            String userEmail = await cacheManager.getUserEmail() ?? 'woiss.uz@gmail.com';
                                            String branchPhone = await cacheManager.getBranchPhone() ?? '93 844 00 06';

                                            Navigator.of(ctx).pop();
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) => PdfPreviewPage(
                                                  invoice: Invoice(
                                                    id: widget.order?.orderItems[0].orderId ?? 0,
                                                    client: widget.clientModel,
                                                    supplier: SupplierModel(
                                                        supplierName: userName,
                                                        supplierEmail: userEmail,
                                                        supplierPhoneNumber: branchPhone
                                                    ),
                                                    order: widget.order,
                                                    orderItems:widget.order != null? widget.order?.orderItems??[] : widget.orderItems,
                                                    dateTime: DateTime.now(),
                                                    clientPayment: ClientPayment(prepaidAmount: prePayment1,remainingAmount: widget.order != null?remainingPayment1: remainingPayment2),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            AppLocalization.of(context)
                                                ?.translate('yes') ??
                                                "Да",
                                            style: TextStyle(
                                              color: Color.fromRGBO(255, 255, 255, 0.9),
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
                                child: Container(
                                  width: double.infinity,
                                  height: 54,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1,
                                        color: Color.fromRGBO(171, 116, 64, 0.9),
                                      )),
                                  child: Container(
                                    padding:
                                    EdgeInsets.symmetric(horizontal: 24),
                                    color:
                                    ColorsResources.PRIMARY_BACKROUND_COLOR,
                                    height: 54,
                                    child: Center(
                                      child: Text(
                                        AppLocalization.of(context)
                                            ?.translate('print_contract') ??
                                            'Распечатать договор',
                                        style: TextStyle(
                                          color: Color.fromRGBO(
                                              255, 255, 255, 0.9),
                                          fontFamily: 'Roboto',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          height: 16 / 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 48,
                              ),
                            ],
                          ),
                        ) ,
                      ),
                    ],
                  )
                );
              },
            ),
          );
        }),
      ),
    );
  }

  Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
    final path = (await getExternalStorageDirectory())?.path;
    final file = File('$path/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open('$path/$fileName');
  }
}
