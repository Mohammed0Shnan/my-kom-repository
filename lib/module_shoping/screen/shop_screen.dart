import 'package:flutter/material.dart';
import 'package:my_kom/module_home/bloc/open_close_shop_bloc.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({Key? key}) : super(key: key);

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Container(
              width: SizeConfig.screenWidth - 50,
              child: Column(children: []),
            ),
            IconButton(
                onPressed: () {
                  openCloseShopBloc.closeShop();
                },
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  size: SizeConfig.heightMulti * 4,
                  color: Colors.black54,
                ))
          ],
        ),
      ),
    );
  }
}
