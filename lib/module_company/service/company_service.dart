import 'package:my_kom/module_company/models/company_model.dart';
import 'package:my_kom/module_company/models/product_model.dart';

class CompanyService {
  Future<List<CompanyModel>> getAllCompanies() async {
    await Future.delayed(Duration(seconds: 2));
    return <CompanyModel>[
      CompanyModel(
          id: '1',
          name: 'الوطنية',
          imageUrl: "https://via.placeholder.com/600/92c952"),
      CompanyModel(
          id: '2',
          name: 'العين',
          imageUrl: "https://via.placeholder.com/600/771796"),
      CompanyModel(
          id: '3',
          name: 'ماي دبي',
          imageUrl: "https://via.placeholder.com/600/24f355"),
      CompanyModel(
          id: '4',
          name: 'القطرة',
          imageUrl: "https://via.placeholder.com/600/d32776"),
      CompanyModel(
          id: '5',
          name: 'الوطنية',
          imageUrl: "https://via.placeholder.com/600/f66b97"),
      CompanyModel(
          id: '6',
          name: 'الوطنية',
          imageUrl: "https://via.placeholder.com/600/56a8c2"),
      CompanyModel(
          id: '7',
          name: 'ماي دبي',
          imageUrl: "https://via.placeholder.com/600/b0f7cc"),
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
