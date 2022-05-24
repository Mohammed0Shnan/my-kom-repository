import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_kom/module_shoping/models/card_model.dart';



class CardServices{
  static const USER_ID = 'userId';

  String collection = "cards";
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future createCard({required String id,required String userId, required int exp_month,required  int exp_year,required int last4,required String card_number})async{
  try{
    await _firestore.collection(collection).doc(id).set({
      "id": id,
      "card_number":card_number,
      "userId": userId,
      "exp_month": exp_month,
      "exp_year":exp_year,
      "last4": last4
    });
  }catch(e){
    throw e;

  }

  }

  void updateDetails(Map<String, dynamic> values){
    _firestore.collection(collection).doc(values["id"]).update(values);
  }

  Future<void> deleteCard(Map<String, dynamic> values)async{
    try{
     await _firestore.collection(collection).doc(values["id"]).delete();

    }catch(e){
      throw e;
    }
  }

  Future<List<CardModel>> getPurchaseHistory({required String customerId})async =>
      _firestore.collection(collection).where(USER_ID, isEqualTo: customerId).get().then((result){
        List<CardModel> listOfCards = [];

        result.docs.map((item){
          listOfCards.add(CardModel.fromSnapshot(item));
        });
        return listOfCards;
      });

  Future<List<CardModel>> getCards({required String userId})async {
    return await _firestore.collection(collection).where(USER_ID, isEqualTo: userId).get().then((result){
      List<CardModel> cards = [];
      print("=== RESULT SIZE ${result.docs.length}");
      for(DocumentSnapshot item in result.docs){
        cards.add(CardModel.fromSnapshot(item));
        //print(" CARDS ${cards.length}");
      }
      return cards;

    });

  }

}