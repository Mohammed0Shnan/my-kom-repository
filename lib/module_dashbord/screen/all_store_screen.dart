import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/module_dashbord/bloc/all_store_bloc.dart';
import 'package:my_kom/module_dashbord/models/store_model.dart';
import 'package:my_kom/module_dashbord/screen/store_detail_screen.dart';
import 'package:my_kom/module_orders/ui/widgets/delete_order_sheak_alert.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';

class AllStoreScreen extends StatefulWidget {
  const AllStoreScreen({Key? key}) : super(key: key);

  @override
  State<AllStoreScreen> createState() => _AllStoreScreenState();
}

class _AllStoreScreenState extends State<AllStoreScreen> {
  final AllStoreBloc allStoreBloc = AllStoreBloc();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allStoreBloc.getAllStore();
  }
  @override
  Widget build(BuildContext maincontext) {
    return Scaffold(
      appBar: AppBar(title: Text('All Stores'),backgroundColor: ColorsConst.mainColor,),
      body: BlocConsumer<AllStoreBloc, AllStoreStates>(
        bloc: allStoreBloc,
        listener: (context, state) {},
        builder: (context, state) {
          if (state is AllStoreSuccessState) {
            List<StoreModel> stores = state.data;


            if(stores.isEmpty)
              return Center(
                child: Container(child: Text('Empty !!'),),
              );
            else
              return RefreshIndicator(
                onRefresh: ()=>onRefreshStores(),
                child: ListView.separated(
                  itemCount:stores.length,
                  separatorBuilder: (context,index){
                    return SizedBox(height: 8,);
                  },
                  itemBuilder: (context,index){
                    return Container(
                      height: 135,
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              Text('Details',style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w800
                              ),),

                            ],
                          ),
                          SizedBox(height: 8,),
                          Expanded(
                            child: Text('Store Name :  ' +stores[index].name,overflow: TextOverflow.ellipsis,style: GoogleFonts.lato(
                                fontSize: 12,
                                color: Colors.black45,
                                fontWeight: FontWeight.w800
                            )),
                          ),
                          SizedBox(height: 4,),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.location_on_outlined , color: Colors.black45,),
                              Expanded(
                                child: Text(stores[index].locationName,overflow: TextOverflow.ellipsis,style: GoogleFonts.lato(
                                  fontSize: 12,
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w800,

                                )),
                              )

                            ],),
                          SizedBox(height: 8,),
                      Container(
                        height: 30,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            color: Colors.white
                            ,
                            border: Border.all(
                                color: ColorsConst.mainColor,
                                width: 2
                            ),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: MaterialButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> StoreDetailScreen(storeID: stores[index].id)));
                          },
                          child: Text('Details', style: TextStyle(
                              color: ColorsConst.mainColor,
                              fontSize: SizeConfig.titleSize * 2.6),),

                        ),
                      ),

                        ],
                      ),
                    );
                  },
                ),
              );
          } else if (state is AllStoreErrorState) {
            return Center(
                child: Container(
                  child: Text(state.message),
                ));
          } else

            return Center(
                child: Container(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(),
                ));
        },
      ),
    );
  }

 Future onRefreshStores()async{
    allStoreBloc.getAllStore();
 }
}
