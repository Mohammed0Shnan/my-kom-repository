import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom/module_company/models/company_model.dart';
import 'package:my_kom/module_company/models/product_model.dart';
import 'package:my_kom/module_company/service/company_service.dart';
import 'package:my_kom/module_dashbord/models/store_model.dart';
import 'package:my_kom/module_dashbord/requests/add_company_request.dart';
import 'package:my_kom/module_dashbord/services/DashBoard_services.dart';

class StoreProductsCompanyDetailBloc extends Bloc<StoreProductsCompanyDetailEvent, StoreProductsCompanyDetailStates> {
  final DashBoardService _service = DashBoardService();

  StoreProductsCompanyDetailBloc() : super(StoreProductsCompanyDetailLoadingState()) {
    
    on<StoreProductsCompanyDetailEvent>((StoreProductsCompanyDetailEvent event, Emitter<StoreProductsCompanyDetailStates> emit) {
      if (event is StoreProductsCompanyDetailLoadingEvent)
        emit(StoreProductsCompanyDetailLoadingState());
      else if (event is StoreProductsCompanyDetailErrorEvent){
        emit(StoreProductsCompanyDetailErrorState(message: event.message));
      }
      else if (event is StoreProductsCompanyDetailSuccessEvent)
      emit(StoreProductsCompanyDetailSuccessState(data: event.data));
    });
  }


  getDetailProductsCompanyStore(String storeID,String companyId) async{
    this.add(StoreProductsCompanyDetailLoadingEvent());
    _service.productCompanyStoresPublishSubject.listen((value) {
      if(value != null){
        this.add(StoreProductsCompanyDetailSuccessEvent(data: value));

      }else{
        this.add(StoreProductsCompanyDetailErrorEvent(message: 'Error in fetch products !!!'));

      }

    });
    _service.getProductsCompanyStoreDetail(storeID ,companyId );
  }


}

abstract class StoreProductsCompanyDetailEvent { }
class StoreProductsDetailInitEvent  extends StoreProductsCompanyDetailEvent  {}

class StoreProductsCompanyDetailSuccessEvent  extends StoreProductsCompanyDetailEvent  {
  List<ProductModel>  data;
  StoreProductsCompanyDetailSuccessEvent({required this.data});
}

class StoreProductsCompanyDetailLoadingEvent  extends StoreProductsCompanyDetailEvent  {}

class StoreProductsCompanyDetailErrorEvent  extends StoreProductsCompanyDetailEvent  {
  String message;
  StoreProductsCompanyDetailErrorEvent({required this.message});
}

abstract class StoreProductsCompanyDetailStates {}

class StoreProductsCompanyDetailInitState extends StoreProductsCompanyDetailStates {}

class StoreProductsCompanyDetailSuccessState extends StoreProductsCompanyDetailStates {
  List<ProductModel> data;
     StoreProductsCompanyDetailSuccessState({required this.data});
}

class StoreProductsCompanyDetailLoadingState extends StoreProductsCompanyDetailStates {}

class StoreProductsCompanyDetailErrorState extends StoreProductsCompanyDetailStates {
    String message;
    StoreProductsCompanyDetailErrorState({required this.message});
}

