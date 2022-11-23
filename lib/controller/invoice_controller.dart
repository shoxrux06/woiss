import 'dart:io';

import 'package:furniture_app/data/repository/client_repo.dart';
import 'package:furniture_app/data/repository/invoice_repo.dart';
import 'package:get/get.dart';

class InvoiceController extends GetxController {
  final InvoiceRepo invoiceRepo;

  InvoiceController(this.invoiceRepo);

  // Future<dynamic> postCommercial(int orderId, String type, File file) async {
  //   dynamic response;
  //   response = await invoiceRepo.postCommercial(orderId,type, file);
  //   if(response == null){
  //     return null;
  //   }else{
  //     return response;
  //   }
  // }



}
