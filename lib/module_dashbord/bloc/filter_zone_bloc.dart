import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom/module_dashbord/models/store_model.dart';
import 'package:my_kom/module_dashbord/models/zone_models.dart';
import 'package:my_kom/module_home/models/search_model.dart';

class FilterZoneCubit extends Cubit<FilterZoneCubitState> {
  FilterZoneCubit() : super(FilterZoneCubitState(searchModel:SearchModel(storeId:'tYxGSb6QQEn3bPOeHr6X' , zoneName: 'zone 1')));

  setFilter(SearchModel searchModel){
   return emit(FilterZoneCubitState(searchModel: searchModel));
  }
}

class  FilterZoneCubitState {
  final SearchModel searchModel;
  FilterZoneCubitState({required this.searchModel});
}
