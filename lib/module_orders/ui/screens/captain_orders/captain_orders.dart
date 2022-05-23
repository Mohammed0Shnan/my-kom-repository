import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_kom/generated/l10n.dart';

import 'package:my_kom/module_orders/state_manager/captain_orders/captain_orders.dart';
import 'package:my_kom/module_orders/ui/state/captain_orders/captain_orders_list_state.dart';
import 'package:my_kom/module_orders/ui/state/captain_orders/captain_orders_list_state_loading.dart';

class CaptainOrdersScreen extends StatefulWidget {
  final CaptainOrdersListStateManager _stateManager = CaptainOrdersListStateManager();

  //CaptainOrdersScreen(this._stateManager);

  @override
  State<StatefulWidget> createState() => CaptainOrdersScreenState();
}

class CaptainOrdersScreenState extends State<CaptainOrdersScreen> {

  late CaptainOrdersListState currentState;
//  ProfileResponseModel _currentProfile;

 late StreamSubscription _stateSubscription;
 late StreamSubscription _profileSubscription;

  void getMyOrders() {
    widget._stateManager.getMyOrders(this);
  }

  void refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  void requestAuthorization() {
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   Navigator.of(context).pushNamedAndRemoveUntil(
    //     AuthorizationRoutes.LOGIN_SCREEN,
    //     (r) => false,
    //   );
    // });
  }

  @override
  void initState() {
    super.initState();
    currentState = CaptainOrdersListStateLoading(this);
    widget._stateManager.getMyOrders(this);
    _stateSubscription = widget._stateManager.stateStream.listen((event) {
      currentState = event;
      if (mounted) {
        setState(() {});
      }
    });

    // _profileSubscription = widget._stateManager.profileStream.listen((event) {
    //   _currentProfile = event;
    //   if (mounted) {
    //     setState(() {});
    //   }
    // });

    widget._stateManager.getProfile();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'orders',
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                //Navigator.of(context).pushNamed(ProfileRoutes.EDIT_ACTIVITY_SCREEN);
              }),
        ],
      ),
      // drawer: _currentProfile != null
      //     ? DrawerWidget(
      //         username: _currentProfile.name ?? 'user',
      //         user_image: _currentProfile.imageURL ??
      //             'https://orthosera-dental.com/wp-content/uploads/2016/02/user-profile-placeholder.png',
      //       )
      //     : DrawerWidget(),
      body: currentState.getUI(context),
    );
  }

}
