import 'package:flutter/widgets.dart';
import 'package:furniture_app/data/repository/client_repo.dart';
import 'package:get/get.dart';

class ClientController extends GetxController{

  final ClientRepo clientRepo;

  ClientController({required this.clientRepo});

  Future<dynamic> searchClientFromAPI(String phoneNumber) async {
    dynamic response;
    response = await clientRepo.searchClient(phoneNumber);
    if(response == null)
      return null;
    if(response['status'] == true) {
      update();
      return response;
    } else{
      return null;
    }
  }

  Future<dynamic> addClient(String fullname, String phone, String address, String discount) async {
    dynamic response;
    response = await clientRepo.addClient(fullname, phone, address,discount);
    if(response == null){
      return null;
    }else{
      return response;
    }
  }

  Future<dynamic> editClient(int clientId, String fullname, String phone, String address, int discount) async {
    dynamic response;
    response = await clientRepo.editClient(clientId,fullname, phone, address,discount);
    if(response == null){
      return null;
    }else{
      return response;
    }
  }

}