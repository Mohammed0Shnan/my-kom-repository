
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_kom/consts/order_status.dart';
import 'package:my_kom/consts/payment_method.dart';
import 'package:my_kom/module_authorization/presistance/auth_prefs_helper.dart';
import 'package:my_kom/module_company/models/product_model.dart';
import 'package:my_kom/module_map/models/address_model.dart';
import 'package:my_kom/module_orders/model/order_model.dart';
import 'package:my_kom/module_orders/repository/order_repository/order_repository.dart';
import 'package:my_kom/module_orders/request/accept_order_request/accept_order_request.dart';
import 'package:my_kom/module_orders/request/order/order_request.dart';
import 'package:my_kom/module_orders/request/update_order_request/update_order_request.dart';
import 'package:my_kom/module_orders/response/branch.dart';
import 'package:my_kom/module_orders/response/order_details/order_details_response.dart';
import 'package:my_kom/module_orders/response/orders/orders_response.dart';
import 'package:my_kom/module_orders/utils/status_helper/status_helper.dart';
import 'package:my_kom/module_shoping/service/purchers_service.dart';
import 'package:my_kom/module_shoping/service/stripe.dart';
import 'package:rxdart/rxdart.dart';

class OrdersService {
  //final ProfileService _profileService;
  final  OrderRepository _orderRepository = OrderRepository();
  final AuthPrefsHelper _authPrefsHelper = AuthPrefsHelper();
  final StripeServices _stripeServices = StripeServices();
 final  PurchaseServices _purchaseServices = PurchaseServices();

  final PublishSubject<Map<String,List<OrderModel>>?> orderPublishSubject =
  new PublishSubject();

  Future<void> getMyOrders() async {
    String? uid = await _authPrefsHelper.getUserId();



      _orderRepository.getMyOrders(uid!).listen((event) {
        Map<String,List<OrderModel>> orderList = {};
        List<OrderModel> cur =[];
        List<OrderModel> pre =[];
        event.docs.forEach((element2) {
          Map <String ,dynamic> order = element2.data() as Map<String , dynamic>;
          order['id'] = element2.id;
          OrderModel orderModel = OrderModel.mainDetailsFromJson(order);

          if(orderModel.status == OrderStatus.DELIVERING.name)
            {
              pre.add(orderModel);
            }
          else{
            cur.add(orderModel);
          }

        }
        );
        orderList['cur']= cur;
        orderList['pre']= pre;

        orderPublishSubject.add(orderList);

      }).onError((e){
        print('errorrrrrrrrrrrrrrr in order service');
        orderPublishSubject.add(null);
      });

  }




  Future<OrderModel?> getOrderDetails(String orderId) async {
    try{
    OrderDetailResponse? response =   await _orderRepository.getOrderDetails(orderId);

    if(response ==null)
      return null;
    OrderModel orderModel = OrderModel() ;
     orderModel.id = response.id;
    orderModel.products = response.products;
    orderModel.payment = response.payment;
    orderModel.orderValue = response.orderValue;
    orderModel.description = response.description;
    orderModel.addressName = response.addressName;
    orderModel.destination = response.destination;
    orderModel.phone = response.phone;
    orderModel.startDate = response.startDate;
    orderModel.numberOfMonth = response.numberOfMonth;
    orderModel.deliveryTime = response.deliveryTime;
    orderModel.cardId = response.cardId;

    return orderModel;
    }catch(e){
      return null;
    }
  }

  Future<List<OrderModel>?> getNearbyOrders() async {
    // List<Order> response = await _ordersManager.getNearbyOrders();
    // if (response == null) {
    //   return null;
    // }

    // if (response.isEmpty) {
    //   return null;
    // }

    var orders = <OrderModel>[

    // OrderModel(
    //   to:  GeoJson(),
    //   from: element.fromBranch?.id.toString(),
    //   storeName: element.owner.userName,
    //   creationTime: DateTime.fromMillisecondsSinceEpoch(
    //       element.date.timestamp * 1000),
    //   paymentMethod: '',
    //   id: 1, chatRoomId: '', captainPhone: '', status: OrderStatus.DELIVERING,clientPhone: '',
    //
    // )
    // if (response.isNotEmpty) {
    //   response.forEach((element) {
    //     try {
    //       orders.add(OrderModel(
    //         to: element.location,
    //         from: element.fromBranch?.id.toString(),
    //         storeName: element.owner.userName,
    //         creationTime: DateTime.fromMillisecondsSinceEpoch(
    //             element.date.timestamp * 1000),
    //         paymentMethod: element.payment,
    //         id: element.id,
    //       ));
    //     } catch (e, stack) {
    //       Logger().error('Mapping Error',
    //           '${e.toString()}:\n${stack.toString()}', StackTrace.current);
    //     }
    //   });
    // }
      ];

    return orders;
  }

  Future<OrderModel?> addNewOrder(
      {required List<ProductModel>  products ,required String addressName, required String deliveryTimes,
        required DateTime date , required GeoJson destination, required String phoneNumber,required String paymentMethod,
        required  double amount , required String? cardId,required int numberOfMonth,required bool reorder,String? description
      }
      ) async {

    String? uId = await _authPrefsHelper.getUserId();
    String? customername = await _authPrefsHelper.getUsername();

    // if(paymentMethod == PaymentMethodConst.CREDIT_CARD){
    //   bool stripResponse =  await _stripeServices.charge(customer: customername!, amount: amount, userId: uId!, cardId: cardId);
    //   if(!stripResponse){
    //     throw Exception();
    //   }
    // }

    late CreateOrderRequest orderRequest;
    if(!reorder){
      Map<ProductModel,int> productsMap = Map<ProductModel,int>();
      products.forEach((element) {
        if(!productsMap.containsKey(element)){
          productsMap[element]= 1;
        }
        else{
          productsMap[element] = productsMap[element]! + 1;
        }
      });
      List<ProductModel> newproducts = [];
      String description = '';
      productsMap.forEach((key, value) {
        key.orderQuantity = value;
        description = description + key.orderQuantity.toString() + ' '+ key.title + ' + ';
        newproducts.add(key);
      });
       orderRequest = CreateOrderRequest(
          userId: uId!,
          destination: destination,
          phone: phoneNumber,
          payment: paymentMethod,
          products: newproducts,
          numberOfMonth: numberOfMonth,
          deliveryTime: deliveryTimes,
          orderValue: amount,
          startDate:   date.toIso8601String(),
          description:description.substring(0 , description.length-2),
          addressName :addressName,
          cardId:cardId

      );
      orderRequest.status = OrderStatus.DELIVERING.name;

    }
    else{
      orderRequest = CreateOrderRequest(
          userId: uId!,
          destination: destination,
          phone: phoneNumber,
          payment: paymentMethod,
          products: products,
          numberOfMonth: numberOfMonth,
          deliveryTime: deliveryTimes,
          orderValue: amount,
          startDate: date.toIso8601String(),
          description:description!,
          addressName :addressName,
          cardId:cardId
      );
      print('seeeeeeeeeeeeriveeeeeeeeeeeeeeeeee');
      print(orderRequest.userId);
      print(orderRequest.destination);
      print(orderRequest.phone);
      print(orderRequest.payment);
      print(orderRequest.products);
      print(orderRequest.numberOfMonth);
      print(orderRequest.deliveryTime.toString());
      print(orderRequest.orderValue);
      print(orderRequest.startDate);
      print(orderRequest.description);
      print(orderRequest.addressName);
      print(orderRequest.cardId);
      print('seeeeeeeeeeeeriveeeeeeeeeeeeeeeeee');
      orderRequest.status = OrderStatus.INIT.name;
    }


    DocumentSnapshot orderSnapShot =await _orderRepository.addNewOrder(orderRequest);
    // bool purchaseResponse =  await _purchaseServices.createPurchase(amount: amount, cardId: cardId, userId: uId, orderID: orderSnapShot.id, date: DateTime.now().toIso8601String());
    // if(!purchaseResponse){
    //   throw Exception();
    // }
    Map<String ,dynamic> map = orderSnapShot.data() as Map<String ,dynamic>;
    map['id'] = orderSnapShot.id;
   return OrderModel.mainDetailsFromJson(map);
  }

  closeStream(){
    orderPublishSubject.close();
  }

  Future<bool> deleteOrder(String orderId)async{
      bool response = await  _orderRepository.deleteOrder(orderId);
      if(response){
        return true;
      }else{
        return false;
      }
  }

 Future<OrderModel?> reorder(String orderID)async {
    OrderModel? order =  await getOrderDetails(orderID);

    if(order == null){

      return null;
    }
    else{

      // print('###############################');
      // print(order.destination);
      // print(order.phone);
      // print(order.payment);
      // print(order.products);
      // print(order.numberOfMonth);
      // print(order.deliveryTime.toString());
      // print(order.orderValue);
      // print(order.startDate);
      // print(order.description);
      // print(order.addressName);
      // print(order.cardId);
      // print('###############################');
      print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@!!!!!!!!!!!!!!!!!');
      print(order.destination.lat);
      OrderModel? neworder = await addNewOrder(products: order.products, addressName: order.addressName, deliveryTimes: order.deliveryTime, date: DateTime.parse(order.startDate), destination: order.destination, phoneNumber: order.phone, paymentMethod: order.payment, amount: order.orderValue, cardId: order.cardId, numberOfMonth: order.numberOfMonth,
      reorder: true,
        description: order.description
      );
   if(neworder !=null)
     return neworder;
         else
      return null;
    }


 }

  // Future<OrderModel?> getOrdersDetail(String ) async {
  //   _orderRepository.getOrderDetails(uid)
  //   // List<Order> response = await _ordersManager.getCaptainOrders();
  //   // if (response == null) return null;
  //
  //   // List<OrderModel> orders = [];
  //
  //   // response.forEach((element) {
  //   //   orders.add(new OrderModel(
  //   //     to: element.location,
  //   //     clientPhone: element.recipientPhone,
  //   //     from: '',
  //   //     storeName: element.userName,
  //   //     creationTime:
  //   //         DateTime.fromMillisecondsSinceEpoch(element.date.timestamp * 1000),
  //   //     paymentMethod: element.payment,
  //   //     id: element.id,
  //   //   ));
  //   // });
  //
  //   // return orders;
  //   return null;
  // }

  }

//   OrderDetailsResponse? updateOrder(int orderId, OrderModel order) {
//     switch (order.status) {
//       case OrderStatus.GOT_CAPTAIN:
//         var request = AcceptOrderRequest(orderID: orderId.toString(), duration: '');
//        // return _ordersManager.acceptOrder(request);
//         break;
//       case OrderStatus.IN_STORE:
//         var request = UpdateOrderRequest(id: orderId, state: 'in store', distance: '');
//        // return _ordersManager.updateOrder(request);
//         break;
//       case OrderStatus.DELIVERING:
//         var request = UpdateOrderRequest(id: orderId, state: 'ongoing', distance: '');
//        // return _ordersManager.updateOrder(request);
//         break;
//       case OrderStatus.GOT_CASH:
//         var request = UpdateOrderRequest(id: orderId, state: 'got cash', distance: '');
//        // return _ordersManager.updateOrder(request);
//         break;
//       case OrderStatus.FINISHED:
//         var request = UpdateOrderRequest(
//             id: orderId, state: 'delivered', distance: order.distance);
//        // return _ordersManager.updateOrder(request);
//         break;
//       default:
//      //   return null;
// return OrderDetailsResponse.fromJson({});
//
//     }
 // }



  Future<List<OrderModel>?> getCaptainOrders() async {
    // List<Order> response = await _ordersManager.getCaptainOrders();
    // if (response == null) return null;

    // List<OrderModel> orders = [];

    // response.forEach((element) {
    //   orders.add(new OrderModel(
    //     to: element.location,
    //     clientPhone: element.recipientPhone,
    //     from: '',
    //     storeName: element.userName,
    //     creationTime:
    //         DateTime.fromMillisecondsSinceEpoch(element.date.timestamp * 1000),
    //     paymentMethod: element.payment,
    //     id: element.id,
    //   ));
    // });

    // return orders;
    return null;
  }

