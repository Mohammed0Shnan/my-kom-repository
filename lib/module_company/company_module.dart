import 'package:my_kom/abstracts/module/my_module.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_kom/module_company/company_routes.dart';
import 'package:my_kom/module_company/screen/company_products_screen.dart';

class CompanyModule extends MyModule {
   final CompanyProductScreen _companyProductScreen  ;

   CompanyModule(this._companyProductScreen);

  @override
  Map<String, WidgetBuilder> getRoutes() {
    return {
       CompanyRoutes.COMPANY_PRODUCTS_SCREEN : (context) => _companyProductScreen,
    };
  }
}
