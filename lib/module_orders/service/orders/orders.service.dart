
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
import 'package:my_kom/module_shoping/service/purchers_service.dart';
import 'package:my_kom/module_shoping/service/stripe.dart';

class OrdersService {
  //final ProfileService _profileService;
  final  OrderRepository _orderRepository = OrderRepository();
  final AuthPrefsHelper _authPrefsHelper = AuthPrefsHelper();
  final StripeServices _stripeServices = StripeServices();
 final  PurchaseServices _purchaseServices = PurchaseServices();

  Future<List<OrderModel>?> getMyOrders() async {
    String? uid = await _authPrefsHelper.getUserId();
       await _orderRepository.getMyOrders(uid!);
   // if (response == null) return null;
   //
   //  List<OrderModel> orders = [];
   //
   //  response.forEach((element) {
   //    if (element.state != 'delivered') {
   //      orders.add(new OrderModel(
   //        to: element.location,
   //        clientPhone: element.recipientPhone,
   //        from: element.fromBranch.brancheName,
   //        creationTime: DateTime.fromMillisecondsSinceEpoch(
   //            element.date.timestamp * 1000),
   //        paymentMethod: element.payment,
   //        id: element.id,
   //      ));
   //    }
   //  });

   //return orders.reversed.toList();
   return null;
  }



  Future<OrderModel?> getOrderDetails(int orderId) async {
    // OrderDetailsData response = await _ordersManager.getOrderDetails(orderId);
    // if (response == null) return null;

    // var date =
    //     DateTime.fromMillisecondsSinceEpoch(response.date.timestamp * 1000);

    // OrderModel order = new OrderModel(
    //   paymentMethod: response.payment,
    //   from: response.fromBranch.toString(),
    //   to: response.location,
    //   creationTime: date,
    //   status: StatusHelper.getStatus(response.state),
    //   id: orderId,
    //   chatRoomId: response.uuid,
    //   ownerPhone: response.phone,
    //   captainPhone: response.acceptedOrder.isNotEmpty
    //       ? response.acceptedOrder.last.phone
    //       : null,
    // );

    // return order;
    return null;
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
        required  double amount , required String cardId,required int numberOfMonth
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
    
    print(description);
       var orderRequest = CreateOrderRequest(
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
         addressName :addressName
       );


    DocumentSnapshot orderSnapShot =await _orderRepository.addNewOrder(orderRequest);
    // bool purchaseResponse =  await _purchaseServices.createPurchase(amount: amount, cardId: cardId, userId: uId, orderID: orderSnapShot.id, date: DateTime.now().toIso8601String());
    // if(!purchaseResponse){
    //   throw Exception();
    // }
    Map<String ,dynamic> map = orderSnapShot.data() as Map<String ,dynamic>;
    map['id'] = orderSnapShot.id;
   return OrderModel.fromJson(map);
  }
  }

  OrderDetailsResponse? updateOrder(int orderId, OrderModel order) {
    switch (order.status) {
      case OrderStatus.GOT_CAPTAIN:
        var request = AcceptOrderRequest(orderID: orderId.toString(), duration: '');
       // return _ordersManager.acceptOrder(request);
        break;
      case OrderStatus.IN_STORE:
        var request = UpdateOrderRequest(id: orderId, state: 'in store', distance: '');
       // return _ordersManager.updateOrder(request);
        break;
      case OrderStatus.DELIVERING:
        var request = UpdateOrderRequest(id: orderId, state: 'ongoing', distance: '');
       // return _ordersManager.updateOrder(request);
        break;
      case OrderStatus.GOT_CASH:
        var request = UpdateOrderRequest(id: orderId, state: 'got cash', distance: '');
       // return _ordersManager.updateOrder(request);
        break;
      case OrderStatus.FINISHED:
        var request = UpdateOrderRequest(
            id: orderId, state: 'delivered', distance: order.distance);
       // return _ordersManager.updateOrder(request);
        break;
      default:
     //   return null;
return OrderDetailsResponse.fromJson({});

    }
  }

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

