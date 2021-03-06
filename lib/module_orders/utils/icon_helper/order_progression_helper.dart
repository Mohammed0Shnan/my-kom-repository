import 'package:flutter/material.dart';
import 'package:my_kom/consts/order_status.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OrderProgressionHelper {
  static Widget getStatusIcon(OrderStatus status, BuildContext context) {
    if (status == null) {
      return SvgPicture.asset(
        'assets/images/searching.svg',
        color: Theme.of(context).primaryColor,
        height: 150,
      );
    }
    switch (status) {
      case OrderStatus.INIT:
        return SvgPicture.asset(
          'assets/images/searching.svg',
          color: Theme.of(context).primaryColor,
          height: 150,
        );
        break;
      case OrderStatus.GOT_CAPTAIN:
        return SvgPicture.asset(
          'assets/images/got_captain.svg',
          color: Theme.of(context).primaryColor,
          height: 150,
        );
        break;
      case OrderStatus.IN_STORE:
        return SvgPicture.asset(
          'assets/images/in_store.svg',
          color: Theme.of(context).primaryColor,
          height: 150,
        );
        break;
      case OrderStatus.DELIVERING:
        return SvgPicture.asset(
          'assets/images/got_package.svg',
          color: Theme.of(context).primaryColor,
          height: 150,
        );
        break;
      case OrderStatus.GOT_CASH:
        return SvgPicture.asset(
          'assets/images/got_cash.svg',
          color: Theme.of(context).primaryColor,
          height: 150,
        );
        break;
      case OrderStatus.FINISHED:
        return SvgPicture.asset(
          'assets/images/finished.svg',
          color: Theme.of(context).primaryColor,
          height: 150,
        );
        break;
      default:
        return Icon(
          Icons.error_outline,
          color: Theme.of(context).primaryColor,
          size: 150,
        );
    }
  }

  static String getNextStageHelper(OrderStatus status, bool isOnline, BuildContext context) {
    switch (status) {
      case OrderStatus.INIT:
        return 'acceptOrder';// S.of(context).acceptOrder;
        break;
      case OrderStatus.GOT_CAPTAIN:
        return 'iArrivedAtTheStore';//S.of(context).iArrivedAtTheStore;
        break;
      case OrderStatus.IN_STORE:
        return 'IN_STORE';//S.of(context).iGotThePackage;
        break;
      case OrderStatus.DELIVERING:
        return 'iFinishedDelivering';//S.of(context).iFinishedDelivering;
        break;
      case OrderStatus.GOT_CASH:
        return 'GOT_CASH';// isOnline ? S.of(context).iFinishedDelivering : S.of(context).iGotTheCash;
        break;
      case OrderStatus.FINISHED:
        return  'iFinishedDelivering';//S.of(context).iFinishedDelivering;
        break;
      default:
        return 'orderIsInUndefinedState';//S.of(context).orderIsInUndefinedState;
        break;
    }
  }

  static String getCurrentStageHelper(OrderStatus status, BuildContext context) {
    switch (status) {
      case OrderStatus.INIT:
        return 'searchingForCaptain';//S.of(context).searchingForCaptain;
        break;
      case OrderStatus.GOT_CAPTAIN:
        return 'captainIsInTheWay';//S.of(context).captainIsInTheWay;
        break;
      case OrderStatus.IN_STORE:
        return 'captainIsInStore';//S.of(context).captainIsInStore;
        break;
      case OrderStatus.DELIVERING:
        return 'captainIsDelivering';// S.of(context).captainIsDelivering;
        break;
      case OrderStatus.GOT_CASH:
        return 'captainGotTheCash';//S.of(context).captainGotTheCash;
        break;
      case OrderStatus.FINISHED:
        return 'orderIsDone';//S.of(context).orderIsDone;
        break;
      default:
        return 'orderIsInUndefinedState';// S.of(context).orderIsInUndefinedState;
        break;
    }
  }
}
