import 'package:furniture_app/data/repository/order_repository.dart';
import 'package:get/get.dart';
import '../data/model/response/my_order_item.dart';

class OrderController extends GetxController {
  final OrderRepository orderRepository;

  OrderController(this.orderRepository);

  Future<dynamic> postOrder({
    required String userId,
    required String orderNumber,
    required String customerId,
    required String totalAmount,
    required List<MyOrderItem> orderItem
  }) async {
    dynamic response;
    response = await orderRepository.postOrder(
      userId: userId,
      orderNumber: orderNumber,
      customerId: customerId,
      totalAmount: totalAmount,
      orderItem: orderItem
    );
    print('########${response} postOrder');
    return response;
  }

  Future<dynamic> editOrder({
   required int? orderId,
    required List<MyOrderItem> orderItems
  }) async {
    dynamic response;
    response = await orderRepository.editOrder(
        orderId: orderId,
        orderItems: orderItems
    );
    print('########${response} editOrder');
    return response;
  }

  Future<dynamic> editContract({
    required int? orderId,
    required List<MyOrderItem> orderItems
  }) async {
    dynamic response;
    response = await orderRepository.editContract(
        orderId: orderId,
        orderItems: orderItems
    );
    print('########$response editOrder');
    return response;
  }

  Future<dynamic> postContract({
    required String userId,
    required String contractNumber,
    required String customerId,
    required String totalAmount,
    required List<MyOrderItem> orderItem
  }) async {
    dynamic response;
    response = await orderRepository.postContract(
        userId: userId,
        contractNumber: contractNumber,
        customerId: customerId,
        totalAmount: totalAmount,
        orderItem: orderItem
    );
    print('########${response} postContract');
    return response;
  }
}
