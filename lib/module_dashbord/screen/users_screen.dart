import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/module_authorization/authorization_routes.dart';
import 'package:my_kom/module_authorization/enums/user_role.dart';
import 'package:my_kom/module_authorization/model/app_user.dart';
import 'package:my_kom/module_authorization/screens/widgets/top_snack_bar_widgets.dart';
import 'package:my_kom/module_dashbord/bloc/user_bloc.dart';
import 'package:my_kom/module_orders/model/order_model.dart';
import 'package:my_kom/module_orders/orders_routes.dart';
import 'package:my_kom/module_orders/state_manager/captain_orders/captain_orders.dart';
import 'package:my_kom/module_orders/state_manager/new_order/new_order.state_manager.dart';
import 'package:my_kom/module_orders/ui/state/owner_orders/orders.state.dart';
import 'package:my_kom/module_orders/ui/widgets/delete_order_sheak_alert.dart';
import 'package:my_kom/module_profile/profile_routes.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';


class UsersScreen extends StatefulWidget {


  @override
  State<StatefulWidget> createState() => UsersScreenState();
}

class UsersScreenState extends State<UsersScreen> {
  final UsersBloc _usersBloc = UsersBloc();
  final NewOrderBloc _orderBloc = NewOrderBloc();
  final String CURRENT_ORDER = 'Admins';
  final String PREVIOUS_ORDER = 'Users';
  late String current_tap ;
  @override
  void initState() {
    current_tap = CURRENT_ORDER;
    _usersBloc.getsUsers();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
  return BlocProvider.value(
    value: _usersBloc,
    child: Scaffold(
      backgroundColor: Colors.grey.shade50,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, AuthorizationRoutes.REGISTER_SCREEN,arguments: UserRole.ROLE_OWNER);
        },
        backgroundColor: ColorsConst.mainColor,
        child: Text('Add',style: GoogleFonts.lato(
          color: Colors.white,
          fontWeight: FontWeight.bold
        ),),

      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8,vertical: 5),
              child: Text('Users',style: GoogleFonts.lato(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black45
              ),),
            ),
            SizedBox(height: 8,),
            getAccountSwitcher(),
            SizedBox(height: 8,),

            Expanded(
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                child: current_tap == CURRENT_ORDER
                    ? getUsers()
                    : getAdmins(),
              ),
            ),
          ],
        ),
      ),

    ),
  );
  }
  Widget getAccountSwitcher() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.widhtMulti * 3),
      child: BlocBuilder<UsersBloc ,UsersStates >(
        bloc: _usersBloc,
        builder: (context, state) {
          int users =0;
          int admins =0;
          if(state is UsersSuccessState){
            users =state.users.length;
            admins = state.admins.length;
          }
          return Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    current_tap = CURRENT_ORDER;
                    if (mounted) {
                      setState(() {});
                    }
                  },
                  child: AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: current_tap == CURRENT_ORDER
                            ? ColorsConst.mainColor
                            : Colors.transparent,

                      ),
                      child: Center(child: Text('Users (${users})',style: TextStyle(
                        color: current_tap == CURRENT_ORDER ?Colors.white: ColorsConst.mainColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16
                      ),))),
                ),
              ),
              Expanded(
                child:GestureDetector(
                  onTap: () {
                    current_tap = PREVIOUS_ORDER;
                    if (mounted) {
                      setState(() {});
                    }
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),

                      color:    current_tap == PREVIOUS_ORDER
                          ? ColorsConst.mainColor
                          : Colors.transparent,
                    ),
                    child:Center(child: Text('Admins (${admins})',style: TextStyle(
                        color: current_tap == PREVIOUS_ORDER ?Colors.white: ColorsConst.mainColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16
                    ))),
                  ),
                ),
              )

            ],
          );
        }
      ),
    );
  }
  Future<void> onRefreshMyOrder()async {
   // _ordersListBloc.getMyOrders();
  }
 Widget getUsers(){
    return BlocConsumer<UsersBloc ,UsersStates >(
      bloc: _usersBloc,
      listener: (context ,state){
        // print(state);
        // if (state is CaptainOrderDeletedErrorState){
        //   if(state.message == 'Error'){
        //    snackBarErrorWidget(context, 'Error in deleted !!');
        //   }
        //   else{
        //     snackBarSuccessWidget(context, 'Success Deleted , Refresh !!');
        //   }
        // }
        // else if(state is CaptainOrdersListSuccessState ){
        //   if(state.message !=null){
        //     snackBarSuccessWidget(context, 'Success Deleted , Refresh !!');
        //   }
        // }
      },
      builder: (maincontext,state) {

         if(state is UsersErrorState)
          return Center(
            child: GestureDetector(
              onTap: (){

              },
              child: Container(
                color: ColorsConst.mainColor,
                padding: EdgeInsets.symmetric(),
                child: Text('',style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white),),
              ),
            ),
          );

        else if(state is UsersSuccessState) {
           List<AppUser> users =state.users;

           if(users.isEmpty)
             return Center(
               child: Container(child: Text('Empty !!'),),
             );
           else
          return RefreshIndicator(
          onRefresh: ()=>onRefreshMyOrder(),
          child: ListView.separated(
            itemCount:users.length,
            separatorBuilder: (context,index){
              return SizedBox(height: 8,);
            },
            itemBuilder: (context,index){
              return GestureDetector(
                onTap:(){
                  Navigator.pushNamed(context, ProfileRoutes.PROFILE_SCREEN,arguments:users[index].id );
                },
                child: Container(
                  height: 120,
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(horizontal: 16,vertical: 5),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius:2,
                        spreadRadius: 1
                      )
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 80,
                        width: 60,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/profile.png'),
                            fit: BoxFit.cover
                          )
                        ),
                      ),
                      SizedBox(width: 20,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Row(
                            children: [
                              Icon(Icons.perm_identity,size: 18,),
                              SizedBox(width: 8,),
                              Text(users[index].user_name,overflow: TextOverflow.ellipsis,style: GoogleFonts.lato(
                                  fontSize: 15,
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w800
                              )),
                            ],
                          ),
                          SizedBox(height: 8,),
                          Row(
                            children: [
                              Icon(Icons.email_outlined,size: 18,),
                              SizedBox(width: 8,),
                              Text(users[index].email,overflow: TextOverflow.ellipsis,style: GoogleFonts.lato(
                                  fontSize: 15,
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w800
                              )),
                            ],
                          ),
                          SizedBox(height: 8,),

                          Row(
                            children: [
                              Icon(Icons.location_on_outlined,size: 18,),
                              SizedBox(width: 8,),
                              Text(users[index].address.description,overflow: TextOverflow.ellipsis,style: GoogleFonts.lato(
                                  fontSize: 14,
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w800,

                              )),
                            ],
                          ),


                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );}
        else  return Center(
             child: Container(
               width: 40,
               height: 40,
               child: CircularProgressIndicator(color: ColorsConst.mainColor,),
             ),
           );

      }
    );
  }

  Widget getAdmins(){
    return BlocConsumer<UsersBloc ,UsersStates >(
        bloc: _usersBloc,
        listener: (context ,state){
          // print(state);
          // if (state is CaptainOrderDeletedErrorState){
          //   if(state.message == 'Error'){
          //    snackBarErrorWidget(context, 'Error in deleted !!');
          //   }
          //   else{
          //     snackBarSuccessWidget(context, 'Success Deleted , Refresh !!');
          //   }
          // }
          // else if(state is CaptainOrdersListSuccessState ){
          //   if(state.message !=null){
          //     snackBarSuccessWidget(context, 'Success Deleted , Refresh !!');
          //   }
          // }
        },
        builder: (maincontext,state) {

          if(state is UsersErrorState)
            return Center(
              child: GestureDetector(
                onTap: (){

                },
                child: Container(
                  color: ColorsConst.mainColor,
                  padding: EdgeInsets.symmetric(),
                  child: Text('',style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white),),
                ),
              ),
            );

          else if(state is UsersSuccessState) {
            List<AppUser> users = state.admins;

            if(users.isEmpty)
              return Center(
                child: Container(child: Text('Empty !!'),),
              );
            else
              return RefreshIndicator(
                onRefresh: ()=>onRefreshMyOrder(),
                child: Stack(
                  children: [
                    ListView.separated(
                      itemCount:users.length,
                      separatorBuilder: (context,index){
                        return SizedBox(height: 8,);
                      },
                      itemBuilder: (context,index){
                        return GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(context, ProfileRoutes.PROFILE_SCREEN,arguments:users[index].id );

                          },
                          child: Container(
                            height: 120,
                            width: SizeConfig.screenWidth,
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.symmetric(horizontal: 16,vertical: 5),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12,
                                    blurRadius:2,
                                    spreadRadius: 1
                                )
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 80,
                                  width: 60,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage('assets/profile.png'),
                                          fit: BoxFit.cover
                                      )
                                  ),
                                ),
                                SizedBox(width: 20,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [

                                    Row(
                                      children: [
                                        Icon(Icons.perm_identity,size: 18,),
                                        SizedBox(width: 8,),
                                        Text(users[index].user_name,overflow: TextOverflow.ellipsis,style: GoogleFonts.lato(
                                            fontSize: 15,
                                            color: Colors.black45,
                                            fontWeight: FontWeight.w800
                                        )),
                                      ],
                                    ),
                                    SizedBox(height: 8,),
                                    Row(
                                      children: [
                                        Icon(Icons.email_outlined,size: 18,),
                                        SizedBox(width: 8,),
                                        Text(users[index].email,overflow: TextOverflow.ellipsis,style: GoogleFonts.lato(
                                            fontSize: 15,
                                            color: Colors.black45,
                                            fontWeight: FontWeight.w800
                                        )),
                                      ],
                                    ),
                                    SizedBox(height: 8,),

                                    Row(
                                      children: [
                                        Icon(Icons.location_on_outlined,size: 18,),
                                        SizedBox(width: 8,),
                                        Container(
                                          width: SizeConfig.screenWidth * 0.6,
                                          child: Text(users[index].address.description.toString(),overflow: TextOverflow.ellipsis,style: GoogleFonts.lato(
                                            fontSize: 14,
                                            color: Colors.black45,
                                            fontWeight: FontWeight.w800,

                                          )),
                                        ),
                                      ],
                                    ),


                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    // BlocConsumer<NewOrderBloc,CreateOrderStates>(
                    //     bloc: _orderBloc,
                    //     listener: (context,state)async{
                    //       if(state is CreateOrderSuccessState)
                    //       {
                    //         snackBarSuccessWidget(context, 'Order Created Successfully!!');
                    //       }
                    //       else if(state is CreateOrderErrorState)
                    //       {
                    //         snackBarSuccessWidget(context, 'The Order Was Not Created!!');
                    //       }
                    //     },
                    //     builder: (context,state) {
                    //       bool isLoading = state is CreateOrderLoadingState?true:false;
                    //
                    //       return isLoading? Center(child: Container(
                    //         width: 30,
                    //         height: 30,
                    //         child: CircularProgressIndicator(),
                    //       ),):SizedBox.shrink();
                    //
                    //     }
                    // ),

                  ],
                ),
              );}
          else  return Center(
              child: Container(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(color: ColorsConst.mainColor,),
              ),
            );

        }
    );
  }

}
