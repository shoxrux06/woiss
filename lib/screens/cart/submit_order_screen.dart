import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:furniture_app/controller/client_controller.dart';
import 'package:furniture_app/controller/order_controller.dart';
import 'package:furniture_app/data/model/client_model.dart';
import 'package:furniture_app/data/model/response/my_order_item.dart';
import 'package:furniture_app/data/model/response/order_get_model.dart';
import 'package:furniture_app/data/model/response/order_get_model.dart';
import 'package:furniture_app/data/repository/client_repo.dart';
import 'package:furniture_app/providers/cart_provider.dart';
import 'package:furniture_app/providers/invoice_provider.dart';
import 'package:furniture_app/screens/account/contract_screen.dart';
import 'package:furniture_app/screens/cart/print_contract_screen.dart';
import 'package:furniture_app/screens/cart/submit_commercial_screen.dart';
import 'package:furniture_app/screens/custom_snackbar.dart';
import 'package:furniture_app/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../localization/app_localization.dart';
import '../../utils/cache_manager.dart';
import '../../utils/color_resources.dart';
import '../../utils/custom_themes.dart';

class SubmitOrderScreen extends StatefulWidget {

  const SubmitOrderScreen({Key? key,this.client}) : super(key: key);

  final Result? client;
  @override
  State<SubmitOrderScreen> createState() => _SubmitOrderScreenState();
}

class _SubmitOrderScreenState extends State<SubmitOrderScreen> {
  final controller = Get.put(ClientController(clientRepo: ClientRepo()));

  ClientModel? model;
  OrdersGetModel? ordersGetModel;
  Order? order;
  Result? clientModel;
  bool clientIsEdited = false;
  bool orderIsSubmitting = false;
  int? commercialOrderId;
  int? contractOrderId;
  bool isEditCommercial = false;
  bool isEditContract = false;

  late TextEditingController searchPhoneNumberController = TextEditingController(text: widget.client != null? '${widget.client?.phone}': '');
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController discountController = TextEditingController();

  String submittedVal = '';

  int invoiceNumber = 1;

  bool clientIsNo = false;

  int orderNumber = 1;
  String? stringOrderNumber = '001';

  void getOrderNumber() async{
    final _prefs = await SharedPreferences.getInstance();
    orderNumber = _prefs.getInt(AppConstants.ORDER_NUMBER) ?? 1;
    if(orderNumber.toString().length  == 1){
      stringOrderNumber = '00$orderNumber';
      print('stringOrderNumber*****$stringOrderNumber*****');
    }else if(orderNumber.toString().length  == 2){
      stringOrderNumber = '0$orderNumber';
      print('stringOrderNumber*****$stringOrderNumber*****');
    }else{
      stringOrderNumber = orderNumber.toString();
      print('stringOrderNumber*****$stringOrderNumber*****');
    }

  }

  @override
  void initState() {
    super.initState();
    getOrderNumber();
  }

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
    commercialOrderId = context.read<InvoiceProvider>().orderIdCommercial;
    contractOrderId = context.read<InvoiceProvider>().orderIdContract;
    isEditCommercial = context.read<InvoiceProvider>().isEditCommercial;
    isEditContract = context.read<InvoiceProvider>().isEditContract;

    print('COMMERCIAL ORDER ID PROVIDER ---> $commercialOrderId');
    print('CONTRACT ORDER ID PROVIDER ---> $contractOrderId');
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leadingWidth: screenWidth >= 600?250: 54,
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
      body: GetBuilder<ClientController>(builder: (controller) => Container(
        height: double.infinity,
        padding: screenWidth>= 600? EdgeInsets.only(left: 120, right: 120, top: 30,bottom: 50):EdgeInsets.all(20),
        color: ColorsResources.PRIMARY_BACKROUND_COLOR,
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalization.of(context)?.translate('client') ?? 'Клиент',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      height: 12 / 14,
                      color: Color.fromRGBO(255, 255, 255, 0.5),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: 52,
                    child: TextFormField(
                      style: titleRegular.copyWith(fontSize: 18),
                      controller: searchPhoneNumberController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
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
                          labelText: AppLocalization.of(context)
                              ?.translate('phone_number') ??
                              'Номер телефона',
                        labelStyle: titleRegular,
                        hintStyle: titleRegular,
                        suffix: IconButton(onPressed: (){
                            controller
                                .searchClientFromAPI(searchPhoneNumberController.text.trim())
                                .then((value) {
                              if (value == null) {
                                showCustomSnackBar(AppLocalization.of(context)?.translate('client_not_found')?? 'Клиент не найден');
                                setState(() {
                                  clientIsNo = true;
                                  fullNameController.text = '';
                                  phoneNumberController.text = '';
                                  addressController.text ='';
                                  discountController.text = '';
                                });
                              } else {
                                model = ClientModel.fromJson(value);
                                clientModel = model?.result;
                                setState((){});
                                fullNameController.text = model?.result.fullname ?? '';
                                phoneNumberController.text = model?.result.phone ??'';
                                addressController.text = model?.result.address ?? '';
                                discountController.text = model?.result.discount.toString() ??'';
                                clientIsEdited = false;
                                setState(() {
                                  clientIsNo = false;
                                });
                              }
                            });
                        }, icon: Icon(Icons.search, color: Colors.white70,))
                      ),
                    ),
                  ),
                  // customTextFormField(phoneNumberController, 'Номер телефона'),
                  SizedBox(
                    height: 12,
                  ),
                  SizedBox(height: 24,),
                  Text(
                    AppLocalization.of(context)?.translate('data') ??
                        'Данные',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      height: 12 / 14,
                      color: Color.fromRGBO(255, 255, 255, 0.5),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  customTextFormField(
                      fullNameController,
                      AppLocalization.of(context)?.translate('full_name') ??
                          'Ф.И.О'),
                  SizedBox(
                    height: 20,
                  ),
                  customTextFormField(
                      phoneNumberController,
                      AppLocalization.of(context)?.translate('number') ??
                          'Номер'),
                  SizedBox(
                    height: 20,
                  ),
                  customTextFormField(
                      addressController,
                      AppLocalization.of(context)?.translate('address') ??
                          'Адрес'),
                  SizedBox(
                    height: 20,
                  ),
                  customTextFormField(discountController, '${AppLocalization.of(context)?.translate('discount') ?? 'Скидка'} 10%'),
                  SizedBox(
                    height: 24,
                  ),
                  if(clientIsNo == true)Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () async {
                        await controller.addClient(
                          fullNameController.text,
                          phoneNumberController.text,
                          addressController.text,
                          discountController.text,
                        ).then((value) {
                          if(value != null){
                            showCustomSuccessSnackBar(AppLocalization.of(context)?.translate('client_added')??'Клиент добавлен');
                            model = ClientModel.fromJson(value);
                            clientModel = model?.result;
                            print('Client Add ---->$clientModel');
                          }
                        }
                        );
                      },
                      child: Text(
                        AppLocalization.of(context)?.translate('add_client')??'Add Client'
                      ),
                    ),
                  ),
                  if(clientIsNo == false)Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () async {
                        CacheManager cacheManager = CacheManager();
                        int? customerId = await cacheManager.getCustomerId();
                        await controller.editClient(
                          customerId??0,
                          fullNameController.text,
                          phoneNumberController.text,
                          addressController.text,
                          int.tryParse(discountController.text)?? 0
                        ).then((value) {
                          if(value != null){
                            showCustomSuccessSnackBar(AppLocalization.of(context)?.translate('client_changed_successfully')??'Клиент успешно изменен');
                            model = ClientModel.fromJson(value);
                            clientModel = model?.result;
                            clientIsEdited = true;
                            print('Client Edit ---->$clientModel');
                          }
                        }).catchError((error){
                          print('Error >>>>>>>>>>>>>>>>>>>$error');
                        });
                      },
                      child: Text(
                          '${AppLocalization.of(context)?.translate('edit_client')??'Edit Client'}'
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Spacer(),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(
                          height: 1,
                          color: Color.fromRGBO(171, 116, 64, 0.9),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          AppLocalization.of(context)?.translate('total') ?? 'Итого',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontFamily: 'Roboto',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                      cartProvider.totalPrice != 0?
                      '${moneyFormat(cartProvider.totalPrice.toInt().toString())}${cartProvider.cartList.isNotEmpty ?
                      cartProvider.cartList[0].product.branchPrice.substring(cartProvider.cartList[0].product.branchPrice.lastIndexOf(' '),cartProvider.cartList[0].product.branchPrice.length): ''}':
                          '0 ${cartProvider.cartList.isNotEmpty ?
                          cartProvider.cartList[0].product.branchPrice.substring(cartProvider.cartList[0].product.branchPrice.lastIndexOf(' '),cartProvider.cartList[0].product.branchPrice.length): ''}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontFamily: 'Roboto',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 21,
                        ),
                        InkWell(
                          onTap: orderIsSubmitting ? null:() async {
                            int? productId;
                            int? quantity;
                            String color = '';
                            String size = '';
                            List<MyOrderItem> orderItems = [];
                            for (int i = 0; i < cartProvider.cartList.length; i++) {
                              productId = cartProvider.cartList[i].product.id;
                              quantity = cartProvider.cartList[i].quantity.value;
                              color = cartProvider.cartList[i].product.color;
                              size = cartProvider.cartList[i].product.size;
                              orderItems.add(MyOrderItem(product_id: productId??0, quantity: quantity ?? 0, color: color, size: size)
                              );
                            }
                            CacheManager cacheManager = CacheManager();
                            int? userId = await cacheManager.getUserId();

                            int? customerId = await cacheManager.getCustomerId();
                            setState((){
                              orderIsSubmitting = true;
                            });
                            if(orderItems.isNotEmpty){
                              if(contractOrderId != null && isEditContract){
                                Get.find<OrderController>().editContract(orderId: contractOrderId, orderItems: orderItems).then((value) async{
                                  order = Order.fromJson(value['order']);
                                  print('clientModel||||||||||editContract>>>>>>>>>$clientModel');
                                  print('contractOrderId*****$contractOrderId******');
                                  print('contractOrderId*****$isEditContract******');

                                  if(order != null && clientModel != null){
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => PrintContractScreen(discount: order!.customer.discount, order: order, clientModel: clientModel, orderItems: order!.orderItems),
                                    ),);
                                    showCustomSuccessSnackBar(AppLocalization.of(context)?.translate('contract_is_edited')??'Contract is edited');
                                  }else{
                                    showCustomSnackBar(AppLocalization.of(context)?.translate('please_select_a_client')??'Iltimos client tanlang');
                                  }
                                  context.read<InvoiceProvider>().setContractEditOrNot(false);
                                  setState(() {
                                    orderIsSubmitting = false;
                                  });
                                });
                              }
                              else if(commercialOrderId != null && isEditCommercial) {
                                Get.find<OrderController>().editOrder(orderId: commercialOrderId, orderItems: orderItems).then((value) async{
                                  order = Order.fromJson(value['order']);
                                  print('clientModel||||||||||editOrder>>>>>>>>>$clientModel');
                                  print('order|||||||||editOrder>>>>>>>>>$order');
                                  if(clientModel != null && order != null){
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => SubmitCommercialScreen(orderId: order?.id, clientModel: clientModel,order: order,),
                                    ),);
                                    showCustomSuccessSnackBar(AppLocalization.of(context)?.translate('commercial_is_edited')??'Commercial is edited');
                                  }else{
                                    showCustomSnackBar(AppLocalization.of(context)?.translate('please_select_a_client')??'Iltimos client tanlang');
                                  }
                                  context.read<InvoiceProvider>().setCommercialEditOrNot(false);
                                  setState(() {
                                    orderIsSubmitting = false;
                                  });
                                });
                              }
                              else {
                                Get.find<OrderController>().postOrder(
                                  userId: userId.toString(),
                                  orderNumber: stringOrderNumber??'001',
                                  customerId: customerId.toString(),
                                  totalAmount: cartProvider.totalPrice.toString(),
                                  orderItem: orderItems,
                                ).then((value) async{
                                  final _prefs = await SharedPreferences.getInstance();
                                  orderNumber = orderNumber + 1;
                                  _prefs.setInt(AppConstants.ORDER_NUMBER, orderNumber);

                                  print('POST COMMERCIAL RESPONSE **** $value');
                                  setState(() {
                                    orderIsSubmitting = false;
                                  });
                                  order = Order.fromJson(value['order']);
                                  commercialOrderId = order?.id;
                                  print('clientModel||||||||||postOrder>>>>>>>>>$clientModel');
                                  print('order|||||||||postOrder>>>>>>>>>$order');
                                  if(clientModel != null && order != null) {
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => SubmitCommercialScreen(orderId: order?.id, clientModel: clientModel,order: order,),
                                    ),);
                                  } else{
                                    showCustomSnackBar(AppLocalization.of(context)?.translate('please_select_a_client')??'Iltimos client tanlang');
                                  }
                                  print('post Order reached here');
                                });
                              }
                            }
                            else{
                              showCustomSnackBar(AppLocalization.of(context)?.translate('please_select_a_product')?? 'Please select a product');
                              setState((){
                                orderIsSubmitting = false;
                              });

                            }
                          },
                          child:(context.read<InvoiceProvider>().isEditCommercial && commercialOrderId != null)? Container(
                            width: double.infinity,
                            height: 54,
                            color: orderIsSubmitting ? Colors.grey: Color.fromRGBO(171, 116, 64, 0.9),
                            child: Center(
                              child: orderIsSubmitting? CircularProgressIndicator() : Text(AppLocalization.of(context)?.translate('edit_commercial')??'Edit Commercial'),
                            ),
                          ):((context.read<InvoiceProvider>().isEditContract && contractOrderId != null))?Container(
                            width: double.infinity,
                            height: 54,
                            color: orderIsSubmitting ? Colors.grey: Color.fromRGBO(171, 116, 64, 0.9),
                            child: Center(
                              child: orderIsSubmitting? CircularProgressIndicator() : Text(AppLocalization.of(context)?.translate('edit_contract')??'Edit Contract'),
                            ),
                          ) : Container(
                            width: double.infinity,
                            height: 54,
                            color: orderIsSubmitting ? Colors.grey: Color.fromRGBO(171, 116, 64, 0.9),
                            child: Center(
                              child: orderIsSubmitting? Center(child: CircularProgressIndicator(),): Text((AppLocalization.of(context)?.translate('place_an_order') ??
                                  'Разместить заказ')),
                            ),
                          ),
                        ),
                        SizedBox(height: 32,)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),)
    );
  }

  Widget customTextFormField(
      TextEditingController controller, String labelText) {
    return Container(
      height: 52,
      child: TextFormField(
        style: titleRegular.copyWith(fontSize: 18),
        controller: controller,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
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
          labelText: '$labelText',
          labelStyle: titleRegular,
          hintStyle: titleRegular,
        ),
      ),
    );
  }
}
