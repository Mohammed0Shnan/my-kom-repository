import 'package:my_kom/module_company/models/company_model.dart';
import 'package:my_kom/module_company/models/product_model.dart';

class CompanyService {
  Future<List<CompanyModel>> getAllCompanies() async {
    await Future.delayed(Duration(milliseconds: 200));
    return <CompanyModel>[
      CompanyModel(
          id: '1',
          name: 'الوطنية',
          imageUrl: "assets/waten.png"),
      CompanyModel(
          id: '2',
          name: 'العين',
          imageUrl: "assets/ayen.png"),
      CompanyModel(
          id: '3',
          name: 'ماي دبي',
          imageUrl: "assets/may_dubai.png"),
      CompanyModel(
          id: '4',
          name: 'القطرة',
          imageUrl: "assets/qatraa.png"),
      CompanyModel(
          id: '5',
          name: 'اليرموك',
          imageUrl: "assets/yarmook.png"),

    ];
  }

  Future<List<ProductModel>> getCompanyProducts(String company_id) async {
    await Future.delayed(Duration(milliseconds: 200));
    return <ProductModel>[
      ProductModel(
          id: '1',
          title: 'Al Wataneia 200 ml',
          imageUrl: "assets/product1.png",
          description: 'Enjoy the pure, balanced and healthy taste of Ain water Enjoy the pure, balanced and healthy taste of Ain Water Enjoy the pure, balanced and healthy taste of Ain Water Enjoy the pure, balanced and healthy taste of Ain Water Enjoy the pure, balanced and healthy taste of Ain Water',
          old_price: 100.5,
          price: 100.0,
          quantity: 5,
        specifications: [
          SpecificationsModel(name: 'potassium', value: '12 g'),
          SpecificationsModel(name: 'sodium', value: '12 g'),
          SpecificationsModel(name: 'iron', value: '12 g'),
        ]


      ),
      ProductModel(
          id: '2',
          title: 'Al Wataneia 200 ml',
          imageUrl: "assets/product2.png",
          description: 'Enjoy the pure, balanced and healthy taste of Ain water Enjoy the pure, balanced and healthy taste of Ain Water Enjoy the pure, balanced and healthy taste of Ain Water Enjoy the pure, balanced and healthy taste of Ain Water Enjoy the pure, balanced and healthy taste of Ain Water',
          old_price: null,
          price: 100.0,
          quantity: 5,
          specifications: [
            SpecificationsModel(name: 'potassium', value: '12 g'),
            SpecificationsModel(name: 'sodium', value: '12 g'),
            SpecificationsModel(name: 'iron', value: '12 g'),
          ]
      ),
      ProductModel(
          id: '3',
          title: 'Al Wataneia 200 ml',
          imageUrl:  "assets/produt3.png",
          description: 'Enjoy the pure, balanced and healthy taste of Ain water Enjoy the pure, balanced and healthy taste of Ain Water Enjoy the pure, balanced and healthy taste of Ain Water Enjoy the pure, balanced and healthy taste of Ain Water Enjoy the pure, balanced and healthy taste of Ain Water',
          old_price: 100.5,
          price: 100.0,
          quantity: 5,
          specifications: [
            SpecificationsModel(name: 'potassium', value: '12 g'),
            SpecificationsModel(name: 'sodium', value: '12 g'),
            SpecificationsModel(name: 'iron', value: '12 g'),
          ]
      ),
      ProductModel(
          id: '4',
          title: 'Al Wataneia 200 ml',
          imageUrl: "assets/product4.png",
          description: 'Enjoy the pure, balanced and healthy taste of Ain water Enjoy the pure, balanced and healthy taste of Ain Water Enjoy the pure, balanced and healthy taste of Ain Water Enjoy the pure, balanced and healthy taste of Ain Water Enjoy the pure, balanced and healthy taste of Ain Water',
          old_price: null,
          price: 100.0,
          quantity: 5,
          specifications: [
            SpecificationsModel(name: 'potassium', value: '12 g'),
            SpecificationsModel(name: 'sodium', value: '12 g'),
            SpecificationsModel(name: 'iron', value: '12 g'),
          ]
      ),

    ];
  }
}
