import 'package:my_kom/abstracts/module/my_module.dart';
import 'package:my_kom/module_wrapper/wrapper.dart';
import 'package:my_kom/module_wrapper/wrapper_route.dart';
import 'package:flutter/cupertino.dart';



class WapperModule extends MyModule{
  final Wrapper _wrapper;
  WapperModule(this._wrapper);

  @override
  Map<String , WidgetBuilder> getRoutes()=>{
    WrapperRoutes.WRAPPER_ROUTE:(context)=> _wrapper
  };
  
} 