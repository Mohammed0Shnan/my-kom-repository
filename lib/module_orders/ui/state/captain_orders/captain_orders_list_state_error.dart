
import 'package:flutter/material.dart';
import 'package:my_kom/module_orders/ui/screens/captain_orders/captain_orders.dart';

import 'captain_orders_list_state.dart';

class CaptainOrdersListStateError extends CaptainOrdersListState {
  final String errorMsg;

  CaptainOrdersListStateError(
      this.errorMsg, CaptainOrdersScreenState screenState)
      : super(screenState);

  @override
  Widget getUI(BuildContext context) {
    return Center(
      child: Text('Error ${errorMsg}'),
    );
  }
}
