class CardModel{
 late int id;
 late String cardNumber;
 late String expiryDate ;
 late String cardHolderName ;
 late String cvvCode ;
 CardModel({required this.id,required this.cardHolderName , required this.cardNumber ,required this.cvvCode ,required this.expiryDate ,});
}