

import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentMethodeNumberBloc extends Cubit<PaymentState> {

  PaymentMethodeNumberBloc() : super(PaymentState(index: 0 , paymentMethodeCreditGroupValue: 0));
  
  addOne() => emit(PaymentState(index: state.index+1 , paymentMethodeCreditGroupValue: state.paymentMethodeCreditGroupValue));
  removeOne() => emit(PaymentState(index: state.index-1 , paymentMethodeCreditGroupValue: state.paymentMethodeCreditGroupValue));
  clear()=> emit(PaymentState(index: 0 , paymentMethodeCreditGroupValue: 0));
  changeSelect(int value){
   emit(PaymentState(index: state.index , paymentMethodeCreditGroupValue: value));
  }

}
class PaymentState{
 int paymentMethodeCreditGroupValue;
 int index;
 PaymentState({required this.index , required this.paymentMethodeCreditGroupValue});
}