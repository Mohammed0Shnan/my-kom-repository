
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_kom/module_orders/model/order_model.dart';
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

  Future<DocumentSnapshot> addNewOrder(CreateOrderRequest orderRequest) async {

     try{
     DocumentReference document = await _firestore.collection('orders').add(orderRequest.mainDetailsToJson());
     await _firestore.collection('orders').doc(document.id).collection('details').add(orderRequest.moreDetailsToJson());
     DocumentSnapshot d =  await _firestore.collection('orders').doc(document.id).get();
     return d;

    }catch(e){
      throw Exception('Error in set data !');
    }
  }

  Future<OrderDetailResponse?> getOrderDetails(String orderId) async {
    try{
       return await _firestore.collection('orders').doc(orderId).collection('details').get().then((value) {
         Map <String ,dynamic> result = value.docs[0].data() ;
         result['id'] = orderId;

         OrderDetailResponse r =   OrderDetailResponse.fromJson(result) ;
         return r;
   });

    }catch(e){
      print(e);
      throw Exception('Error in set data !');
    }
  }


  Stream<QuerySnapshot> getMyOrders(String uid)  {

    try{
      return   _firestore.collection('orders').snapshots();
    }catch(e){
      throw Exception('Error in get data !');
    }
  }

 Future<bool> deleteOrder(String orderId)async {
    print('delete order by order id: ${orderId}');
    try{
      await _firestore.collection('orders').doc(orderId).delete();
     //  await Future.wait([
     //    //_firestore.collection('orders').doc(orderId).collection('details').

 //  ]);
      return true;
    }catch(e){
      print('tag : repository , message : Error in deleted !!! ');
      return false;
    }
 }




  // Future<OrderDetailsResponse?> updateOrder(UpdateOrderRequest request) async {
  //   // var token = await _authService.getToken();
  //   // dynamic response = await _apiClient.put(
  //   //   '${Urls.CAPTAIN_ORDER_UPDATE_API}',
  //   //   request.toJson(),
  //   //   headers: {'Authorization': 'Bearer ' + token},
  //   // );
  //
  //   // if (response == null) return null;
  //
  //   // return OrderDetailsResponse.fromJson(response);
  //   return null;
  // }
}
