import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom/module_company/models/company_model.dart';
import 'package:my_kom/module_company/service/company_service.dart';

class AllCompanyBloc extends Bloc<AllCompanyEvent, AllCompanyStates> {
  final CompanyService _service = CompanyService();

  AllCompanyBloc() : super(AllCompanyLoadingState()) {
    
    on<AllCompanyEvent>((AllCompanyEvent event, Emitter<AllCompanyStates> emit) {
      if (event is AllCompanyLoadingEvent)
        emit(AllCompanyLoadingState());
      else if (event is AllCompanyErrorEvent){
        emit(AllCompanyErrorState(message: event.message));
      }
      else if (event is AllCompanySuccessEvent) 
      emit(AllCompanySuccessState(data: event.data));
    });
  }


  getAllCompany() async{
    this.add(AllCompanyLoadingEvent());
    _service.getAllCompanies().then((value) {
      if (value != null){
        this.add(AllCompanySuccessEvent(data: value));
      } else{
        this.add(AllCompanyErrorEvent(message: 'Error '));
      }
    });
  }
}

abstract class AllCompanyEvent { }
class AllCompanyInitEvent  extends AllCompanyEvent  {}

class AllCompanySuccessEvent  extends AllCompanyEvent  {
  List<CompanyModel>  data;
  AllCompanySuccessEvent({required this.data});
}

class AllCompanyLoadingEvent  extends AllCompanyEvent  {}

class AllCompanyErrorEvent  extends AllCompanyEvent  {
  String message;
  AllCompanyErrorEvent({required this.message});
}

abstract class AllCompanyStates {}

class AllCompanyInitState extends AllCompanyStates {}

class AllCompanySuccessState extends AllCompanyStates {
     List<CompanyModel>  data;
  AllCompanySuccessState({required this.data});
}

class AllCompanyLoadingState extends AllCompanyStates {}

class AllCompanyErrorState extends AllCompanyStates {
    String message;
  AllCompanyErrorState({required this.message});
}

AllCompanyBloc allCompanyBloc = AllCompanyBloc();