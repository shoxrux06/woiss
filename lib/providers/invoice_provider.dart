import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:furniture_app/data/model/invoice_upload_model.dart';
import 'package:furniture_app/data/repository/invoice_repo.dart';
import 'package:furniture_app/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/model/response/order_get_model.dart';

class InvoiceProvider extends ChangeNotifier{

  final InvoiceRepo invoiceRepo;

  List<Order> _commercialList = [];

  List<Order> get commercialList  => _commercialList;

  List<Order> _contractList = [];

  InvoiceUploadModel? invoiceUploadModel;


  int _quantityOfCommercials = 0;

  int get quantityOfCommercials => _quantityOfCommercials;

  int _quantityOfContracts = 0;

  int get quantityOfContracts => _quantityOfContracts;

  List<Order> get contractList  => _contractList;

  bool _isLoadingCommercial = false;

  bool get isLoadingCommercial => _isLoadingCommercial;

  bool _isLoadingContract = false;

  bool get isLoadingContract => _isLoadingContract;

  bool _isEditCommercial = false;

  bool get isEditCommercial => _isEditCommercial;

  bool _isEditContract = false;

  bool get isEditContract => _isEditContract;

  int? _orderIdCommercial;

  int? get orderIdCommercial => _orderIdCommercial;

  int? _orderIdContract;

  int? get orderIdContract => _orderIdContract;

  setCommercialOrderId(int commercialOrderId){
    _orderIdCommercial = commercialOrderId;
    notifyListeners();
  }

  setContractOrderId(int contractOrderId){
    _orderIdContract = contractOrderId;
    notifyListeners();
  }

  setCommercialEditOrNot(bool isEditCommercialClicked){
    _isEditCommercial = isEditCommercialClicked;
    notifyListeners();
  }

  setContractEditOrNot(bool isEditContractClicked){
    _isEditContract = isEditContractClicked;
    notifyListeners();
  }


  InvoiceProvider({required this.invoiceRepo});

  Future<void> getCommercials(int userId) async {
    dynamic response;
    _isLoadingCommercial = true;
    response = await invoiceRepo.getCommercials(userId);
    if(response != null){
      _commercialList = List<Order>.from(response['orders'].map((item) => Order.fromJson(item)));
      _quantityOfCommercials = _commercialList.length;
      if(_commercialList.isEmpty){
        final _prefs = await SharedPreferences.getInstance();
        _prefs.setInt(AppConstants.ORDER_NUMBER, 1);
      }
      print('Soni>>>$_quantityOfCommercials');
      notifyListeners();
    }else{
      _commercialList = [];
      notifyListeners();
    }
    _isLoadingCommercial = false;
    notifyListeners();
  }

  Future<void> getContracts(int userId) async {
    dynamic response;
    _isLoadingContract = true;
    response = await invoiceRepo.getContracts(userId);
    if(response != null) {
      _contractList = List<Order>.from(response['orders'].map((item) => Order.fromJson(item)));
      _quantityOfContracts = _contractList.length;
      if(_contractList.isEmpty){
        final _prefs = await SharedPreferences.getInstance();
        _prefs.setInt(AppConstants.CONTRACT_NUMBER, 1);
      }
      notifyListeners();
    }else {
      _contractList = [];
      notifyListeners();
    }
    _isLoadingContract = false;
    notifyListeners();
  }

  Future<void> uploadInvoices(int id, String type, Uint8List file) async {
    dynamic response;
    _isLoadingContract = true;
    response = await invoiceRepo.uploadInvoices(id, type, file);
    print('response -->$response');
    print('response success -->${response['status']}');
    print('response success --> hii');
    if(response != null && response['status'] == 'success') {
      invoiceUploadModel = InvoiceUploadModel.fromJson(response);
      notifyListeners();
    }else {
      print('error file upload');
      notifyListeners();
    }
    _isLoadingContract = false;
    notifyListeners();
  }


}