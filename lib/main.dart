import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:neer/providers/phoneAuthProvider.dart';
import 'package:neer/providers/rainwaterDataProvider.dart';
import 'package:neer/ui/job_route.dart';

import 'bloc/connectivityBloc.dart';
import 'globals/constants.dart' as globals;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var connection = await Connectivity().checkConnectivity();
  globals.connectivityBloc = ConnectivityBloc(connection);
  globals.phoneAuthProvider = PhoneAuthProvider();
  globals.rainWaterDataProvider = RainWaterDataProvider();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // globals.navigatorState = GlobalKey<NavigatorState>();
    return MaterialApp(
      title: 'Neer',
      debugShowCheckedModeBanner: false,
      // navigatorKey: globals.navigatorState,
      theme: ThemeData(
          fontFamily: "Rubik",
          primarySwatch: Colors.grey,
          // buttonColor: Colors.black,
          buttonTheme: ButtonThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            buttonColor: Colors.black,
            height: 40.0,
            minWidth: 120,
          ),
          primaryColor: Colors.black,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          platform: TargetPlatform.iOS,
          textTheme: TextTheme(
              button: TextStyle(
            color: Colors.white,
          )),
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
          })),
      themeMode: ThemeMode.dark,
      home: JobRoute(), //FirstPageDecider(),
    );
  }
}
