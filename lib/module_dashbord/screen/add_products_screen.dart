

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/module_authorization/screens/widgets/top_snack_bar_widgets.dart';
import 'package:my_kom/module_company/models/company_model.dart';
import 'package:my_kom/module_company/models/product_model.dart';
import 'package:my_kom/module_dashbord/bloc/add_advertisement_bloc.dart';
import 'package:my_kom/module_dashbord/bloc/add_company1_bloc.dart';
import 'package:my_kom/module_dashbord/bloc/add_product_bloc.dart';
import 'package:my_kom/module_dashbord/bloc/add_specefications_bloc.dart';
import 'package:my_kom/module_dashbord/bloc/add_zone_bloc.dart';
import 'package:my_kom/module_dashbord/bloc/all_store_bloc.dart';
import 'package:my_kom/module_dashbord/bloc/store_bloc.dart';
import 'package:my_kom/module_dashbord/enum/advertisement_type.dart';
import 'package:my_kom/module_dashbord/models/advertisement_model.dart';
import 'package:my_kom/module_dashbord/models/store_model.dart';
import 'package:my_kom/module_dashbord/models/zone_models.dart';
import 'package:my_kom/module_dashbord/requests/add_company_request.dart';
import 'package:my_kom/module_dashbord/requests/add_product_request.dart';
import 'package:my_kom/module_dashbord/screen/all_store_screen.dart';
import 'package:my_kom/module_map/map_routes.dart';
import 'package:my_kom/module_map/models/address_model.dart';
import 'package:my_kom/module_orders/response/orders/orders_response.dart';
import 'package:my_kom/module_upload/upload_bloc.dart';
import 'package:my_kom/module_upload/widgets/choose_photo_source_dialog.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {

  final TextEditingController _nameCompanyController =
  TextEditingController();
  final TextEditingController _desCompanyController =
  TextEditingController();

  final TextEditingController _nameProductController =
  TextEditingController();
  final TextEditingController _desProductController =
  TextEditingController();

  final TextEditingController _priceProductController =
  TextEditingController();


  final TextEditingController _quantityProductController =
  TextEditingController();

  final TextEditingController _routeController =
  TextEditingController();
  //final ZoneBloc zoneBloc = ZoneBloc();
  final AllStoreBloc allStoreBloc = AllStoreBloc();
  final UploadBloc _uploadCompanyImageBloc = UploadBloc();
  final UploadBloc _uploadAdvertisementImageBloc = UploadBloc();
  final UploadBloc _uploadProductImageBloc = UploadBloc();
  final AddCompanyBloc _addCompanyBloc = AddCompanyBloc();
  final AddAdvertisementBloc _addAdvertisementBloc = AddAdvertisementBloc();
  final AddProductBloc _addProductBloc = AddProductBloc();
  final SpecificationsBloc specificationsBloc = SpecificationsBloc();

  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  /// Company Parameters
  late AddressModel addressModel ;
  late List<ZoneModel> zones=[];
  String? _storeID = null;
  String? _companyID = null;
  String? _image = null;
  late CompanyModel companyModel;
 /// Product Parameters
  String ? _imageProduct = null;

  String ? _advertisementImage = null;
  late double price;
  bool isRecommended = false;

  bool  formOpen  =false;

  bool  productFormOpen  =false;

  bool AdvertisementFormOpen  =false;

  String? advertisementType = null;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allStoreBloc.getAllStore();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        title: Text('Add Products Screen'),
        backgroundColor: ColorsConst.mainColor,

      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [

              /// Selected Store
              SizedBox(height: 20,),

              Text('Store'),
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
                        child: BlocBuilder<AllStoreBloc, AllStoreStates> (
                            bloc:allStoreBloc,
                            builder: (context, state) {
                              if(state is AllStoreSuccessState){
                                print('state is success');
                                print(state.data);
                                return DropdownButtonFormField<String>(
                                  onTap: () {},
                                  validator: (s) {
                                    return s == null
                                        ? 'Store Is Required !'
                                        : null;
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Store',
                                    hintStyle: TextStyle(fontSize: 16),
                                  ),
                                  items: _getCategoriesDropDownList(
                                         state.data
                                          ),
                                  onChanged: (s) {

                                    _storeID = s;
                                    setState(() {

                                    });
                                  },
                                );
                              }
                             else if (state is AllStoreErrorState) {
                                return ElevatedButton(
                                  child: Text(
                                      'Error in fetch stores .. Click to Try Again'),
                                  onPressed: () {
                                    allStoreBloc.getAllStore();
                                  },
                                );
                              } else {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Stores'),
                                    Container(
                                      width: 50,
                                      child: CircularProgressIndicator(),
                                    )
                                  ],
                                );
                              }
                            }),
                      )),
                ),
              ),


              SizedBox(height: 20,),
              /// Select Company
              Text('Company'),
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
                        child: BlocBuilder<AllStoreBloc, AllStoreStates> (
                            bloc:allStoreBloc,
                            builder: (context, state) {
                              if (state is AllStoreLoadingState) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Company'),
                                    Container(
                                      width: 50,
                                      child: CircularProgressIndicator(),
                                    )
                                  ],
                                );
                              } else if (state is AllStoreErrorState) {
                                return ElevatedButton(
                                  child: Text(
                                      'Error in fetch company .. Click to Try Again'),
                                  onPressed: () {
                                    allStoreBloc.getAllStore();
                                  },
                                );
                              } else {
                                return DropdownButtonFormField<String>(
                                  onTap: () {},
                                  validator: (s) {
                                    return s == null
                                        ? 'company Is Required !'
                                        : null;
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'company',
                                    hintStyle: TextStyle(fontSize: 16),
                                  ),
                                  items: _getCompanyDropDownList(
                                      state is AllStoreSuccessState
                                          ? state.data
                                          : []),
                                  onChanged: (s) {

                                    _companyID = s;
                                    print(_companyID);
                                  },
                                );
                              }
                            }),
                      )),
                ),
              ),
              SizedBox(height: 20,),
              Divider(color: Colors.black45,height: 5,thickness:3,endIndent: 20,indent: 20,),
              SizedBox(height: 10,),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                children: [
                  Text('if you choose Null'),
                  GestureDetector(
                      onTap: (){
                        formOpen = ! formOpen;
                        setState(() {

                        });
                      },
                      child: Text('Click here',style: TextStyle(color: Colors.blue),)),
                ],
              )),
              SizedBox(height: 10,),
              if(formOpen)
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  elevation: 5,

                  child: Column(children: [
                  // late final String id;
                  // late final String name;
                  // late String description;
                  // late String imageUrl;
                    Text('company Name'),
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
                                controller: _nameCompanyController,
                                decoration: InputDecoration(
                                    errorStyle: GoogleFonts.lato(
                                      color: Colors.red.shade700,
                                      fontWeight: FontWeight.w800,


                                    ),
                                    prefixIcon: Icon(Icons.store),
                                    border:InputBorder.none,
                                    hintText: 'company name .'
                                    , hintStyle:  TextStyle(color: Colors.black26,fontWeight: FontWeight.w800,fontSize: 13)

                                  //S.of(context).name,
                                ),
                                // Move focus to next
                                validator: (result) {
                                  if (result!.isEmpty) {
                                    return 'company Name is Required'; //S.of(context).nameIsRequired;
                                  }
                                  return null;
                                },
                              ),
                            )),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Text('company description'),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(

                        child: ListTile(

                            subtitle: Container(

                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [BoxShadow(color: Colors.black26,blurRadius: 8,offset: Offset(0,3))]
                              ),
                              child: TextFormField(
                                controller: _desCompanyController,
                              maxLines: 5,
                                decoration: InputDecoration(
                                    errorStyle: GoogleFonts.lato(
                                      color: Colors.red.shade700,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    prefixIcon: Icon(Icons.store),
                                    border:InputBorder.none,
                                    hintText: 'company description .'
                                    , hintStyle:  TextStyle(color: Colors.black26,fontWeight: FontWeight.w800,fontSize: 13)

                                  //S.of(context).name,
                                ),
                                // Move focus to next
                                validator: (result) {
                                  if (result!.isEmpty) {
                                    return 'company description is Required'; //S.of(context).nameIsRequired;
                                  }
                                  return null;
                                },
                              ),
                            )),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Text('company image'),
                    BlocConsumer<UploadBloc, UploadStates>(
                        bloc: _uploadCompanyImageBloc,
                        listener: (context, state) {
                          if(state is UploadSuccessState){
                            _scaffoldState.currentState!.showSnackBar(SnackBar(content: Text('Company Image successful uploaded')));

                          }
                        },
                        builder: (context, state) {
                          if (state is UploadSuccessState) {
                            _image = state.image;
                          }
                          return Container(
                            width: 150,
                            height: 150,

                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                state is UploadLoadingState
                                    ? Container(
                                  padding: EdgeInsets.all(20),
                                  width: 150,
                                  height: 150,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black12,
                                  ),
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                ): state is UploadInitState?
                                Container(
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                      color: Colors.grey
                                          ,shape: BoxShape.circle
                                    // image: DecorationImage(
                                    //   image: new ExactAssetImage('assets/logo3.png'),
                                    //   fit: BoxFit.cover,
                                    // ),
                                  ),
                                )
                                :Container(
                                  width: 150,
                                  height: 150,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black12,
                                  ),
                                  child: _image == null
                                      ? Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey
                                      // image: DecorationImage(
                                      //   image: new ExactAssetImage('assets/logo3.png'),
                                      //   fit: BoxFit.cover,
                                      // ),
                                    ),
                                  )
                                      : CachedNetworkImage(
                                    imageUrl: _image!,
                                    progressIndicatorBuilder: (context, l, ll) =>
                                        CircularProgressIndicator(
                                          value: ll.progress,
                                        ),
                                    errorWidget: (context, s, l) => Icon(Icons.error),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                    // : Container(
                                    // width: 150,
                                    // height: 150,
                                    // decoration: BoxDecoration(
                                    //     shape: BoxShape.circle,
                                    //     color: Colors.black12,
                                    //     image: _image == null
                                    //         ? null
                                    //         : DecorationImage(
                                    //         fit: BoxFit.cover,
                                    //         image: AssetImage('assets/logo3.png')))),
                                Positioned(
                                    bottom: 0,
                                    left: 0,
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.blue,
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          choosePhotoSource(context, _uploadCompanyImageBloc);
                                        },
                                        icon: Icon(
                                          Icons.camera,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ))
                              ],
                            ),
                          );
                        }),

                    SizedBox(height: 20,),
                    BlocConsumer<AddCompanyBloc, AddCompanyStates>(
                        bloc: _addCompanyBloc,
                        listener: (context,state)async{
                          if(state is AddCompanySuccessState)
                          {
                            _image = null;
                            _storeID = null;
                            _uploadCompanyImageBloc.initState();

                            _nameCompanyController.clear();
                            _desCompanyController.clear();
                            allStoreBloc.getAllStore();
                            setState(() {

                            });
                            snackBarSuccessWidget(context, 'Company Added Successfully!!');
                          }
                          else if(state is AddCompanyErrorState)
                          {
                            snackBarSuccessWidget(context, 'Company Added Was Not Created!!');
                          }
                        },
                        builder: (context,state) {
                          bool isLoading = state is AddCompanyLoadingState?true:false;
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
                                if(_storeID == null){
                                  _scaffoldState.currentState!.showSnackBar(SnackBar(content: Text('Please Select Store !!!!')));
                                }
                                else {
                                  String companyName = _nameCompanyController.text.trim();
                                  String companyDes = _desCompanyController.text.trim();

                                  AddCompanyRequest request = AddCompanyRequest(name: companyName, description:companyDes , imageUrl: _image!);
                                  _addCompanyBloc.addCompany(_storeID!, request);
                                }

                              },
                              child: Text('Add Company', style: TextStyle(color: Colors.white,
                                  fontSize: SizeConfig.titleSize * 2.7),),

                            ),
                          );
                        }
                    ),

                  ],),
                ),
              SizedBox(height: 30,)


              /// Add Product Section
              ///
            ,
              Divider(color: Colors.black45,height: 5,thickness:3,endIndent: 20,indent: 20,),

              Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Text('Add Products '),
                      GestureDetector(
                          onTap: (){
                            productFormOpen = ! productFormOpen;
                            setState(() {

                            });
                          },
                          child: Text('Click here',style: TextStyle(color: Colors.blue),)),
                    ],
                  )),
              SizedBox(height: 10,),


              if(productFormOpen)
              Card(
                margin: EdgeInsets.symmetric(horizontal: 10),
                elevation: 5,

                child: Column(children: [
                  // late final String id;
                  // late final String name;
                  // late String description;
                  // late String imageUrl;
                  SizedBox(height:20,),
                  Text('Add Products'),
                  SizedBox(height: 10,),
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
                              controller: _nameProductController,
                              decoration: InputDecoration(
                                  errorStyle: GoogleFonts.lato(
                                    color: Colors.red.shade700,
                                    fontWeight: FontWeight.w800,


                                  ),
                                  prefixIcon: Icon(Icons.store),
                                  border:InputBorder.none,
                                  hintText: 'product name .'
                                  , hintStyle:  TextStyle(color: Colors.black26,fontWeight: FontWeight.w800,fontSize: 13)

                                //S.of(context).name,
                              ),
                              // Move focus to next
                              validator: (result) {
                                if (result!.isEmpty) {
                                  return 'product Name is Required'; //S.of(context).nameIsRequired;
                                }
                                return null;
                              },
                            ),
                          )),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text('product description'),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(

                      child: ListTile(

                          subtitle: Container(

                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [BoxShadow(color: Colors.black26,blurRadius: 8,offset: Offset(0,3))]
                            ),
                            child: TextFormField(
                              controller: _desProductController,
                              maxLines: 5,
                              decoration: InputDecoration(

                                  errorStyle: GoogleFonts.lato(
                                    color: Colors.red.shade700,
                                    fontWeight: FontWeight.w800,


                                  ),
                                  prefixIcon: Icon(Icons.store),
                                  border:InputBorder.none,
                                  hintText: 'Product description .'
                                  , hintStyle:  TextStyle(color: Colors.black26,fontWeight: FontWeight.w800,fontSize: 13)

                                //S.of(context).name,
                              ),
                              // Move focus to next
                              validator: (result) {
                                if (result!.isEmpty) {
                                  return 'Product description is Required'; //S.of(context).nameIsRequired;
                                }
                                return null;
                              },
                            ),
                          )),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(

                      child: ListTile(

                          subtitle: Container(

                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [BoxShadow(color: Colors.black26,blurRadius: 8,offset: Offset(0,3))]
                            ),
                            child: TextFormField(
                              controller: _quantityProductController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(

                                  errorStyle: GoogleFonts.lato(
                                    color: Colors.red.shade700,
                                    fontWeight: FontWeight.w800,


                                  ),
                                  prefixIcon: Icon(Icons.store),
                                  border:InputBorder.none,
                                  hintText: 'Quantity .'
                                  , hintStyle:  TextStyle(color: Colors.black26,fontWeight: FontWeight.w800,fontSize: 13)

                                //S.of(context).name,
                              ),
                              // Move focus to next
                              validator: (result) {
                                if (result!.isEmpty) {
                                  return 'Product Quantity is Required'; //S.of(context).nameIsRequired;
                                }
                                return null;
                              },
                            ),
                          )),
                    ),
                  ),

                  SizedBox(height: 10,),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(

                      child: ListTile(

                          subtitle: Container(

                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [BoxShadow(color: Colors.black26,blurRadius: 8,offset: Offset(0,3))]
                            ),
                            child: TextFormField(
                              controller: _priceProductController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(

                                  errorStyle: GoogleFonts.lato(
                                    color: Colors.red.shade700,
                                    fontWeight: FontWeight.w800,


                                  ),
                                  prefixIcon: Icon(Icons.store),
                                  border:InputBorder.none,
                                  hintText: 'Price .'
                                  , hintStyle:  TextStyle(color: Colors.black26,fontWeight: FontWeight.w800,fontSize: 13)

                                //S.of(context).name,
                              ),
                              // Move focus to next
                              validator: (result) {
                                if (result!.isEmpty) {
                                  return 'Product Price is Required'; //S.of(context).nameIsRequired;
                                }
                                return null;
                              },
                            ),
                          )),
                    ),
                  ),

                  SizedBox(height: 10,),
                  Text('Product image'),
                  BlocConsumer<UploadBloc, UploadStates>(
                      bloc: _uploadProductImageBloc,
                      listener: (context,state){
                    if (state is UploadSuccessState) {
                      _scaffoldState.currentState!.showSnackBar(SnackBar(content: Text('Product image successful uploaded')));
                           }
                  },
                      builder: (context, state) {
                        if (state is UploadSuccessState) {
                          _imageProduct = state.image;
                        }
                        return Container(
                          width: 150,
                          height: 150,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              state is UploadLoadingState
                                  ? Container(
                                padding: EdgeInsets.all(20),
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black12,
                                ),
                                child: Center(
                                    child: CircularProgressIndicator()),
                              )
                                  : state is UploadInitState?
                              Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                    color: Colors.grey
                                    ,shape: BoxShape.circle
                                  // image: DecorationImage(
                                  //   image: new ExactAssetImage('assets/logo3.png'),
                                  //   fit: BoxFit.cover,
                                  // ),
                                ),
                              ):Container(
                                width: 150,
                                height: 150,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black12,
                                ),
                                child: _imageProduct == null
                                    ? Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey
                                    // image: DecorationImage(
                                    //   image: new ExactAssetImage('assets/logo3.png'),
                                    //   fit: BoxFit.cover,
                                    // ),
                                  ),
                                )
                                    : CachedNetworkImage(
                                  imageUrl: _imageProduct!,
                                  progressIndicatorBuilder: (context, l, ll) =>
                                      CircularProgressIndicator(
                                        value: ll.progress,
                                      ),
                                  errorWidget: (context, s, l) => Icon(Icons.error),
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Positioned(
                                  bottom: 0,
                                  left: 0,
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.blue,
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        choosePhotoSource(context, _uploadProductImageBloc);
                                      },
                                      icon: Icon(
                                        Icons.camera,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                        );
                      }),
                  // Container(
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(15),
                  //   ),
                  //   child: Container(
                  //
                  //     child: ListTile(
                  //
                  //         subtitle: Container(
                  //           height: 50,
                  //           clipBehavior: Clip.antiAlias,
                  //           decoration: BoxDecoration(
                  //               color: Colors.white,
                  //               borderRadius: BorderRadius.circular(10),
                  //               boxShadow: [BoxShadow(color: Colors.black26,blurRadius: 8,offset: Offset(0,3))]
                  //           ),
                  //           child: TextFormField(
                  //             controller: _speciProductController,
                  //             decoration: InputDecoration(
                  //                 errorStyle: GoogleFonts.lato(
                  //                   color: Colors.red.shade700,
                  //                   fontWeight: FontWeight.w800,
                  //
                  //
                  //                 ),
                  //                 suffixIcon: IconButton(
                  //                   icon: Icon(Icons.add),
                  //                   onPressed: (){
                  //                     String value = _speciProductController.text.trim();
                  //                     sp.name =
                  //                         SpecificationsModel sp = SpecificationsModel(name: name, value: value);
                  //
                  //                     specificationsBloc.addOne(sp);
                  //                     _speciProductController.clear();
                  //                   },
                  //                 ),
                  //                 border:InputBorder.none,
                  //                 hintText: 'zone name .'
                  //                 , hintStyle:  TextStyle(color: Colors.black26,fontWeight: FontWeight.w800,fontSize: 13)
                  //
                  //               //S.of(context).name,
                  //             ),
                  //             // Move focus to next
                  //             validator: (result) {
                  //               if (result!.isEmpty) {
                  //                 return 'Zone Name is Required'; //S.of(context).nameIsRequired;
                  //               }
                  //               return null;
                  //             },
                  //           ),
                  //         )),
                  //   ),
                  // ),
                  // Container(
                  //   height: 100,
                  //   child: BlocBuilder<SpecificationsBloc,SpecificationsState>(
                  //       bloc: specificationsBloc,
                  //       builder: (context,state) {
                  //         return Container(
                  //           margin: EdgeInsets.symmetric(horizontal: 20),
                  //
                  //           child: ListView.separated(
                  //             separatorBuilder: (context,index){
                  //               return  SizedBox(height: 8,);
                  //             },
                  //             shrinkWrap:true ,
                  //             itemCount: state.data.length,
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
                  //                       Text(state.data[index].value +'  :  ', style: GoogleFonts.lato(
                  //                           color: Colors.black54,
                  //                           fontSize: SizeConfig.titleSize * 2.1,
                  //                           fontWeight: FontWeight.bold
                  //                       ),),
                  //                       Text(state.data[index].name , style: GoogleFonts.lato(
                  //                           color: Colors.black54,
                  //                           fontSize: SizeConfig.titleSize * 2.1,
                  //                           fontWeight: FontWeight.bold
                  //                       ),),
                  //                       Spacer(),
                  //                       IconButton(onPressed: (){
                  //                         specificationsBloc.removeOne(state.data[index]);
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
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Text('Recommended'),
                  //
                  //     Checkbox(
                  //       value: isRecommended,
                  //       onChanged: (bool? value) {
                  //         setState(() {
                  //           isRecommended = value!;
                  //         });
                  //       },
                  //     ),
                  //   ],
                  // ),
                  SizedBox(height: 20,),
                  BlocConsumer<AddProductBloc, AddProductStates>(
                      bloc: _addProductBloc,
                      listener: (context,state)async{
                        if(state is AddProductSuccessState)
                        {
                          _imageProduct = null;
                          _uploadProductImageBloc.initState();

                          _nameProductController.clear();
                          _desProductController.clear();
                          _priceProductController.clear();
                          _quantityProductController.clear();
                          setState(() {
                          });
                          snackBarSuccessWidget(context, 'Product Added Successfully!!');
                        }
                        else if(state is AddProductErrorState)
                        {
                          snackBarSuccessWidget(context, 'Product Added Was Not Created!!');
                        }
                      },
                      builder: (context,state) {
                        bool isLoading = state is AddProductLoadingState?true:false;
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
                              print(_storeID);
                              if(_storeID == null){
                                _scaffoldState.currentState!.showSnackBar(SnackBar(content: Text('Please Select Store !!!!')));
                              }
                              else if(_companyID == null){
                                _scaffoldState.currentState!.showSnackBar(SnackBar(content: Text('Please Select Company !!!!')));

                              }
                              else {
                                String productName = _nameProductController.text.trim();
                                String productDes = _desProductController.text.trim();
                                double price = double.parse(_priceProductController.text.trim());
                                int quantity = int.parse(_quantityProductController.text.trim());
                                AddProductRequest productRequest = AddProductRequest(isRecommended: isRecommended,title: productName,description: productDes,imageUrl: _imageProduct!,
                                    price: price,quantity: quantity
                                );
                                _addProductBloc.addProduct(_storeID!, _companyID!, productRequest);
                              }

                            },
                            child: Text('Add Product', style: TextStyle(color: Colors.white,
                                fontSize: SizeConfig.titleSize * 2.7),),

                          ),
                        );
                      }
                  ),

                ],),
              ),
              SizedBox(height: 30,)

              /// Advertisements
              ///
             , Divider(color: Colors.black45,height: 5,thickness:3,endIndent: 20,indent: 20,),

              Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Text('Add Advertisement '),
                      GestureDetector(
                          onTap: (){
                            AdvertisementFormOpen = !AdvertisementFormOpen;
                            setState(() {

                            });
                          },
                          child: Text('Click here',style: TextStyle(color: Colors.blue),)),
                    ],
                  )),
              SizedBox(height: 10,),


              if(AdvertisementFormOpen)
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  elevation: 5,
                  child: Column(
                    children: [
                    // late final String id;
                    // late final String name;
                    // late String description;
                    // late String imageUrl;
                      SizedBox(height: 10,),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal:20),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [BoxShadow(color: Colors.black26,blurRadius: 8,offset: Offset(0,3))]
                      ),
                      child: ListTile(
                        title:  Text('Advertisement Type'),subtitle:
                      DropdownButtonFormField<String>(
                        onTap: () {},
                        validator: (s) {
                          return s == null
                              ? 'Store Is Required !'
                              : null;
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Advertisement Type',
                          hintStyle: TextStyle(fontSize: 16),
                        ),
                        items: [
                          DropdownMenuItem<String>(
                            value: AdvertisementType.ADVERTISEMENT_PRODUCT.name,
                            child: Text(
                              'ADVERTISEMENT PRODUCT',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          DropdownMenuItem<String>(
                            value: AdvertisementType.ADVERTISEMENT_COMPANY.name,
                            child: Text(
                              'ADVERTISEMENT COMPANY',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          DropdownMenuItem<String>(
                            value:AdvertisementType.ADVERTISEMENT_OFFER.name,
                            child: Text(
                              'ADVERTISEMENT OFFER',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          DropdownMenuItem<String>(
                            value: AdvertisementType.ADVERTISEMENT_EXTERNAL.name,
                            child: Text(
                              'ADVERTISEMENT EXTERNAL',
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        ],
                        onChanged: (s) {

                          advertisementType = s;
                          setState(() {

                          });
                        },
                      ),
                      ),
                    ),
                      SizedBox(height: 15,),

                    Text('Advertisement Name'),
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
                                controller: _routeController,
                                decoration: InputDecoration(
                                    errorStyle: GoogleFonts.lato(
                                      color: Colors.red.shade700,
                                      fontWeight: FontWeight.w800,


                                    ),
                                    prefixIcon: Icon(Icons.store),
                                    border:InputBorder.none,
                                    hintText: 'Advertisement route .'
                                    , hintStyle:  TextStyle(color: Colors.black26,fontWeight: FontWeight.w800,fontSize: 13)

                                  //S.of(context).name,
                                ),
                                // Move focus to next
                                validator: (result) {
                                  if (result!.isEmpty) {
                                    return 'Advertisement route is Required'; //S.of(context).nameIsRequired;
                                  }
                                  return null;
                                },
                              ),
                            )),
                      ),
                    ),
                    SizedBox(height: 10,),
                      Text('Advertisement image'),
                    BlocConsumer<UploadBloc, UploadStates>(
                        bloc: _uploadAdvertisementImageBloc,
                        listener: (context, state) {
                          if(state is UploadSuccessState){
                            _scaffoldState.currentState!.showSnackBar(SnackBar(content: Text('Advertisement Image successful uploaded')));

                          }
                        },
                        builder: (context, state) {
                          if (state is UploadSuccessState) {
                            _advertisementImage = state.image;
                          }
                          return Container(
                            width: SizeConfig.screenWidth * 0.8,
                            height: 150,

                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                state is UploadLoadingState
                                    ? Container(
                                  padding: EdgeInsets.all(20),
                                  width: SizeConfig.screenWidth * 0.8,
                                  height: 150,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                ): state is UploadInitState?
                                Container(
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                    borderRadius: BorderRadius.circular(20),
                                    // image: DecorationImage(
                                    //   image: new ExactAssetImage('assets/logo3.png'),
                                    //   fit: BoxFit.cover,
                                    // ),
                                  ),
                                )
                                    :Container(
                                  width: SizeConfig.screenWidth * 0.8,
                                  height: 150,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(20),

                                  ),
                                  child: _advertisementImage == null
                                      ? Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey
                                      // image: DecorationImage(
                                      //   image: new ExactAssetImage('assets/logo3.png'),
                                      //   fit: BoxFit.cover,
                                      // ),

                                    ),
                                  )
                                      : CachedNetworkImage(
                                    imageUrl: _advertisementImage!,
                                    progressIndicatorBuilder: (context, l, ll) =>
                                        Center(
                                          child: Container(
                                            height: 40,
                                            width: 40,
                                            child: CircularProgressIndicator(
                                              value: ll.progress,
                                            ),
                                          ),
                                        ),
                                    errorWidget: (context, s, l) => Icon(Icons.error),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                // : Container(
                                // width: 150,
                                // height: 150,
                                // decoration: BoxDecoration(
                                //     shape: BoxShape.circle,
                                //     color: Colors.black12,
                                //     image: _image == null
                                //         ? null
                                //         : DecorationImage(
                                //         fit: BoxFit.cover,
                                //         image: AssetImage('assets/logo3.png')))),
                                Positioned(
                                    bottom: 0,
                                    left: 0,
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.blue,
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          choosePhotoSource(context, _uploadAdvertisementImageBloc);
                                        },
                                        icon: Icon(
                                          Icons.camera,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ))
                              ],
                            ),
                          );
                        }),

                    SizedBox(height: 20,),
                    BlocConsumer<AddAdvertisementBloc, AddAdvertisementStates>(
                        bloc: _addAdvertisementBloc,
                        listener: (context,state)async{
                          if(state is AddAdvertisementSuccessState)
                          {
                            _advertisementImage = null;
                            _storeID = null;
                            _uploadAdvertisementImageBloc.initState();
                            allStoreBloc.getAllStore();
                            setState(() {

                            });
                            snackBarSuccessWidget(context, 'Advertisement Added Successfully!!');
                          }
                          else if(state is AddAdvertisementErrorState)
                          {
                            snackBarSuccessWidget(context, 'Advertisement Added Was Not Created!!');
                          }
                        },
                        builder: (context,state) {
                          bool isLoading = state is AddAdvertisementLoadingState?true:false;
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
                                if(_storeID == null){
                                  _scaffoldState.currentState!.showSnackBar(SnackBar(content: Text('Please Select Store !!!!')));
                                }
                                else {
                                  String route = _routeController.text.trim();
                                  if(advertisementType != null){
                                    String query =advertisementType.toString()+'/'+route;
                                    AdvertisementModel request = AdvertisementModel(id: '', imageUrl: _advertisementImage!, route: query,storeID: _storeID!);
                                    _addAdvertisementBloc.addAdvertisement(request);
                                  }

                                }

                              },
                              child: Text('Add Advertisement', style: TextStyle(color: Colors.white,
                                  fontSize: SizeConfig.titleSize * 2.7),),

                            ),
                          );
                        }
                    ),

                  ],),
                ),
              SizedBox(height: 30,)

            ],
          ),
        ),
      ),
    );
  }
  List<DropdownMenuItem<String>> _getCompanyDropDownList(
      List<StoreModel> stores) {
    if (stores.length == 0) {
      return [
        DropdownMenuItem<String>(
          child: Text(''),
        )
      ];
    }
else
   {
     StoreModel? data = null;
     stores.forEach((element) {
       if(element.id == _storeID){
         data = element;
       }
     });
     if(data == null){
       return [
         DropdownMenuItem<String>(
           child: Text(''),
         )
       ];
     }
     else{
       if(data!.companies.isEmpty){
         var items = <DropdownMenuItem<String>>[];
         items.add(DropdownMenuItem<String>(
           value: 'null',
           child: Text(
             'Null',
             style: TextStyle(fontSize: 16,color: Colors.black),
           ),
         ));
         return items;
       }
       else{
         List<CompanyModel> companies = data!.companies;
         var items = <DropdownMenuItem<String>>[];
         if (companies.length == 0) {
           return [
             DropdownMenuItem<String>(
               child: Text(''),
             )
           ];
         }
         items.add(DropdownMenuItem<String>(
           value: 'null',
           child: Text(
             'Null',
             style: TextStyle(fontSize: 16),
           ),
         ));
         companies.forEach((element) {
           items.add(DropdownMenuItem<String>(
             value: element.id,
             child: Text(
               '${element.name}',
               style: TextStyle(fontSize: 16),
             ),
           ));
         });

         print(items);
         return items;
       }
     }

   }


  }

  List<DropdownMenuItem<String>> _getCategoriesDropDownList(
      List<StoreModel> stores) {
    print('stoooooooooooooooooreeeeeees');
    print(stores);
    var items = <DropdownMenuItem<String>>[];
    if (stores.length == 0) {
      return [
        DropdownMenuItem<String>(
          child: Text(''),
        )
      ];
    }
    stores.forEach((element) {
      items.add(DropdownMenuItem<String>(
        value: element.id,
        child: Text(
          '${element.name}',
          style: TextStyle(fontSize: 16),
        ),
      ));
    });
    print(items);
    return items;
  }
}
