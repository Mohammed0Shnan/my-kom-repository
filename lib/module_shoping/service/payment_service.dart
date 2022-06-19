import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:stripe_payment/stripe_payment.dart';


class PaymentService {
final int amount;
final String url;

PaymentService({ this.amount = 10, this.url= ''});

static init(){
StripePayment.setOptions(
  StripeOptions(publishableKey: 'pk_test_51L31qjEOejDdCXYkIPhMYzZOWozqLu17OdSuRL6TmnUu64DxYmtgSD6jE5xwhI0VlOtDLvo6scxTb0UIJyVyLXfl00qapSV3TY',
  )
);
}

Future<PaymentMethod> createPaymentMethod()async{
  print('the transaction amount to be charged is : $amount ');
  PaymentMethod paymentMethod =await StripePayment.paymentRequestWithCardForm(
    CardFormPaymentRequest()
  );
  return paymentMethod;
}

Future<void> processPayment(String paymentMethodID)async{
  final _client = Dio(BaseOptions(
    sendTimeout: 60000,
    receiveTimeout: 60000,
    connectTimeout: 60000,
  ));
  final Response response = await  _client.post('$url?amount=$amount&currency=USD&paym=${paymentMethodID}');
  if(response.data != 'error'){
    final paymentInent = jsonDecode(response.data);
    final status = paymentInent['paymentIntent']['status'];
    if(status == 'succeeded'){
      print('Payment complete. ${paymentInent['paymentIntent']['amount'].toString()}');
    }
    else{
      print('Payment failed.');
    }
  }
}

}
