
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_kom/module_authorization/service/auth_service.dart';
import 'package:my_kom/module_orders/request/order/order_request.dart';
import 'package:my_kom/module_orders/request/update_order_request/update_order_request.dart';
import 'package:my_kom/module_orders/response/order_details/order_details_response.dart';
import 'package:my_kom/module_orders/response/order_status/order_status_response.dart';
import 'package:my_kom/module_orders/response/orders/orders_response.dart';

class OrderRepository {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // OrderRepository(
  //   this._apiClient,
  //   this._authService,
  // );

  Future<bool> addNewOrder(CreateOrderRequest orderRequest) async {

    try{

      await _firestore.collection('orders').add(orderRequest.toJson());

    }catch(e){
      throw Exception('Error in set data !');

    }
    return true;

  }

  Future<OrderDetailsData?> getOrderDetails(int orderId) async {
    return null;
    // if (orderId == null) {
    //   return null;
    // }
    // await _authService.refreshToken();
    // var token = await _authService.getToken();

    // dynamic response = await _apiClient.get(
    //   Urls.ORDER_STATUS_API + '$orderId',
    //   headers: {'Authorization': 'Bearer $token'},
    // );
    // if (response == null) return null;
    // return OrderStatusResponse.fromJson(response).data;
  }

  Future<List<Order>?> getNearbyOrders() async {
    return null;
    // var token = await _authService.getToken();

    // if (token == null) {
    //   throw UnauthorizedException('User Not Logged In');
    // }

    // dynamic response = await _apiClient.get(
    //   Urls.NEARBY_ORDERS_API,
    //   headers: {'Authorization': 'Bearer ' + token},
    // );
    // if (response == null) return null;

    // var list = OrdersResponse.fromJson(response).data;
    // return list;
  }

  Future<List<Order>?> getMyOrders() async {
    return null;
    // await _authService.refreshToken();
    // var token = await _authService.getToken();

    // try {
    //   dynamic response = await _apiClient.get(
    //     Urls.OWNER_ORDERS_API,
    //     headers: {'Authorization': 'Bearer ${token}'},
    //   );
    //   if (response == null) return [];

    //   return OrdersResponse
    //       .fromJson(response)
    //       .data;
    // } catch (e) {
    //   return [];
    // }
  }

  Future<List<Order>?> getCaptainOrders() async {
    return null;
  //   var token = await _authService.getToken();

  //   dynamic response = await _apiClient.get(
  //     Urls.CAPTAIN_ACCEPTED_ORDERS_API,
  //     headers: {'Authorization': 'Bearer ${token}'},
  //   );
  //   if (response == null) return [];

  //   return OrdersResponse.fromJson(response).data;
  // }

  // Future<OrderDetailsResponse> acceptOrder(AcceptOrderRequest request) async {
  //   var token = await _authService.getToken();
  //   dynamic response = await _apiClient.post(
  //     '${Urls.ACCEPT_ORDER_API}',
  //     request.toJson(),
  //     headers: {'Authorization': 'Bearer ' + token},
  //   );

  //   if (response == null) return null;

  //   return OrderDetailsResponse.fromJson(response);
  }

  Future<OrderDetailsResponse?> updateOrder(UpdateOrderRequest request) async {
    // var token = await _authService.getToken();
    // dynamic response = await _apiClient.put(
    //   '${Urls.CAPTAIN_ORDER_UPDATE_API}',
    //   request.toJson(),
    //   headers: {'Authorization': 'Bearer ' + token},
    // );

    // if (response == null) return null;

    // return OrderDetailsResponse.fromJson(response);
    return null;
  }
}
