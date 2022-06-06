import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom/module_company/models/company_model.dart';
import 'package:my_kom/module_company/service/company_service.dart';
import 'package:my_kom/module_dashbord/models/store_model.dart';
import 'package:my_kom/module_dashbord/requests/add_company_request.dart';
import 'package:my_kom/module_dashbord/requests/add_product_request.dart';
import 'package:my_kom/module_dashbord/services/DashBoard_services.dart';

class AddProductBloc extends Bloc<AddProductEvent, AddProductStates> {
  final DashBoardService _service = DashBoardService();

  AddProductBloc() : super(AddProductInitState()) {

    on<AddProductEvent>((AddProductEvent event, Emitter<AddProductStates> emit) {
      if (event is AddProductLoadingEvent)
        emit(AddProductLoadingState());
      else if (event is AddProductErrorEvent){
        emit(AddProductErrorState(message: event.message));
      }
      else if (event is AddProductSuccessEvent)
        emit(AddProductSuccessState());
    });
  }


  addProduct(String storeId,String companyId , AddProductRequest request) {
    this.add(AddProductLoadingEvent());
    _service.addProductToCompany(storeId ,companyId, request).then((value){

      if(value){
        this.add(AddProductSuccessEvent( ));
      }else
      {
        this.add(AddProductErrorEvent(message: 'Error In Add Product  !!'));
      }
    });
  }


}

abstract class AddProductEvent { }
class AddProductInitEvent  extends AddProductEvent  {}

class AddProductSuccessEvent  extends AddProductEvent  {
  AddProductSuccessEvent();
}

class AddProductLoadingEvent  extends AddProductEvent  {}

class AddProductErrorEvent  extends AddProductEvent  {
  String message;
  AddProductErrorEvent({required this.message});
}

abstract class AddProductStates {}

class AddProductInitState extends AddProductStates {}

class AddProductSuccessState extends AddProductStates {

     AddProductSuccessState();
}

class AddProductLoadingState extends AddProductStates {}

class AddProductErrorState extends AddProductStates {
    String message;
    AddProductErrorState({required this.message});
}

