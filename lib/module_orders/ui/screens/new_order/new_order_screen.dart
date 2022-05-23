
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_kom/module_orders/response/branch.dart';
import 'package:my_kom/module_orders/response/orders/orders_response.dart';
import 'package:my_kom/module_orders/state_manager/new_order/new_order.state_manager.dart';
import 'package:my_kom/module_orders/ui/state/new_order/new_order.state.dart';

import '../../../orders_routes.dart';

class NewOrderScreen extends StatefulWidget {
  final NewOrderStateManager _stateManager = NewOrderStateManager();

  // NewOrderScreen(
  //   this._stateManager,
  // );

  @override
  NewOrderScreenState createState() => NewOrderScreenState();
}

class NewOrderScreenState extends State<NewOrderScreen> {

  NewOrderState? currentState =null;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

 late Branch fromBranch;
 late GeoJson destination;
 late String note;
 late String paymentMethod;
 late String recipientName;
 late String recipientPhone;
 late String date;

  void addNewOrder(
    String recipientName,
    String recipientPhone,
  ) {
    widget._stateManager.addNewOrder(fromBranch, destination, note,
        paymentMethod, recipientName, recipientPhone, date, this);
  }

  void moveToNext() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      OrdersRoutes.OWNER_ORDERS_SCREEN,
          (r) => false,
    );
  }

  void initNewOrder(Branch fromBranch, GeoJson destination, String note,
      String paymentMethod, String date) {
    this.fromBranch = fromBranch;
    this.destination = destination;
    this.note = note;
    this.paymentMethod = paymentMethod;
    this.date = date;
    currentState = NewOrderStateSuccessState(this);
    refresh();
  }

  void showSnackBar(String msg) {
    //_scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(msg)));
  }

  void refresh() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    currentState =NewOrderStateInit(this);
    widget._stateManager.stateStream.listen((event) {
      currentState = event;
      if (mounted) {
        setState(() {});
      }
    });
    widget._stateManager.loadBranches(this, LatLng(0.0, 1.1));
  }

  @override
  Widget build(BuildContext context) {

      //LatLng linkFromWhatsApp = ModalRoute.of(context).settings.arguments;
     // currentState?= NewOrderStateInit(this);
     // widget._stateManager.loadBranches(this, linkFromWhatsApp);

    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: currentState!.getUI(context),
      ),
    );
  }
}
