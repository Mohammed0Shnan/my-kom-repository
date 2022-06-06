import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_kom/module_company/models/company_model.dart';
import 'package:my_kom/module_company/models/product_model.dart';
import 'package:my_kom/module_dashbord/models/store_model.dart';
import 'package:my_kom/module_dashbord/response/company_store_detail_response.dart';
import 'package:rxdart/rxdart.dart';

class CompanyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final PublishSubject<List<ProductModel>?> recommendedProductsPublishSubject =
  new PublishSubject();

  final PublishSubject<List<CompanyModel>?> companyStoresPublishSubject =
  new PublishSubject();

  final PublishSubject<List<ProductModel>?> productCompanyStoresPublishSubject =
  new PublishSubject();

  Future<void> getAllCompanies(String storeId) async {
    try {
      /// store detail
      await _firestore
          .collection('companies').where('store_id',isEqualTo: storeId)
          .snapshots()
          .forEach((element) {
        List<CompanyModel> companyList = [];
        element.docs.forEach((element) {
          Map<String, dynamic> map = element.data() as Map<String, dynamic>;
          map['id'] = element.id;

          CompanyStoreDetailResponse res = CompanyStoreDetailResponse.fromJsom(
              map);
          CompanyModel companyModel = CompanyModel(
              id: res.id, name: res.name, imageUrl: res.imageUrl,description:res.description );
          companyModel.storeId = res.storeId;
          companyList.add(companyModel);
        });
        companyStoresPublishSubject.add(companyList);
      });
    }catch(e){
      companyStoresPublishSubject.add(null);
    }



    // return <CompanyModel>[
    //   CompanyModel(
    //       id: '1',
    //       name: 'الوطنية',
    //       imageUrl: "assets/waten.png",
    //   description: '',
    //
    //   ),
    //   CompanyModel(
    //       id: '2',
    //       name: 'العين',
    //       imageUrl: "assets/ayen.png",
    //       description: ''),
    //   CompanyModel(
    //       id: '3',
    //       name: 'ماي دبي',
    //       imageUrl: "assets/may_dubai.png",
    //       description: ''),
    //   CompanyModel(
    //       id: '4',
    //       name: 'القطرة',
    //       imageUrl: "assets/qatraa.png",
    //       description: ''),
    //   CompanyModel(
    //       id: '5',
    //       name: 'اليرموك',
    //       imageUrl: "assets/yarmook.png",
    //       description: ''),

   // ];
  }

  Future<void> getCompanyProducts(String company_id) async {
    try {
      /// store detail
      await _firestore.collection('products').where('company_id',isEqualTo: company_id)
          .snapshots()
          .forEach((element) {
        List<ProductModel> productsList = [];
        element.docs.forEach((element) {

          Map<String, dynamic> map = element.data() as Map<String, dynamic>;
          print(map);
          map['id'] = element.id;
          ProductModel productModel = ProductModel.fromJson(map);
          productsList.add(productModel);
        });
        productCompanyStoresPublishSubject.add(productsList);
      });
    }catch(e){
      productCompanyStoresPublishSubject.add(null);

    }
    // return <ProductModel>[
    //   ProductModel(
    //       id: '1',
    //       title: 'Al Wataneia 200 ml',
    //       imageUrl: "assets/product1.png",
    //       description: 'Enjoy the pure, balanced and healthy taste of Ain water Enjoy the pure, balanced and healthy taste of Ain Water Enjoy the pure, balanced and healthy taste of Ain Water Enjoy the pure, balanced and healthy taste of Ain Water Enjoy the pure, balanced and healthy taste of Ain Water',
    //       old_price: 100.5,
    //       price: 100.0,
    //       quantity: 5,
    //     isRecommended: true,
    //     specifications: [
    //       SpecificationsModel(name: 'potassium', value: '12 g'),
    //       SpecificationsModel(name: 'sodium', value: '12 g'),
    //       SpecificationsModel(name: 'iron', value: '12 g'),
    //     ]
    //
    //
    //   ),
    //   ProductModel(
    //       id: '2',
    //       title: 'Al Wataneia 200 ml',
    //       imageUrl: "assets/product2.png",
    //       description: 'Enjoy the pure, balanced and healthy taste of Ain water Enjoy the pure, balanced and healthy taste of Ain Water Enjoy the pure, balanced and healthy taste of Ain Water Enjoy the pure, balanced and healthy taste of Ain Water Enjoy the pure, balanced and healthy taste of Ain Water',
    //       old_price: null,
    //       isRecommended: true,
    //
    //       price: 100.0,
    //       quantity: 5,
    //       specifications: [
    //         SpecificationsModel(name: 'potassium', value: '12 g'),
    //         SpecificationsModel(name: 'sodium', value: '12 g'),
    //         SpecificationsModel(name: 'iron', value: '12 g'),
    //       ]
    //   ),
    //   ProductModel(
    //       id: '3',
    //       title: 'Al Wataneia 200 ml',
    //       imageUrl:  "assets/produt3.png",
    //       description: 'Enjoy the pure, balanced and healthy taste of Ain water Enjoy the pure, balanced and healthy taste of Ain Water Enjoy the pure, balanced and healthy taste of Ain Water Enjoy the pure, balanced and healthy taste of Ain Water Enjoy the pure, balanced and healthy taste of Ain Water',
    //       old_price: 100.5,
    //       price: 100.0,
    //       quantity: 5,
    //       isRecommended: false,
    //
    //       specifications: [
    //         SpecificationsModel(name: 'potassium', value: '12 g'),
    //         SpecificationsModel(name: 'sodium', value: '12 g'),
    //         SpecificationsModel(name: 'iron', value: '12 g'),
    //       ]
    //   ),
    //   ProductModel(
    //       id: '4',
    //       title: 'Al Wataneia 200 ml',
    //       imageUrl: "assets/product4.png",
    //       description: 'Enjoy the pure, balanced and healthy taste of Ain water Enjoy the pure, balanced and healthy taste of Ain Water Enjoy the pure, balanced and healthy taste of Ain Water Enjoy the pure, balanced and healthy taste of Ain Water Enjoy the pure, balanced and healthy taste of Ain Water',
    //       old_price: null,
    //       price: 100.0,
    //       quantity: 5,
    //       isRecommended: false,
    //
    //       specifications: [
    //         SpecificationsModel(name: 'potassium', value: '12 g'),
    //         SpecificationsModel(name: 'sodium', value: '12 g'),
    //         SpecificationsModel(name: 'iron', value: '12 g'),
    //       ]
    //   ),
    //
    // ];
  }

 Future<void> getRecommendedProducts(String storeId)async {
     try {
       await _firestore
           .collection('companies').where('store_id',isEqualTo: storeId)
           .snapshots()
           .forEach((element) {
             List<ProductModel> products=[];

         List<String> companyList = [];
         element.docs.forEach((element) {
           companyList.add(element.id);
         });

         _firestore
             .collection('products').where('company_id' , whereIn:companyList ).snapshots().forEach((pro) {
           pro.docs.forEach((p) {

             Map<String, dynamic> map = p.data() as Map<String, dynamic>;
             print(map);
             map['id'] = p.id;
             ProductModel productModel = ProductModel.fromJson(map);
             products.add(productModel);
           });
           recommendedProductsPublishSubject.add(products);

         });
       });
     }catch(e){
       recommendedProductsPublishSubject.add(null);

     }


  }


}
