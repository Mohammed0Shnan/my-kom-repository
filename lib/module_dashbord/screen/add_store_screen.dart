

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/module_authorization/screens/widgets/top_snack_bar_widgets.dart';
import 'package:my_kom/module_dashbord/bloc/add_zone_bloc.dart';
import 'package:my_kom/module_dashbord/bloc/store_bloc.dart';
import 'package:my_kom/module_dashbord/models/store_model.dart';
import 'package:my_kom/module_dashbord/models/zone_models.dart';
import 'package:my_kom/module_dashbord/screen/all_store_screen.dart';
import 'package:my_kom/module_map/map_routes.dart';
import 'package:my_kom/module_map/models/address_model.dart';
import 'package:my_kom/module_orders/response/orders/orders_response.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';

class AddStoreScreen extends StatefulWidget {
  const AddStoreScreen({Key? key}) : super(key: key);

  @override
  State<AddStoreScreen> createState() => _AddStoreScreenState();
}

class _AddStoreScreenState extends State<AddStoreScreen> {

  final TextEditingController _newAddressController =
  TextEditingController();

  final TextEditingController _storeameController =
  TextEditingController();

  final TextEditingController _zoneNameController =
  TextEditingController();
  final ZoneBloc zoneBloc = ZoneBloc();
  final StoreBloc storeBloc = StoreBloc();
  late AddressModel addressModel ;
  late List<ZoneModel> zones=[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Store Screen'),

      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [

              /// Store Name
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(

                  child: ListTile(

                      subtitle: Container(
                        height: 50,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [BoxShadow(color: Colors.black26,blurRadius: 8,offset: Offset(0,3))]
                        ),
                        child: TextFormField(
                          controller: _storeameController,
                          decoration: InputDecoration(
                              errorStyle: GoogleFonts.lato(
                                color: Colors.red.shade700,
                                fontWeight: FontWeight.w800,


                              ),
                              prefixIcon: Icon(Icons.store),
                              border:InputBorder.none,
                              hintText: 'store name .'
                              , hintStyle:  TextStyle(color: Colors.black26,fontWeight: FontWeight.w800,fontSize: 13)

                            //S.of(context).name,
                          ),
                          // Move focus to next
                          validator: (result) {
                            if (result!.isEmpty) {
                              return 'Store Name is Required'; //S.of(context).nameIsRequired;
                            }
                            return null;
                          },
                        ),
                      )),
                ),
              ),


              ///   Address
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                    title: Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Text('Address', style:GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                            fontSize: SizeConfig.titleSize * 2.5
                        ))),
                    subtitle: Row(
                      children: [
                        Expanded(
                          child: Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                                boxShadow: [BoxShadow(color: Colors.black26,blurRadius: 8,offset: Offset(0,3))],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: TextFormField(
                              controller:
                              _newAddressController,
                              readOnly: true,
                              enableInteractiveSelection: true,

                              decoration: InputDecoration(
                                  errorStyle: GoogleFonts.lato(
                                    color: Colors.red.shade700,
                                    fontWeight: FontWeight.w800,


                                  ),
                                  prefixIcon:
                                  Icon(Icons.location_on),
                                  border:InputBorder.none,
                                  hintText: 'Burj Al Arab',
                                  hintStyle:  TextStyle(color: Colors.black26,fontWeight: FontWeight.w800,fontSize: 13)// S.of(context).email,
                              ),

                              textInputAction: TextInputAction.next,

                              // Move focus to next
                              validator: (result) {
                                if (result!.isEmpty) {
                                  return 'Address is Required'; //S.of(context).emailAddressIsRequired;
                                }

                                return null;
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(
                                context, MapRoutes.MAP_SCREEN)
                                .then((value) {
                              if (value != null) {
                                addressModel = (value as AddressModel);
                                _newAddressController.text =
                                    addressModel.description;
                              }
                            });
                          },
                          child: Container(

                            width: SizeConfig.heightMulti * 8.5,
                            height: SizeConfig.heightMulti * 8.5,
                            decoration: BoxDecoration(
                                color: ColorsConst.mainColor,
                                borderRadius:
                                BorderRadius.circular(10)),
                            child: Icon(
                                Icons.my_location_outlined,
                                size: SizeConfig.heightMulti * 4,
                                color: Colors.white),
                          ),
                        )
                      ],
                    )),
              ),

              /// Add Zones
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(

                  child: ListTile(

                      subtitle: Container(
                        height: 50,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [BoxShadow(color: Colors.black26,blurRadius: 8,offset: Offset(0,3))]
                        ),
                        child: TextFormField(
                          controller: _zoneNameController,
                          decoration: InputDecoration(
                              errorStyle: GoogleFonts.lato(
                                color: Colors.red.shade700,
                                fontWeight: FontWeight.w800,


                              ),
                             suffixIcon: IconButton(
                               icon: Icon(Icons.add),
                               onPressed: (){
                                String zone = _zoneNameController.text.trim();
                                 zoneBloc.addOne(zone);
                                _zoneNameController.clear();
                               },
                             ),
                              border:InputBorder.none,
                              hintText: 'zone name .'
                              , hintStyle:  TextStyle(color: Colors.black26,fontWeight: FontWeight.w800,fontSize: 13)

                            //S.of(context).name,
                          ),
                          // Move focus to next
                          validator: (result) {
                            if (result!.isEmpty) {
                              return 'Zone Name is Required'; //S.of(context).nameIsRequired;
                            }
                            return null;
                          },
                        ),
                      )),
                ),
              ),

              Container(
                height: 150,
                child: BlocBuilder<ZoneBloc,ZonesState>(
                  bloc: zoneBloc,
                  builder: (context,state) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),

                      child: ListView.separated(
                        separatorBuilder: (context,index){
                          return  SizedBox(height: 8,);
                        },
                        shrinkWrap:true ,
                        itemCount: state.zones.length,
                        itemBuilder: (context,index){

                          return   Center(
                            child: Container(
                              width: double.infinity,
                              height: 6.8 * SizeConfig.heightMulti,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.shade50,
                                  border: Border.all(
                                      color: Colors.black26,
                                      width: 2
                                  )
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,

                                children: [


                                  Text(state.zones[index] , style: GoogleFonts.lato(
                                      color: Colors.black54,
                                      fontSize: SizeConfig.titleSize * 2.1,
                                      fontWeight: FontWeight.bold
                                  ),),
                                  Spacer(),
                                  IconButton(onPressed: (){
                                    zoneBloc.removeOne(state.zones[index]);
                                  }, icon: Icon(Icons.delete,color: Colors.red,)),

                                ],
                              ),
                            ),
                          );

                        },

                      ),
                    );
                  }
                ),
              ),
              BlocConsumer<StoreBloc,StoreStates>(
                  bloc: storeBloc,
                  listener: (context,state)async{
                    if(state is StoreSuccessState)
                    {

                      snackBarSuccessWidget(context, 'Store Created Successfully!!');
                      Navigator.push(context,MaterialPageRoute(builder: (context)=>AllStoreScreen()));
                    }
                    else if(state is StoreErrorState)
                    {
                      snackBarSuccessWidget(context, 'The Store Was Not Created!!');
                    }
                  },
                  builder: (context,state) {
                    bool isLoading = state is StoreLoadingState?true:false;
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      clipBehavior: Clip.antiAlias,
                      height: 8.44 * SizeConfig.heightMulti,
                      width:isLoading?60: SizeConfig.screenWidth * 0.8,
                      padding: EdgeInsets.all(isLoading?8:0 ),
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          color: ColorsConst.mainColor,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child:isLoading?Center(child: CircularProgressIndicator(color: Colors.white,)): MaterialButton(
                        onPressed: () {

                          StoreModel store = StoreModel(id: '',zones: []);
                          store.name = _storeameController.text.trim();
                          store.location = GeoJson(lat: addressModel.latitude, lon: addressModel.longitude);
                          store.locationName = addressModel.description;
                          store.zones = zoneBloc.state.zones.map((e) =>ZoneModel(name: e) ).toList();
                          storeBloc.addStore(store);
                        },
                        child: Text('Add Store', style: TextStyle(color: Colors.white,
                            fontSize: SizeConfig.titleSize * 2.7),),

                      ),
                    );
                  }
              ),

              // Container(
              //   child: BlocBuilder<AddCompaniesBloc,AddCompanyState>(
              //     bloc: addCompaniesBloc,
              //     builder: (context,state){
              //       return ListView.builder(
              //           itemCount: state.companies.length,
              //           itemBuilder: (context,index){
              //         return Container(
              //           child: ,
              //         );
              //       });
              //     },
              //   ),
              // ),
              // Container(
              //   height: 150,
              //   child: BlocBuilder<ZoneBloc,ZonesState>(
              //       bloc: zoneBloc,
              //       builder: (context,state) {
              //         return Container(
              //           margin: EdgeInsets.symmetric(horizontal: 20),
              //
              //           child: ListView.separated(
              //             separatorBuilder: (context,index){
              //               return  SizedBox(height: 8,);
              //             },
              //             shrinkWrap:true ,
              //             itemCount: state.zones.length,
              //             itemBuilder: (context,index){
              //
              //               return   Center(
              //                 child: Container(
              //                   width: double.infinity,
              //                   height: 6.8 * SizeConfig.heightMulti,
              //                   decoration: BoxDecoration(
              //                       borderRadius: BorderRadius.circular(10),
              //                       color: Colors.grey.shade50,
              //                       border: Border.all(
              //                           color: Colors.black26,
              //                           width: 2
              //                       )
              //                   ),
              //                   child: Row(
              //                     mainAxisSize: MainAxisSize.min,
              //
              //                     children: [
              //
              //
              //                       Text(state.zones[index] , style: GoogleFonts.lato(
              //                           color: Colors.black54,
              //                           fontSize: SizeConfig.titleSize * 2.1,
              //                           fontWeight: FontWeight.bold
              //                       ),),
              //                       Spacer(),
              //                       IconButton(onPressed: (){
              //                         zoneBloc.removeOne(state.zones[index]);
              //                       }, icon: Icon(Icons.delete,color: Colors.red,)),
              //
              //                     ],
              //                   ),
              //                 ),
              //               );
              //
              //             },
              //
              //           ),
              //         );
              //       }
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
