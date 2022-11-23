import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:furniture_app/data/cart.dart';
import 'package:furniture_app/data/model/client_model.dart';
import 'package:furniture_app/data/model/response/custom_product_model.dart';
import 'package:furniture_app/data/model/response/order_get_model.dart';
import 'package:furniture_app/screens/cart/cart_screen.dart';
import 'package:furniture_app/screens/cart/oder_item_widget.dart';
import 'package:furniture_app/screens/cart/print_contract_screen.dart';
import 'package:furniture_app/screens/pdf/pdf_review.dart';
import 'package:furniture_app/utils/app_constants.dart';
import 'package:furniture_app/utils/color_resources.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/order_controller.dart';
import '../../data/model/invoice.dart';
import '../../data/model/response/my_order_item.dart';
import '../../data/model/supplier_model.dart';
import '../../localization/app_localization.dart';
import '../../providers/cart_provider.dart';
import '../../providers/invoice_provider.dart';
import '../../utils/cache_manager.dart';
import '../custom_snackbar.dart';
import 'custom_item_widget.dart';

class PrintCommercialScreen extends StatefulWidget {
  const PrintCommercialScreen({
    Key? key,
    required this.discount,
    required this.clientModel,
    required this.order,
    this.amount = 0,
    this.orderId,
    required this.orderItems,
  }) : super(key: key);
  final int discount;
  final int amount;
  final int? orderId;
  final Result? clientModel;
  final Order? order;
  final List<OrderItem> orderItems;

  @override
  State<PrintCommercialScreen> createState() => _PrintCommercialScreenState();
}

class _PrintCommercialScreenState extends State<PrintCommercialScreen> {
  Order? order;
  List<OrderItem> myOrderItems = [];

  List<MyOrderItem> orderItems = [];

  List<Cart> cartItems = [];

  int totalPrice = 0;

  int productId = 0;
  int quantity = 0;
  String color = '';
  String size = '';

  final globalKey = GlobalKey();

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
    super.initState();
    getContractNumber();
  }

  int contractNumber = 1;
  String? stringContractNumber = '001';
  double paddingValue = 0.0;

  void getContractNumber() async{
    final _prefs = await SharedPreferences.getInstance();
    contractNumber = _prefs.getInt(AppConstants.CONTRACT_NUMBER) ?? 1;
    if(contractNumber.toString().length  == 1){
      stringContractNumber = '00$contractNumber';
      print('stringContractNumber*****$stringContractNumber*****');
    }else if(contractNumber.toString().length  == 2){
      stringContractNumber = '0$contractNumber';
      print('stringContractNumber*****$stringContractNumber*****');
    }else{
      stringContractNumber = contractNumber.toString();
      print('stringContractNumber*****$stringContractNumber*****');
    }

  }

  int totalSum = 0;
  int editedTotalSum = 0;

  @override
  Widget build(BuildContext context) {
    myOrderItems = widget.orderItems;

    final screenWidth = MediaQuery.of(context).size.width;


    if(screenWidth >= 600 && screenWidth <= 700){
      paddingValue = 20.0;
    }else if(screenWidth > 700){
      paddingValue = 50.0;
    }else{
      paddingValue = 20.0;
    }

    totalPrice = myOrderItems
        .map((e) => e.quantity * e.productId.price.intBranchPrice)
        .reduce((value, element) => value + element);

    for (int i = 0; i < myOrderItems.length; i++) {
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
            branchPrice:  myOrderItems[i].productId.price.branchPrice,
            intBranchPrice: myOrderItems[i].productId.price.intBranchPrice,
            img: myOrderItems[i].productId.img,
            color: myOrderItems[i].color,
            size: myOrderItems[i].size,
            categoryName: myOrderItems[i].productId.categoryId.name,
          ),
          quantity: ValueNotifier(
            myOrderItems[i].quantity,
          ),
        ),
      );

      productId = myOrderItems[i].productId.id;
      color = myOrderItems[i].color;
      size = myOrderItems[i].size;
      quantity = myOrderItems[i].quantity;

      orderItems.add(MyOrderItem(product_id: productId, quantity: quantity, color: color, size: size));
    }
    if (widget.order != null) {
      for (int i = 0; i < widget.order!.orderItems.length; i++) {
        totalSum +=
            (widget.order!.orderItems[i].productId.price.intBranchPrice *
                widget.order!.orderItems[i].quantity);
      }
    } else {
      for (int i = 0; i < widget.orderItems.length; i++) {
        editedTotalSum += (widget.orderItems[i].productId.price.intBranchPrice *
            widget.orderItems[i].quantity);
      }
    }

    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    print('ORDER ID---> ${widget.orderId}');
    print(''
        'ORDER----------------> ${widget.order}');
    print('AMOUNT----------------> ${widget.amount}');
    return WillPopScope(
      onWillPop: () async {
        context.read<CartProvider>().clearCart();
        context.read<CartProvider>().clearTotalPrice();
        context.read<CartProvider>().updateProductCounter();
        return true;
      },
      child: Scaffold(
        key: globalKey,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(
            widget.order != null
                ? 'INV-${widget.order?.orderNumber}'
                : 'INV-${widget.orderId}',
            style: TextStyle(
              color: Colors.white,
              // fontFamily: 'Cormorant',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 14 / 16,
            ),
          ),
          leadingWidth: screenWidth >= 600? 120: 54,
          leading: Container(
            child: IconButton(
              onPressed: () {
                cartProvider.clearCart();
                cartProvider.clearTotalPrice();
                cartProvider.updateProductCounter();
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
            InkWell(
              onTap: () {
                context.read<CartProvider>().setItemsToCart(cartItems);
                context.read<CartProvider>().updateTotalPrice(totalPrice);
                context.read<InvoiceProvider>().setCommercialEditOrNot(true);
                if (widget.order != null) {
                  context.read<InvoiceProvider>().setCommercialOrderId(widget.order?.id??0);
                } else {
                  context.read<InvoiceProvider>().setCommercialOrderId(widget.orderId ?? 0);
                }
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => CartScreen(client: widget.clientModel,)),
                  (route) => false,
                );
              },
              child: Container(
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
            SizedBox(width: screenWidth >= 600 ? 32:8),
          ],
        ),
        body: Consumer<CartProvider>(
          builder: ((context, cart, child) {
            return Container(
              color: ColorsResources.PRIMARY_BACKROUND_COLOR,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
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
                              childCount: widget.orderItems.length),
                        )
                            : SliverList(
                          delegate: SliverChildBuilderDelegate(
                                  (context, index) => OrderItemWidget(index: index,orderItem: widget.orderItems[index]),
                              childCount: widget.orderItems.length
                          ),
                        ),
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child:screenWidth >=600?Container(
                            padding:EdgeInsets.only(left: paddingValue, right: paddingValue, bottom: paddingValue),
                            child: Column(
                              children: [
                                Spacer(),
                                Row(
                                  children: [
                                    Expanded(child: CustomItemWidget(
                                        startText: AppLocalization.of(context)
                                            ?.translate('price') ??
                                            'Цена',
                                        endText:
                                        '${moneyFormat(widget.order != null ? (totalSum.toString()) : (editedTotalSum.toString()))} '
                                            '${(widget.order != null? widget.order!.orderItems[0].productId.price.branchPrice.
                                        substring(widget.order!.orderItems[0].productId.price.branchPrice.lastIndexOf(' '),
                                            widget.order!.orderItems[0].productId.price.branchPrice.length) : '') }'),),
                                    SizedBox(width: 24,),
                                    Expanded(child: CustomItemWidget(
                                        startText: AppLocalization.of(context)
                                            ?.translate('to_sum_it_up') ??
                                            'Под итог',
                                        endText:
                                        '${moneyFormat(widget.order != null ? ((totalSum - totalSum * (widget.discount / 100)).toInt().toString()) : ((editedTotalSum - (editedTotalSum * (widget.discount / 100))).toInt()).toString())}'
                                            '${(widget.order != null? widget.order!.orderItems[0].productId.price.branchPrice.
                                        substring(widget.order!.orderItems[0].productId.price.branchPrice.lastIndexOf(' '),
                                            widget.order!.orderItems[0].productId.price.branchPrice.length) : '') }'),),
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
                                      children: [
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
                                              AppLocalization.of(context)
                                                  ?.translate('total') ??
                                                  'Итог',
                                              style: TextStyle(
                                                color:
                                                Color.fromRGBO(255, 255, 255, 0.9),
                                                fontFamily: 'Roboto',
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                height: 16 / 14,
                                              ),
                                            ),
                                            Text(
                                              '${moneyFormat(widget.order != null ? ((totalSum - totalSum * (widget.discount / 100)).toInt().toString()) :
                                              ((editedTotalSum - (editedTotalSum * (widget.discount / 100))).toInt()).toString())}'
                                                  '${(widget.order != null? widget.order!.orderItems[0].productId.price.branchPrice.
                                              substring(widget.order!.orderItems[0].productId.price.branchPrice.lastIndexOf(' '),
                                                  widget.order!.orderItems[0].productId.price.branchPrice.length) : '') }',
                                              style: TextStyle(
                                                color:
                                                Color.fromRGBO(255, 255, 255, 0.8),
                                                fontFamily: 'Roboto',
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                height: 19 / 16,
                                              ),
                                            ),
                                          ],
                                        ),

                                      ],
                                    )),
                                  ],
                                ),
                                SizedBox(
                                  height: 24,
                                ),
                                InkWell(
                                  child: Container(
                                    width: double.infinity,
                                    height: 54,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: InkWell(
                                            onTap: () async {
                                              return showDialog(
                                                context: context,
                                                builder: (ctx) => AlertDialog(
                                                  backgroundColor: ColorsResources
                                                      .PRIMARY_BACKROUND_COLOR,
                                                  title: Text(
                                                    AppLocalization.of(context)
                                                        ?.translate(
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
                                                    AppLocalization.of(context)
                                                        ?.translate(
                                                        'this_contract_is_ready_for_printing') ??
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
                                                        AppLocalization.of(
                                                            context)
                                                            ?.translate(
                                                            'no') ??
                                                            "Нет",
                                                        style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              255, 255, 255, 0.9),
                                                          fontFamily: 'Roboto',
                                                          fontSize: 13,
                                                          fontWeight:
                                                          FontWeight.w500,
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
                                                                  supplierPhoneNumber: branchPhone,
                                                                ),
                                                                order: widget.order,
                                                                orderItems: order == null? widget.orderItems : order!.orderItems,
                                                                dateTime: DateTime.now(),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: Text(
                                                        AppLocalization.of(
                                                            context)
                                                            ?.translate(
                                                            'yes') ??
                                                            "Да",
                                                        style: const TextStyle(
                                                          color: Color.fromRGBO(
                                                              255, 255, 255, 0.9),
                                                          fontFamily: 'Roboto',
                                                          fontSize: 13,
                                                          fontWeight:
                                                          FontWeight.w500,
                                                          height: 15 / 13.4,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  width: 1,
                                                  color: Color.fromRGBO(171, 116, 64, 0.9),
                                                ),
                                                color: ColorsResources.PRIMARY_BACKROUND_COLOR,
                                              ),
                                              padding: const EdgeInsets.symmetric(horizontal: 24),
                                              height: 54,
                                              child: Center(
                                                child: Text(
                                                  AppLocalization.of(context)
                                                      ?.translate('print') ??
                                                      'Распечатать',
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
                                        SizedBox(width: 24,),
                                        Expanded(
                                          flex: 1,
                                          child: InkWell(
                                            onTap: () async {
                                              CacheManager cacheManager = CacheManager();
                                              int? userId = await cacheManager.getUserId();
                                              int? customerId = await cacheManager.getCustomerId();
                                              Get.find<OrderController>().postContract(
                                                userId: userId.toString(),
                                                contractNumber: stringContractNumber?? '001',
                                                customerId: customerId.toString(),
                                                totalAmount: cartProvider.totalPrice.toString(),
                                                orderItem: orderItems,
                                              ).then((value) async{
                                                final _prefs = await SharedPreferences.getInstance();
                                                contractNumber = contractNumber + 1;
                                                _prefs.setInt(AppConstants.CONTRACT_NUMBER, contractNumber);

                                                print('POST CONTRACT RESPONSE ****$value');
                                                order = Order.fromJson(value['order']);
                                                print('Order>>>>>>>>>>>>> $order');
                                                if (order != null) {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          PrintContractScreen(
                                                              discount: widget.discount,
                                                              order: order,
                                                              clientModel: widget.clientModel,
                                                              orderItems: order?.orderItems ?? []
                                                          ),
                                                    ),
                                                  );
                                                } else {
                                                  showCustomSnackBar(AppLocalization
                                                      .of(context)
                                                      ?.translate(
                                                      'please_select_a_client') ??
                                                      'Iltimos client tanlang');
                                                }
                                                print(
                                                    'Order>>>>>>>>>>>>> ${widget.order}');
                                                print(
                                                    'post Order reached here');
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  width: 1,
                                                  color: Color.fromRGBO(171, 116, 64, 0.9),
                                                ),
                                                color: Color.fromRGBO(171, 116, 64, 0.9),
                                              ),
                                              padding: EdgeInsets.symmetric(horizontal: 24),
                                              height: 54,
                                              child: Center(
                                                child: Text(
                                                  AppLocalization.of(context)
                                                      ?.translate(
                                                      'go_to_contract') ??
                                                      'Перейти к договору',
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, 0.9),
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
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 24,
                                ),
                              ],
                            ),
                          ) :
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              // vertical: 40,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                CustomItemWidget(
                                    startText: AppLocalization.of(context)
                                        ?.translate('price') ??
                                        'Цена',
                                    endText:
                                    '${moneyFormat(widget.order != null ? (totalSum.toString()) : (editedTotalSum.toString()))}'
                                        '${(widget.order != null? widget.order!.orderItems[0].productId.price.branchPrice.
                                substring(widget.order!.orderItems[0].productId.price.branchPrice.lastIndexOf(' '),
                                widget.order!.orderItems[0].productId.price.branchPrice.length) : '') }'),
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
                                    '${moneyFormat(widget.order != null ? ((totalSum - totalSum * (widget.discount / 100)).toInt().toString()) : ((editedTotalSum - (editedTotalSum * (widget.discount / 100))).toInt()).toString())}'
                                        '${(widget.order != null? widget.order!.orderItems[0].productId.price.branchPrice.
                                    substring(widget.order!.orderItems[0].productId.price.branchPrice.lastIndexOf(' '),
                                        widget.order!.orderItems[0].productId.price.branchPrice.length) : '') }'),
                                SizedBox(
                                  height: 24,
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      AppLocalization.of(context)
                                          ?.translate('total') ??
                                          'Итог',
                                      style: TextStyle(
                                        color:
                                        Color.fromRGBO(255, 255, 255, 0.9),
                                        fontFamily: 'Roboto',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        height: 16 / 14,
                                      ),
                                    ),
                                    Text(
                                      '${moneyFormat(widget.order != null ? ((totalSum - totalSum * (widget.discount / 100)).toInt().toString()) :
                                      ((editedTotalSum - (editedTotalSum * (widget.discount / 100))).toInt()).toString())}'
                                          '${(widget.order != null? widget.order!.orderItems[0].productId.price.branchPrice.
                                      substring(widget.order!.orderItems[0].productId.price.branchPrice.lastIndexOf(' '),
                                          widget.order!.orderItems[0].productId.price.branchPrice.length) : '') }',
                                      style: TextStyle(
                                        color:
                                        Color.fromRGBO(255, 255, 255, 0.8),
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
                                SizedBox(
                                  height: 24,
                                ),
                                // widget.order != null?
                                InkWell(
                                  child: Container(
                                    width: double.infinity,
                                    height: 54,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1,
                                          color: Color.fromRGBO(171, 116, 64, 0.9),
                                        )),
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            return showDialog(
                                              context: context,
                                              builder: (ctx) => AlertDialog(
                                                backgroundColor: ColorsResources
                                                    .PRIMARY_BACKROUND_COLOR,
                                                title: Text(
                                                  AppLocalization.of(context)
                                                      ?.translate(
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
                                                  AppLocalization.of(context)
                                                      ?.translate(
                                                      'this_contract_is_ready_for_printing') ??
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
                                                      AppLocalization.of(
                                                          context)
                                                          ?.translate(
                                                          'no') ??
                                                          "Нет",
                                                      style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            255, 255, 255, 0.9),
                                                        fontFamily: 'Roboto',
                                                        fontSize: 13,
                                                        fontWeight:
                                                        FontWeight.w500,
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
                                                                supplierPhoneNumber: branchPhone,
                                                              ),
                                                              order: widget.order,
                                                              orderItems: order == null? widget.orderItems : order!.orderItems,
                                                              dateTime: DateTime.now(),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Text(
                                                      AppLocalization.of(
                                                          context)
                                                          ?.translate(
                                                          'yes') ??
                                                          "Да",
                                                      style: const TextStyle(
                                                        color: Color.fromRGBO(
                                                            255, 255, 255, 0.9),
                                                        fontFamily: 'Roboto',
                                                        fontSize: 13,
                                                        fontWeight:
                                                        FontWeight.w500,
                                                        height: 15 / 13.4,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 24),
                                            color: ColorsResources
                                                .PRIMARY_BACKROUND_COLOR,
                                            height: 54,
                                            child: Center(
                                              child: Text(
                                                AppLocalization.of(context)
                                                    ?.translate('print') ??
                                                    'Распечатать',
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
                                        Expanded(
                                          child: InkWell(
                                            onTap: () async {
                                              CacheManager cacheManager = CacheManager();
                                              int? userId = await cacheManager.getUserId();
                                              int? customerId = await cacheManager.getCustomerId();
                                              Get.find<OrderController>().postContract(
                                                userId: userId.toString(),
                                                contractNumber: stringContractNumber?? '001',
                                                customerId: customerId.toString(),
                                                totalAmount: cartProvider.totalPrice.toString(),
                                                orderItem: orderItems,
                                              ).then((value) async{
                                                final _prefs = await SharedPreferences.getInstance();
                                                contractNumber = contractNumber + 1;
                                                _prefs.setInt(AppConstants.CONTRACT_NUMBER, contractNumber);

                                                print('POST CONTRACT RESPONSE ****$value');
                                                order = Order.fromJson(value['order']);
                                                print('Order>>>>>>>>>>>>> $order');
                                                if (order != null) {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          PrintContractScreen(
                                                              discount: widget.discount,
                                                              order: order,
                                                              clientModel: widget.clientModel,
                                                              orderItems: order?.orderItems ?? []
                                                          ),
                                                    ),
                                                  );
                                                } else {
                                                  showCustomSnackBar(AppLocalization
                                                      .of(context)
                                                      ?.translate(
                                                      'please_select_a_client') ??
                                                      'Iltimos client tanlang');
                                                }
                                                print(
                                                    'Order>>>>>>>>>>>>> ${widget.order}');
                                                print(
                                                    'post Order reached here');
                                              });
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 24),
                                              height: 54,
                                              color: Color.fromRGBO(
                                                  171, 116, 64, 0.9),
                                              child: Center(
                                                child: Text(
                                                  AppLocalization.of(context)
                                                      ?.translate(
                                                      'go_to_contract') ??
                                                      'Перейти к договору',
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, 0.9),
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
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 48,
                                ),
                              ],
                            ),
                          ),

                        )
                      ],
                    ),
                  );
                },
              ),
            );
          }),
        ),
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
