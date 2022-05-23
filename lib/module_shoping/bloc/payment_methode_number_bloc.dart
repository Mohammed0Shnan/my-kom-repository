

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom/module_shoping/models/card_model.dart';

class PaymentMethodeNumberBloc extends Cubit<PaymentState> {

  PaymentMethodeNumberBloc() : super(PaymentState(cards: [] , paymentMethodeCreditGroupValue: 0));
  
  addOne(CardModel card){

  PaymentState newState =  PaymentState(cards: List.from(state.cards)..add(card), paymentMethodeCreditGroupValue: state.paymentMethodeCreditGroupValue);
return emit(newState);
  }
  removeOne(CardModel card) {
    PaymentState newState =  PaymentState(cards: List.from(state.cards)..remove(card), paymentMethodeCreditGroupValue: state.paymentMethodeCreditGroupValue);
    return emit(newState);
  }
  clear()=> emit(PaymentState(cards: [] , paymentMethodeCreditGroupValue: 0));
  changeSelect(int value){
  return emit(PaymentState(cards: state.cards , paymentMethodeCreditGroupValue: value));
  }

}
class PaymentState{
 int paymentMethodeCreditGroupValue;
  List<CardModel> cards;
 PaymentState({required this.cards , required this.paymentMethodeCreditGroupValue});
}