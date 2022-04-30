import 'package:flutter/material.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/module_home/bloc/open_close_shop_bloc.dart';
import 'package:my_kom/module_home/widgets/page_view_widget.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';

class HomeScreen extends StatefulWidget {
  
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        child: SafeArea(
            child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: IconButton(onPressed: (){
                    
                    openCloseShopBloc.openShop();
                  }, icon: Icon(Icons.shop)),
                ),
                Text('My KOM')
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
                height: SizeConfig.screenHeight * 0.3,
                child: PageViewWidget(
                
                    hieght: SizeConfig.screenHeight * 0.26,
                    pageBuilder: (index) {
                      return Container(
                        margin: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                  offset: Offset(0, 2),
                                  color: ColorsConst.mainColor,
                                  blurRadius: 15,
                                  spreadRadius: 0)
                            ]),
                      );
                    })),
                    

          ],
        )),
      ),
    );
  }
}
