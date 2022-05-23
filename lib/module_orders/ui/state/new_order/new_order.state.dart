import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:lottie/lottie.dart';
import 'package:my_kom/module_orders/response/branch.dart';
import 'package:my_kom/module_orders/response/orders/orders_response.dart';
import 'package:my_kom/module_orders/ui/screens/new_order/new_order_screen.dart';

abstract class NewOrderState {
  NewOrderScreenState screenState;

  NewOrderState(this.screenState);

  Widget getUI(BuildContext context);
}

class NewOrderStateInit extends NewOrderState {
  NewOrderStateInit(NewOrderScreenState screenState) : super(screenState);

  @override
  Widget getUI(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}

class NewOrderStateSuccessState extends NewOrderState {
  final _contactFormKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  NewOrderStateSuccessState(NewOrderScreenState screenState)
      : super(screenState);

  @override
  Widget getUI(BuildContext context) {
   // return Container();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: Lottie.asset('assets/animations/on-way.json')),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _contactFormKey,
            autovalidateMode: AutovalidateMode.always,
            child: Flex(
              direction: Axis.vertical,
              children: [
                TextFormField(
                  controller: _phoneController,
                  autofocus: false,
                  validator: (v) {
                    if (v!.isEmpty) {
                      return  'pleaseProvideUsWithTheClientName';// S.of(context).pleaseProvideUsWithTheClientName;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'mohammad',// S.of(context).mohammad,
                    labelText:'deliverTo',// S.of(context).deliverTo,
                  ),
                ),
                TextFormField(
                  controller: _nameController,
                  autofocus: false,
                  validator: (v) {
                    if (v!.isEmpty) {
                      return 'pleaseProvideUsTheClientPhoneNumber';//S
                          // .of(context)
                          // .pleaseProvideUsTheClientPhoneNumber;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'phoneNumber' ,//S.of(context).phoneNumber,
                    labelText:'recipientPhoneNumber',// S.of(context).recipientPhoneNumber,
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            height: 72,
            child: Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: FlatButton(
                    padding: EdgeInsets.all(24),
                    onPressed: () {
                      screenState.addNewOrder(_nameController.text, _phoneController.text);
                    },
                    child: Text(
                     'skip' //S.of(context).skip,
                    ),
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    padding: EdgeInsets.all(24),
                    onPressed: () {
                      if (_contactFormKey.currentState!.validate()) {
                        screenState.addNewOrder(_nameController.text, _phoneController.text);
                      } else {
                        screenState.showSnackBar('pleaseCompleteTheForm');//S.of(context).pleaseCompleteTheForm);
                      }
                    },
                    child: Text(
                    'save'//  S.of(context).save,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class NewOrderStateBranchesLoaded extends NewOrderState {
  late List<Branch> branches;

  final List<String> _paymentMethods = ['online', 'cash'];
  String _selectedPaymentMethod = 'online';
  DateTime orderDate = DateTime.now();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _infoController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  late Branch activeBranch;

  NewOrderStateBranchesLoaded(
      this.branches, LatLng location, NewOrderScreenState screenState)
      : super(screenState) {
    if (location != null) {
      _toController.text = 'fromWhatsapp';//S.current.fromWhatsapp;
    }
  }

  @override
  Widget getUI(context) {
    orderDate ??= DateTime.now();

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
             'newOrder',//   S.of(context).newOrder,
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.grey,
                ),
              ),
            ),
            Card(
              color: Color(0xff2A2E43),
              elevation: 4,
              child: Container(
                height: 340,
                padding: EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    //getBranchSelector(context),
                    //to
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color(0xff454F63),
                      ),
                      child: TextFormField(
                        controller: _toController,
                        autofocus: false,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        decoration: InputDecoration(
                          hintText: 'to',//S.of(context).to,
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              getClipBoardData().then((value) {
                                _toController.text = value!;
                                screenState.refresh();
                              });
                            },
                            icon: Icon(
                              Icons.paste,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    //payment method
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xff454F63),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            hintText:'paymentMethod',// S.of(context).paymentMethod,
                            hintStyle: TextStyle(color: Colors.white),
                            fillColor: Color(0xff454F63),
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          dropdownColor: Color(0xff454F63),
                          value: _selectedPaymentMethod ?? 'cash',
                          items: _paymentMethods
                              .map((String method) => DropdownMenuItem(
                                    value: method.toString(),
                                    child: Text(
                                      method == 'cash'
                                          ? 'cash'//S.of(context).cash
                                          : 'online',//S.of(context).online,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            _selectedPaymentMethod = _paymentMethods.firstWhere(
                                (element) => element.toString() == value);
                            screenState.refresh();
                          },
                        ),
                      ),
                    ),

                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color(0xff454F63),
                      ),
                      child: GestureDetector(
                          onTap: () {
                            DatePicker.showTimePicker(
                              context,
                            ).then((value) {
                              orderDate = value!;
                              screenState.refresh();
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
                                child: Text(
                                  '${orderDate.toIso8601String().substring(11, 16)}',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Icon(
                                  Icons.calendar_today,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            ),

            //info
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: TextFormField(
                  controller: _infoController,
                  autofocus: false,
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                    fontSize: 16,
                  ),
                  maxLines: 8,
                  decoration: InputDecoration(
                    hintText: 'info'//S.of(context).info,
                  ),
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  margin: EdgeInsets.only(top: 30),
                  height: 70,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    color: Colors.grey[100],
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                    'cancel', // S.of(context).cancel,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  margin: EdgeInsets.only(top: 30),
                  height: 70,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      // if (activeBranch == null) {
                      //   screenState
                      //       .showSnackBar('pleaseSelectABranch');//S.of(context).pleaseSelectABranch);
                      //   return;
                      // }
                      screenState.initNewOrder(
                        activeBranch,
                        GeoJson(lat: 0, lon: 0),
                        _infoController.text.trim(),
                        _selectedPaymentMethod ?? _selectedPaymentMethod.trim(),
                        orderDate.toIso8601String(),
                      );
                    },
                    child: Text(
                     'apply',// S.of(context).apply,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 72,
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> getClipBoardData() async {
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    return data!.text;
  }

  // Widget getBranchSelector(BuildContext context) {
  //   if (branches == null) {
  //     return Container(
  //       padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(8),
  //         color: Color(0xff454F63),
  //       ),
  //       child: Text(
  //        'errorLoadingBranches',// S.of(context).errorLoadingBranches,
  //         style: TextStyle(color: Colors.white),
  //       ),
  //     );
  //   } else if (branches.length == 1) {
  //     activeBranch = branches[0];
  //     return Container(
  //       padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(8),
  //         color: Color(0xff454F63),
  //       ),
  //       child: Text(
  //         S.of(context).defaultBranch,
  //         style: TextStyle(color: Colors.white),
  //       ),
  //     );
  //   } else {
  //     return Container(
  //       padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(8),
  //         color: Color(0xff454F63),
  //       ),
  //       child: Theme(
  //         data: Theme.of(context).copyWith(
  //           canvasColor: Color(0xff454F63),
  //         ),
  //         child: DropdownButtonFormField(
  //             decoration: InputDecoration(
  //               fillColor: Color(0xff454F63),
  //               focusColor: Color(0xff454F63),
  //               hintText: 'branch',//S.of(context).branch,
  //               hintStyle: TextStyle(color: Colors.white),
  //             ),
  //             items: branches
  //                 .map((e) => DropdownMenuItem<Branch>(
  //                       value: e,
  //                       child: Text(
  //                        'branch name' ,//'${S.of(context).branch} ${e.brancheName}',
  //                         style: TextStyle(
  //                           color: Colors.white,
  //                         ),
  //                       ),
  //                     ))
  //                 .toList(),
  //             onChanged: (val) {
  //               activeBranch = val;
  //             }),
  //       ),
  //     );
  //   }
  // }
}

class NewOrderStateErrorState extends NewOrderState {
  String errMsg;

  NewOrderStateErrorState(this.errMsg, NewOrderScreenState screenState)
      : super(screenState);

  @override
  Widget getUI(BuildContext context) {
    return Center(
      child: Text('${errMsg}'),
    );
  }
}
