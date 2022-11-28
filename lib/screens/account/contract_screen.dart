import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:furniture_app/data/model/response/order_get_model.dart';
// import 'package:furniture_app/data/model/response/order_model.dart';
import 'package:furniture_app/data/repository/invoice_repo.dart';
import 'package:furniture_app/screens/cart/print_contract_screen.dart';
import 'package:provider/provider.dart';

import '../../data/model/client_model.dart';
import '../../localization/app_localization.dart';
import '../../providers/invoice_provider.dart';
import '../../utils/cache_manager.dart';
import '../../utils/color_resources.dart';

class ContractScreen extends StatefulWidget {
  const ContractScreen({Key? key}) : super(key: key);

  @override
  State<ContractScreen> createState() => _ContractScreenState();
}

class _ContractScreenState extends State<ContractScreen> {

  var format = DateFormat('dd.MM.yyyy');

  final provider = InvoiceProvider(invoiceRepo: InvoiceRepo());

  bool isLoading= false;

  List<Order> contractList = [];

  @override
  void initState() {
    super.initState();
    getAndConvertContracts();
  }

  void getAndConvertContracts() async {
    final cacheManager = CacheManager();
    int userId = await cacheManager.getUserId() ?? 0;
    await context.read<InvoiceProvider>().getContracts(userId);
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
  String valyutaName = 'sum';

  @override
  Widget build(BuildContext context) {
    final screenWidth=MediaQuery.of(context).size.width;
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
          leadingWidth: screenWidth >= 600?120:54,
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
        body: Consumer<InvoiceProvider>(builder: (context,invoiceProvider, child) {
          if(invoiceProvider.commercialList.isNotEmpty &&invoiceProvider.commercialList[0].orderItems.isNotEmpty){
            valyutaName = invoiceProvider.commercialList[0].orderItems[0].productId.price.branchPrice.substring(invoiceProvider.commercialList[0].orderItems[0].productId.price.branchPrice.lastIndexOf(' ',invoiceProvider.commercialList[0].orderItems[0].productId.price.branchPrice.length));
          }
          return invoiceProvider.isLoadingContract ? Container(
            color: ColorsResources.PRIMARY_BACKROUND_COLOR,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ) : Container(
            child: Container(
                child: invoiceProvider.contractList.isNotEmpty? Container(
                  padding: EdgeInsets.all(paddingValue),
                  color: ColorsResources.PRIMARY_BACKROUND_COLOR,
                  child: CustomScrollView(
                    slivers: [
                      screenWidth >= 600? SliverGrid(
                          gridDelegate:
                          SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: screenWidth / 2,
                            mainAxisSpacing: 10.0,
                            crossAxisSpacing: 10.0,
                            childAspectRatio: (screenWidth>=600 && screenWidth <= 700)?1.6: 2.0,
                          ),
                          delegate:SliverChildBuilderDelegate((context,index){
                            return InkWell(
                              onTap: () async{
                                if (invoiceProvider.contractList[index].orderItems.isNotEmpty) {
                                  invoiceProvider.setContractOrderId(invoiceProvider.contractList[index].id);
                                  invoiceProvider.setContractEditOrNot(true);
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => PrintContractScreen(
                                        discount: invoiceProvider.contractList[index].customer.discount,
                                        clientModel: Result(
                                          phone: invoiceProvider.contractList[index].customer.phone,
                                          fullname: invoiceProvider.contractList[index].customer.fullname,
                                          address: invoiceProvider.contractList[index].customer.address,
                                          discount: invoiceProvider.contractList[index].customer.discount,
                                          id: invoiceProvider.contractList[index].customer.id,
                                        ),
                                        order: invoiceProvider.contractList[index],
                                        amount: invoiceProvider.contractList[index].amount,
                                        orderId: invoiceProvider.orderIdContract,
                                        orderItems: invoiceProvider.contractList[index].orderItems,
                                      )));
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 30),
                                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: Color.fromRGBO(171, 116, 64, 0.9),
                                    ),
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'WOISS-${invoiceProvider.contractList[index].orderNumber}',
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        height: 12 / 14,
                                        color: Color.fromRGBO(255, 255, 255, 0.9),
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
                                      invoiceProvider.contractList[index].customer.fullname,
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        height: 12 / 14,
                                        color: Color.fromRGBO(255, 255, 255, 0.9),
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
                                      invoiceProvider.contractList[index].orderItems.isNotEmpty? '${moneyFormat(invoiceProvider.contractList[index].orderItems.map((e)
                                      => e.quantity * e.iodp.round()).reduce((value, element) => value + element).toString())}'
                                          '$valyutaName' : '0$valyutaName',
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        height: 12 / 14,
                                        color: Color.fromRGBO(255, 255, 255, 0.9),
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
                                      '${format.format(invoiceProvider.contractList[index].date).toString()}',
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        height: 10 / 12,
                                        color: Color.fromRGBO(255, 255, 255, 0.5),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },  childCount: invoiceProvider.contractList.length),
                      ): SliverList(delegate: SliverChildBuilderDelegate((context,index){
                        return InkWell(
                          onTap: () async{
                            if (invoiceProvider.contractList[index].orderItems.isNotEmpty) {
                              invoiceProvider.setContractOrderId(invoiceProvider.contractList[index].id);
                              invoiceProvider.setContractEditOrNot(true);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => PrintContractScreen(
                                    discount: invoiceProvider.contractList[index].customer.discount,
                                    clientModel: Result(
                                      phone: invoiceProvider.contractList[index].customer.phone,
                                      fullname: invoiceProvider.contractList[index].customer.fullname,
                                      address: invoiceProvider.contractList[index].customer.address,
                                      discount: invoiceProvider.contractList[index].customer.discount,
                                      id: invoiceProvider.contractList[index].customer.id,
                                    ),
                                    order: invoiceProvider.contractList[index],
                                    amount: invoiceProvider.contractList[index].amount,
                                    orderId: invoiceProvider.orderIdContract,
                                    orderItems: invoiceProvider.contractList[index].orderItems,
                                  )));
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 30),
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Color.fromRGBO(171, 116, 64, 0.9),
                                ),
                                borderRadius: BorderRadius.circular(5)
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'WOISS-${invoiceProvider.contractList[index].orderNumber}',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    height: 12 / 14,
                                    color: Color.fromRGBO(255, 255, 255, 0.9),
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
                                  invoiceProvider.contractList[index].customer.fullname,
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    height: 12 / 14,
                                    color: Color.fromRGBO(255, 255, 255, 0.9),
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
                                  invoiceProvider.contractList[index].orderItems.isNotEmpty? '${moneyFormat(invoiceProvider.contractList[index].orderItems.map((e)
                                  => e.quantity * e.iodp.round()).reduce((value, element) => value + element).toString())}'
                                      '$valyutaName' : '0$valyutaName',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    height: 12 / 14,
                                    color: Color.fromRGBO(255, 255, 255, 0.9),
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
                                  '${format.format(invoiceProvider.contractList[index].date).toString()}',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    height: 10 / 12,
                                    color: Color.fromRGBO(255, 255, 255, 0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }, childCount: invoiceProvider.contractList.length))
                    ],
                  ),
                ): Container(
                  color: ColorsResources.PRIMARY_BACKROUND_COLOR,
                  child: Center(
                    child: Text(AppLocalization.of(context)?.translate('you_dont_have_any_contracts_yet')??'You don\'t have any contracts yet', style: TextStyle(
                        color: Colors.white
                    ),),
                  ),
                )),
          );
        })
    );
  }
}
