import 'package:flutter_bloc/flutter_bloc.dart';

class OpenCloseShopBloc extends Cubit<bool> {
  OpenCloseShopBloc() : super(true) ;
  openShop() => emit(false);
  closeShop() => emit(true);
}
OpenCloseShopBloc openCloseShopBloc = OpenCloseShopBloc();