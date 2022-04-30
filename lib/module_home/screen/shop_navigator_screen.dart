import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom/module_home/bloc/open_close_shop_bloc.dart';
import 'package:my_kom/module_home/screen/navigator_screen.dart';
import 'package:my_kom/module_shoping/screen/shop_screen.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';

class ShopNavigatorScreen extends StatefulWidget {
  final NavigatorScreen navigatorScreen;
  final ShopScreen shopScreen;
   ShopNavigatorScreen({required this.navigatorScreen,required  this.shopScreen,Key? key}) : super(key: key);

  @override
  State<ShopNavigatorScreen> createState() => _ShopNavigatorScreenState();
}

class _ShopNavigatorScreenState extends State<ShopNavigatorScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _shopeScaleAnimation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _animation = Tween<double>(begin: 1.0, end: 0.4).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: Offset(-10, 0), end: Offset(0, 0))
        .animate(_controller);
    _shopeScaleAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        _buildShopScreen(),
        _buildNavigatorScreen(),
      ]),
    );
  }

  _buildNavigatorScreen() {
    return BlocConsumer<OpenCloseShopBloc, bool>(
        bloc: openCloseShopBloc,
        listener: ((context, state) {
          if (state) {
            _controller.reverse();
          } else {
            _controller.forward();
          }
        }),
        builder: (context, state) {
          return AnimatedPositioned(
              duration: Duration(milliseconds: 200),
              bottom: 0,
              top: 0,
              left: state ? 0 : SizeConfig.screenWidth * 0.85,
              right: state ? 0 : -0.15 * SizeConfig.screenHeight,
              child: ScaleTransition(
                scale: _animation,
                child: widget.navigatorScreen,
              ));
        });
  }

  _buildShopScreen() {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _shopeScaleAnimation,
        child: widget.shopScreen,
      ),
    );
  }

  // _willPop() {
  //  // openCloseShopBloc.closeShop();
  // }
}
