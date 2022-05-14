import 'package:my_kom/module_company/models/company_model.dart';
import 'package:my_kom/module_company/models/product_model.dart';

class CompanyService {
  Future<List<CompanyModel>> getAllCompanies() async {
    await Future.delayed(Duration(seconds: 2));
    return <CompanyModel>[
      CompanyModel(
          id: '1',
          name: 'Al Wataneeai',
          imageUrl: "assets/waten.png"),
      CompanyModel(
          id: '2',
          name: 'Al Ayen',
          imageUrl: "assets/ayen.png"),
      CompanyModel(
          id: '3',
          name: 'May Dubai',
          imageUrl: "assets/may_dubai.png"),
      CompanyModel(
          id: '4',
          name: 'Al Qtrah',
          imageUrl: "assets/qatraa.png"),
      CompanyModel(
          id: '5',
          name: 'Al Yarmook',
          imageUrl: "assets/yarmook.png"),

    ];
  }

  Future<List<ProductModel>> getCompanyProducts(String company_id) async {
    await Future.delayed(Duration(seconds: 2));
    return <ProductModel>[
      ProductModel(
          id: '1',
          title: 'الوطنية 200 مل',
          imageUrl: "https://via.placeholder.com/600/92c952",
          description: 'تمتع بمذاق ماء العين الصافي و المتوازن والصحي.......',
          old_price: 100.5,
          price: 100.0,
          quantity: 5),
      ProductModel(
          id: '2',
          title: 'الوطنية 200 مل',
          imageUrl: "https://via.placeholder.com/600/771796",
          description: 'تمتع بمذاق ماء العين الصافي و المتوازن والصحي.......',
          old_price: null,
          price: 100.0,
          quantity: 5),
      ProductModel(
          id: '3',
          title: 'الوطنية 200 مل',
          imageUrl:  "https://via.placeholder.com/600/24f355",
          description: 'تمتع بمذاق ماء العين الصافي و المتوازن والصحي.......',
          old_price: 100.5,
          price: 100.0,
          quantity: 5),
      ProductModel(
          id: '4',
          title: 'الوطنية 200 مل',
          imageUrl: "https://via.placeholder.com/600/d32776",
          description: 'تمتع بمذاق ماء العين الصافي و المتوازن والصحي.......',
          old_price: null,
          price: 100.0,
          quantity: 5),
      ProductModel(
          id: '5',
          title: 'الوطنية 200 مل',
          imageUrl: "https://via.placeholder.com/600/f66b97",
          description: 'تمتع بمذاق ماء العين الصافي و المتوازن والصحي.......',
          old_price: null,
          price: 100.0,
          quantity: 5),
      ProductModel(
          id: '6',
          title: 'الوطنية 200 مل',
          imageUrl: "https://via.placeholder.com/600/56a8c2",
          description: 'تمتع بمذاق ماء العين الصافي و المتوازن والصحي.......',
          old_price: 100.5,
          price: 100.0,
          quantity: 5),
      ProductModel(
          id: '7',
          title: 'الوطنية 200 مل',
          imageUrl: "https://via.placeholder.com/600/92c952",
          description: 'تمتع بمذاق ماء العين الصافي و المتوازن والصحي.......',
          old_price: 100.5,
          price: 100.0,
          quantity: 5),
    ];
  }
}
