import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:furniture_app/data/model/client_model.dart';
import 'package:furniture_app/data/model/response/order_get_model.dart';
import 'package:furniture_app/data/repository/invoice_repo.dart';
import 'package:furniture_app/screens/cart/print_commercial_screen.dart';
import 'package:furniture_app/utils/cache_manager.dart';
import 'package:furniture_app/utils/size_config.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../localization/app_localization.dart';
import '../../providers/invoice_provider.dart';
import '../../providers/invoice_provider.dart';
import '../../utils/color_resources.dart';

class CommercialScreen extends StatefulWidget {
  const CommercialScreen({Key? key}) : super(key: key);

  @override
  State<CommercialScreen> createState() => _CommercialScreenState();
}

class _CommercialScreenState extends State<CommercialScreen> {
  var format = DateFormat('dd.MM.yyyy');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAndConvertCommercials();
  }

  Future<void> getAndConvertCommercials() async {
    final cacheManager = CacheManager();
    int userId = await cacheManager.getUserId() ?? 0;
    await context.read<InvoiceProvider>().getCommercials(userId);
  }

  String? moneyFormat(String price) {
    if (price.length > 2) {
      var value = price;
      value = value.replaceAll(RegExp(r'\D'), '');
      value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ' ');
      return value;
    }
  }

  String valyutaName = 'sum';

  double paddingValue = 0.0;
  @override
  Widget build(BuildContext context) {
    final screenWidth=MediaQuery.of(context).size.width;

    SizeConfig().init(context);
    // bool isLandScape = SizeConfig().isLandScape(context);

    final isLandScape = MediaQuery.of(context).orientation == Orientation.landscape;

    if(screenWidth >= 600 && screenWidth <= 700){
      paddingValue = 20.0;
    }else if(screenWidth > 700){
      paddingValue = 50.0;
    }else{
      paddingValue = 20.0;
    }
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leadingWidth: screenWidth >= 600? 120: 54,
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
        body: Consumer<InvoiceProvider>(
            builder: (context, invoiceProvider, child) {
              if(invoiceProvider.commercialList.isNotEmpty &&invoiceProvider.commercialList[0].orderItems.isNotEmpty){
                valyutaName = invoiceProvider.commercialList[0].orderItems[0].productId.price.branchPrice.substring(invoiceProvider.commercialList[0].orderItems[0].productId.price.branchPrice.lastIndexOf(' ',invoiceProvider.commercialList[0].orderItems[0].productId.price.branchPrice.length));
              }

          return invoiceProvider.isLoadingCommercial
              ? Container(
                  color: ColorsResources.PRIMARY_BACKROUND_COLOR,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ))
              : Container(
                  color: ColorsResources.PRIMARY_BACKROUND_COLOR,
                  padding: EdgeInsets.all(paddingValue),
                  child: invoiceProvider.commercialList.isNotEmpty
                      ? CustomScrollView(
                    slivers: [
                      screenWidth>=600?SliverGrid(
                        gridDelegate:
                        SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: screenWidth / 2,
                          mainAxisSpacing: 10.0,
                          crossAxisSpacing: 10.0,
                          childAspectRatio: (isLandScape)? SizeConfig.aspectRatio * 18 / 12: SizeConfig.aspectRatio * 5/2,
                        ),
                        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                          return InkWell(
                            onTap: () async{
                              if (invoiceProvider.commercialList[index].orderItems.isNotEmpty) {
                                invoiceProvider.setCommercialOrderId(invoiceProvider.commercialList[index].id);
                                invoiceProvider.setCommercialEditOrNot(true);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => PrintCommercialScreen(
                                      discount: invoiceProvider.commercialList[index].customer.discount,
                                      clientModel: Result(
                                        phone: invoiceProvider.commercialList[index].customer.phone,
                                        fullname: invoiceProvider.commercialList[index].customer.fullname,
                                        address: invoiceProvider.commercialList[index].customer.address,
                                        discount: invoiceProvider.commercialList[index].customer.discount,
                                        id: invoiceProvider.commercialList[index].customer.id,
                                      ),
                                      order: invoiceProvider.commercialList[index],
                                      amount: invoiceProvider.commercialList[index].amount,
                                      orderId: invoiceProvider.orderIdCommercial,
                                      orderItems: invoiceProvider.commercialList[index].orderItems,
                                    )));
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 30),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: Color.fromRGBO(171, 116, 64, 0.9),
                                  ),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'INV-${invoiceProvider.commercialList[index].orderNumber}',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      height: 12 / 14,
                                      color:
                                      Color.fromRGBO(255, 255, 255, 0.9),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Divider(
                                    height: 1,
                                    color: Color.fromRGBO(171, 116, 64, 0.9),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    '${invoiceProvider.commercialList[index].customer.fullname}',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      height: 12 / 14,
                                      color:
                                      Color.fromRGBO(255, 255, 255, 0.9),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Divider(
                                    height: 1,
                                    color: Color.fromRGBO(171, 116, 64, 0.9),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    invoiceProvider.commercialList[index].orderItems.isNotEmpty
                                        ? '${moneyFormat((invoiceProvider.commercialList[index].orderItems.map((e) => e.quantity * e.iodp.round()).reduce((value, element) => value + element)).toString())}$valyutaName'
                                        : '0 $valyutaName',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      height: 12 / 14,
                                      color:
                                      Color.fromRGBO(255, 255, 255, 0.9),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Divider(
                                    height: 1,
                                    color: Color.fromRGBO(171, 116, 64, 0.9),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    '${format.format(invoiceProvider.commercialList[index].date)}',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                      height: 10 / 12,
                                      color:
                                      Color.fromRGBO(255, 255, 255, 0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                            childCount: invoiceProvider.commercialList.length,),
                      )
                          : SliverList(
                        delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  return InkWell(
                                    onTap: () async{
                                      if (invoiceProvider.commercialList[index].orderItems.isNotEmpty) {
                                        invoiceProvider.setCommercialOrderId(invoiceProvider.commercialList[index].id);
                                        invoiceProvider.setCommercialEditOrNot(true);
                                        Navigator.of(context).push(MaterialPageRoute(
                                            builder: (_) => PrintCommercialScreen(
                                              discount: invoiceProvider.commercialList[index].customer.discount,
                                              clientModel: Result(
                                                phone: invoiceProvider.commercialList[index].customer.phone,
                                                fullname: invoiceProvider.commercialList[index].customer.fullname,
                                                address: invoiceProvider.commercialList[index].customer.address,
                                                discount: invoiceProvider.commercialList[index].customer.discount,
                                                id: invoiceProvider.commercialList[index].customer.id,
                                              ),
                                              order: invoiceProvider.commercialList[index],
                                              amount: invoiceProvider.commercialList[index].amount,
                                              orderId: invoiceProvider.orderIdCommercial,
                                              orderItems: invoiceProvider.commercialList[index].orderItems,
                                            )));
                                      }
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 30),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 12),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 1,
                                            color: Color.fromRGBO(171, 116, 64, 0.9),
                                          ),
                                          borderRadius: BorderRadius.circular(5)),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'INV-${invoiceProvider.commercialList[index].orderNumber}',
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              height: 12 / 14,
                                              color:
                                              Color.fromRGBO(255, 255, 255, 0.9),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Divider(
                                            height: 1,
                                            color: Color.fromRGBO(171, 116, 64, 0.9),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            '${invoiceProvider.commercialList[index].customer.fullname}',
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              height: 12 / 14,
                                              color:
                                              Color.fromRGBO(255, 255, 255, 0.9),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Divider(
                                            height: 1,
                                            color: Color.fromRGBO(171, 116, 64, 0.9),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            invoiceProvider.commercialList[index].orderItems.isNotEmpty
                                                ? '${moneyFormat((invoiceProvider.commercialList[index].orderItems.map((e) => e.quantity * e.iodp.round()).reduce((value, element) => value + element)).toString())}$valyutaName'
                                                : '0 $valyutaName',
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              height: 12 / 14,
                                              color:
                                              Color.fromRGBO(255, 255, 255, 0.9),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Divider(
                                            height: 1,
                                            color: Color.fromRGBO(171, 116, 64, 0.9),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            '${format.format(invoiceProvider.commercialList[index].date)}',
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 10,
                                              fontWeight: FontWeight.w400,
                                              height: 10 / 12,
                                              color:
                                              Color.fromRGBO(255, 255, 255, 0.5),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                            childCount: invoiceProvider.commercialList.length,
                        ),
                      ),
                    ],
                  ) : Container(
                          color: ColorsResources.PRIMARY_BACKROUND_COLOR,
                          child: Center(
                            child: Text(
                              AppLocalization.of(context)?.translate('you_dont_have_any_commercials_yet')??'You don\'t have any commercials yet',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                );
        }));
  }
}
