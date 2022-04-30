
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom/injecting/components/app.component.dart';
import 'package:my_kom/module_authorization/authorization_module.dart';
import 'package:my_kom/module_home/navigator_module.dart';
import 'package:my_kom/module_info_and_splash/info_splash_module.dart';
import 'package:my_kom/module_info_and_splash/screen/splash_screen.dart';
import 'package:my_kom/module_wrapper/wrapper_module.dart';
import 'package:firebase_core/firebase_core.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final container = await AppComponent.create();
  BlocOverrides.runZoned(
    () {
      return runApp(container.app);
    },
    blocObserver: AppObserver(),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  final WapperModule _wapperModule;
  final InfoSplashModule _infoSplashModule;
  final NavigatorModule _navigatorModule;
  final AuthorizationModule _authorizationModule;
  MyApp(this._wapperModule, this._infoSplashModule, this._navigatorModule,
      this._authorizationModule);

  @override
  Widget build(BuildContext context) {
    Map<String, WidgetBuilder> routes = {};
    routes.addAll(_wapperModule.getRoutes());
    routes.addAll(_infoSplashModule.getRoutes());
    routes.addAll(_navigatorModule.getRoutes());
    routes.addAll(_authorizationModule.getRoutes());

    return FutureBuilder<Widget>(
      initialData: Container(color: Colors.green),
      future: configuratedApp(routes),
      builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
        return snapshot.data!;
      },
    );
  }

  Future<Widget> configuratedApp(Map<String, WidgetBuilder> routes) async {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My Kom',
        routes: routes,
        home: SplashScreen());
  }
}

class AppObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    print(bloc);
    super.onCreate(bloc);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
  }

  @override
  void onClose(BlocBase bloc) {
    print(bloc);
    super.onClose(bloc);
  }
}
