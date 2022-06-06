import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom/module_company/models/company_model.dart';
import 'package:my_kom/module_company/service/company_service.dart';
import 'package:my_kom/module_dashbord/models/store_model.dart';
import 'package:my_kom/module_dashbord/requests/add_company_request.dart';
import 'package:my_kom/module_dashbord/services/DashBoard_services.dart';

class StoreCompanyDetailBloc extends Bloc<StoreCompanyDetailEvent, StoreCompanyDetailStates> {
  final DashBoardService _service = DashBoardService();

  StoreCompanyDetailBloc() : super(StoreCompanyDetailLoadingState()) {
    
    on<StoreCompanyDetailEvent>((StoreCompanyDetailEvent event, Emitter<StoreCompanyDetailStates> emit) {
      if (event is StoreCompanyDetailLoadingEvent)
        emit(StoreCompanyDetailLoadingState());
      else if (event is StoreCompanyDetailErrorEvent){
        emit(StoreCompanyDetailErrorState(message: event.message));
      }
      else if (event is StoreCompanyDetailSuccessEvent)
      emit(StoreCompanyDetailSuccessState(data: event.data));
    });
  }


  getDetailCompanyStore(String storeID) async{
    this.add(StoreCompanyDetailLoadingEvent());
    _service.companyStoresPublishSubject.listen((value) {
      if(value != null){
        this.add(StoreCompanyDetailSuccessEvent(data: value));

      }else{
        this.add(StoreCompanyDetailErrorEvent(message: 'Error in fetch companies !!!'));

      }

    });
    _service.getCompaniesStoreDetail(storeID);
  }


}

abstract class StoreCompanyDetailEvent { }
class StoreDetailInitEvent  extends StoreCompanyDetailEvent  {}

class StoreCompanyDetailSuccessEvent  extends StoreCompanyDetailEvent  {
  List<CompanyModel>  data;
  StoreCompanyDetailSuccessEvent({required this.data});
}

class StoreCompanyDetailLoadingEvent  extends StoreCompanyDetailEvent  {}

class StoreCompanyDetailErrorEvent  extends StoreCompanyDetailEvent  {
  String message;
  StoreCompanyDetailErrorEvent({required this.message});
}

abstract class StoreCompanyDetailStates {}

class StoreCompanyDetailInitState extends StoreCompanyDetailStates {}

class StoreCompanyDetailSuccessState extends StoreCompanyDetailStates {
  List<CompanyModel> data;
     StoreCompanyDetailSuccessState({required this.data});
}

class StoreCompanyDetailLoadingState extends StoreCompanyDetailStates {}

class StoreCompanyDetailErrorState extends StoreCompanyDetailStates {
    String message;
    StoreCompanyDetailErrorState({required this.message});
}

