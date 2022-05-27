import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/module_authorization/authorization_routes.dart';
import 'package:my_kom/module_authorization/requests/register_request.dart';
import 'package:my_kom/module_authorization/service/auth_service.dart';
import 'package:my_kom/module_map/map_routes.dart';
import 'package:my_kom/module_map/models/address_model.dart';
import 'package:my_kom/module_profile/bloc/profile_bloc.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileBloc profileBloc = ProfileBloc();

  final TextEditingController _profileUserNameController = TextEditingController();
  final TextEditingController _profileAddressController = TextEditingController();
  final TextEditingController _profilePhoneController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    profileBloc.getMyProfile();
  }

  bool isEditingProfile = false;
 late ProfileRequest? request ;
  late AddressModel addressModel ;
  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);

    return Stack(
      children: [
        Container(
          color: Colors.grey.shade50,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: BlocConsumer<ProfileBloc, ProfileStates>(
            bloc: profileBloc,
            listener: (context,state){
              if(state is ProfileSuccessState){
                _profileUserNameController.text = state.data.userName;
                _profileAddressController.text = state.data.address.description;
                _profilePhoneController.text = state.data.phone;
                addressModel = state.data.address;
                if(state.isEditState){
                  isEditingProfile = ! isEditingProfile;
                }

              }
            },
            builder: (context,state) {

            if(state is ProfileErrorState){
                return Container(
                  height: 40,
                  width: 40,
                  child: Center(
                    child: Text('Error'),
                  ),
                );
              }
                else if(state is ProfileSuccessState) {

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 30),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            icon: Icon( Icons.arrow_back , color: Colors.black54,),
                           ),
                          IconButton(
                              onPressed: (){
                                if(!isEditingProfile){
                                  isEditingProfile = !isEditingProfile;
                                  setState((){});
                                }else{
                                  request = ProfileRequest
                                    (userName: _profileUserNameController.text.trim(), address:

                                  addressModel
                                      , phone: _profilePhoneController.text.trim());
                                profileBloc.editProfile(request!);
                                }


                              },
                              icon: Icon(!isEditingProfile? Icons.edit: Icons.save , color: Colors.black54,),
                          ),

                        ],
                      ),
                      SizedBox(height: 5,),
                      Text('My\nProfile',textAlign: TextAlign.center,style: TextStyle(
                        color: Colors.black54,
                        fontSize: 30,
                        fontWeight: FontWeight.bold


                      ),),
                      SizedBox(height: 20,),
                      Container(
                        height: SizeConfig.screenHeight * 0.4,
                        child: LayoutBuilder(
                          builder: (context,constraints){
                            double innerHeight  = constraints.maxHeight;
                            double innerWidth  = constraints.maxWidth;
                            return Stack(
                              fit:StackFit.expand,
                              alignment: Alignment.center,
                              children: [
                                Positioned(left: 0,
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  alignment: Alignment.center,
                                  height:innerHeight * 0.65,
                                width:innerWidth ,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(color: Colors.black12,
                                    blurRadius: 5
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(30)
                                ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [

                                    SizedBox(
                                      height: 70,
                                    ),
                                    Center(
                                      child: TextFormField(
                                        textAlign: TextAlign.center,
                                        controller: _profileUserNameController,

                                       style: TextStyle(

                                          fontSize: 27,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[700]
                                      ),

                                        decoration: InputDecoration(
                                          suffixIcon: (!isEditingProfile)?null:Icon(Icons.edit,color: Colors.black,),
                                            border: InputBorder.none,
                                          //S.of(context).name,
                                        ),
                                        textInputAction: TextInputAction.next,
                                        // Move focus to next
                                      ),
                                    ),

                                    SizedBox(height: 8,),
                                    Text(state.data.userRole.name.toString(),style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[700]
                                    )),

                                  ],),
                                ),
                                ),
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  right: 0,
                                  child: Center(
                                    child: Container(
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(color: Colors.black12,
                                              blurRadius: 5
                                          )
                                        ],
                                      ),
                                      child: Image.asset('assets/profile.png',
                                      fit: BoxFit.fitWidth,
                                        width: innerWidth *0.45,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 25,),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        height: SizeConfig.screenHeight * 0.55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.black12,
                                blurRadius: 5
                            )
                          ],
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 20,),

                            Text('My Information',style:  TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600]
                            ),),
                            Divider(
                              thickness: 2.5,
                            ),
                            SizedBox(height: 10,),

                            Container(
                              height: SizeConfig.screenHeight *0.17,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(

                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.grey.shade200
                              ),
                              child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('My Address',style:  TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[600]
                                  ),),
                                  Row(
                                    children: [
                                      Icon(Icons.location_on , color: ColorsConst.mainColor,),
                                      SizedBox(width: 10,),
                                      Expanded(
                                       child: Container(
                                         child: TextFormField(
                                           readOnly: true,
                                            controller: _profileAddressController,
                                           maxLines: 2,
                                           style:  TextStyle(
                                             fontSize: 16,

                                             fontWeight: FontWeight.bold,
                                             color: Colors.grey[600]
                                         ),
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              //S.of(context).name,
                                            ),
                                            textInputAction: TextInputAction.next,
                                            // Move focus to next
                                          ),
                                       ),

                                      ),
                                      if(isEditingProfile)
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.pushNamed(
                                                context, MapRoutes.MAP_SCREEN)
                                                .then((value) {
                                              if (value != null) {
                                                addressModel = (value as AddressModel);
                                                _profileAddressController.text =
                                                    addressModel.description;
                                                addressModel = value;

                                              }

                                            });
                                          },
                                          child: Container(
                                            width: SizeConfig.heightMulti * 6,
                                            height: SizeConfig.heightMulti * 6,
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
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 10,),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),

                              height: SizeConfig.screenHeight *0.20,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.grey.shade200
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,                            children: [
                                  Text('Email And Phone',style:  TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[600]
                                  ),),
                                SizedBox(height: 10,),

                                Row(
                                    children: [
                                      Icon(Icons.email , color: ColorsConst.mainColor),
                                      SizedBox(width: 10,),
                                      Text(state.data.email,style:  TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[600]
                                      ),),

                                    ],
                                  ),
                                  SizedBox(height: 5,),
                                  Row(
                                    children: [
                                      Icon(Icons.phone , color: ColorsConst.mainColor),
                                      SizedBox(width: 10,),
                                      Text(state.data.phone,style:  TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[600]
                                      ),),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
                } else
              return Center(
                child: Container(
                  height: 40,
                  width: 40,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            }
          ),
        )
      ],
    );
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: Colors.grey,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: ListView(
              shrinkWrap: true,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 40, left: 20),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_outlined,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),

                _getHeader(context),
                SizedBox(
                  height: 35,
                ),
                ListTile(
                  title: Text(
                    'Status',
                    style: TextStyle(
                        color: Colors.brown.shade800,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        letterSpacing: 1),
                  ),
                  subtitle: Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Text(
                        // profileModel.status,
                        'the user status',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(
                    color: Colors.brown.shade600,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ListTile(
                  title: Text(
                    'Description',
                    style: TextStyle(
                        color: Colors.brown.shade800,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        letterSpacing: 1),
                  ),
                  subtitle: Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Text(
                        // profileModel.description,
                        'the user description information information and summry',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(
                    color: Colors.brown.shade600,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _getHeader(context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: Stack(alignment: Alignment.center, children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  height: 130,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image:
                    DecorationImage(image: AssetImage('assets/person.png')),
                  ),

                  // widget.request == null

                  //     ? Container()

                  //     : widget.request.image == null

                  //         ? Container()

                  //         : Container(

                  //             height: 96,

                  //             decoration: BoxDecoration(

                  //               shape: BoxShape.circle,

                  //               image: DecorationImage(

                  //                   image: NetworkImage(

                  //                       widget.request.image.contains('http')

                  //                           ? widget.request.image

                  //                           : Urls.IMAGES_ROOT +

                  //                               widget.request.image),

                  //                   fit: BoxFit.contain,

                  //                   onError: (e, s) {

                  //                     return AssetImage(

                  //                         'assets/images/logo.png');

                  //                   }),

                  //             ),

                  //           )
                ),
                Positioned(
                    left: -5,
                    bottom: 20,
                    child: IconButton(
                        icon: Icon(
                          Icons.camera,
                          size: 40,
                        ),
                        onPressed: () {
                          // ImagePicker()
                          //     .getImage(source: ImageSource.gallery)
                          //     .then((value) {
                          //   onImageChange(value.path);
                            // widget.onImageUpload(

                            //   ProfileRequest(

                            //     userName: _firstNameController.text,

                            //     lastName: _lastNameController.text,

                            //     phone: _phoneController.text,

                            //     location: _locationController.text,

                            //     image: value.path,

                            //   ),

                            // );
                          })
                        )
              ]),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Navigator.of(context)
                    //     .pushNamed(ProfileRoutes.EDIT_PROFILE_SCREEN);
                  }),
              Text(
                //profileModel.name,
                'user name',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

