
import 'package:my_kom/consts/order_status.dart';
import 'package:my_kom/module_orders/model/order_model.dart';
import 'package:my_kom/module_orders/repository/order_repository/order_repository.dart';
import 'package:my_kom/module_orders/request/accept_order_request/accept_order_request.dart';
import 'package:my_kom/module_orders/request/order/order_request.dart';
import 'package:my_kom/module_orders/request/update_order_request/update_order_request.dart';
import 'package:my_kom/module_orders/response/branch.dart';
import 'package:my_kom/module_orders/response/order_details/order_details_response.dart';
import 'package:my_kom/module_orders/response/orders/orders_response.dart';

class OrdersService {
  //final ProfileService _profileService;
  final  OrderRepository _orderRepository = OrderRepository();
  //OrdersService(this._ordersManager, this._profileService);

  Future<List<OrderModel>?> getMyOrders() async {
   // List<Order> response = await _ordersManager.getMyOrders();
   // if (response == null) return null;

    // List<OrderModel> orders = [];

    // response.forEach((element) {
    //   if (element.state != 'delivered') {
    //     orders.add(new OrderModel(
    //       to: element.location,
    //       clientPhone: element.recipientPhone,
    //       from: element.fromBranch.brancheName,
    //       creationTime: DateTime.fromMillisecondsSinceEpoch(
    //           element.date.timestamp * 1000),
    //       paymentMethod: element.payment,
    //       id: element.id,
    //     ));
    //   }
    // });

   // return orders.reversed.toList();
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

  Future<bool> addNewOrder(
      Branch fromBranch,
      GeoJson destination,
      String phone,
      String paymentMethod,
      String date) async {
    var orderRequest = CreateOrderRequest(
      phone: phone,
      date: date,
      payment: paymentMethod,
      fromBranch: fromBranch.id.toString(),

      destination: destination,
    );
    return 
     _orderRepository.addNewOrder(orderRequest);
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
}
