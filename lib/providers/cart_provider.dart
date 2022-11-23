import 'dart:core';
import 'package:flutter/material.dart';
import '../data/cart.dart';

class CartProvider extends ChangeNotifier {
  List<Cart> _cartList = [];

  List<Cart> get cartList => _cartList;

  void setItemsToCart(List<Cart> cartItems){
    _cartList = cartItems;
    notifyListeners();
  }

  int _counter = 1;
  int _productCounter = 0;

  int _quantity = 1;
  int get counter => _counter;
  int get productCounter => _productCounter;
  int get quantity => _quantity;

  int _totalPrice = 0;
  int get totalPrice => _totalPrice;

  addToCart(Cart cart){
    _cartList.add(cart);
    notifyListeners();
  }

  void addProductCounter(){
    _productCounter++;
    notifyListeners();
  }
  void updateProductCounter(){
    _productCounter = 0;
    notifyListeners();
  }


  void addCounter() {
    _counter++;
    notifyListeners();
  }

  updateCounter(){
    _counter = 1;
    notifyListeners();
  }

  void removeCounter() {
    if(_counter >1){
      _counter--;
    }
    notifyListeners();
  }

  @override
  String toString() {
    return 'CartProvider{_cartList: $_cartList, _counter: $_counter, _productCounter: $_productCounter, _quantity: $_quantity, _totalPrice: $_totalPrice}';
  }

  void addQuantity(int id) {
    final index = _cartList.indexWhere((element) => element.id == id);
    _cartList[index].quantity.value = _cartList[index].quantity.value + 1;
    notifyListeners();
  }

  void deleteQuantity(int id) {
    final index = _cartList.indexWhere((element) => element.id == id);
    final currentQuantity = _cartList[index].quantity.value;
    if (currentQuantity <= 1) {
      currentQuantity == 1;
    } else {
      _cartList[index].quantity.value = currentQuantity - 1;
    }
    notifyListeners();
  }

  void removeItem(int id) {
    final index = _cartList.indexWhere((element) => element.id == id);
    _totalPrice = _totalPrice - (_cartList[index].product.intBranchPrice * _cartList[index].quantity.value);
    _cartList.removeAt(index);
    notifyListeners();
  }

  int getQuantity(int quantity) {
    return _quantity;
  }

  void clearCart(){
    _cartList.clear();
    notifyListeners();
  }
  void addTotalPrice(int productPrice, bool isAdded) {
    if(isAdded){
       _totalPrice = _totalPrice + productPrice;
    } else{
       _totalPrice = _totalPrice + (productPrice * _counter);
    }
    notifyListeners();
  }

  void removeTotalPrice(int productPrice) {
    _totalPrice = _totalPrice - productPrice;
    notifyListeners();
  }

  void clearTotalPrice() {
    _totalPrice = 0;
    notifyListeners();
  }

  void updateTotalPrice(int price) {
    _totalPrice = price;
    notifyListeners();
  }

  int getTotalPrice() {
    return _totalPrice;
  }

}
