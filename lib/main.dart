import 'package:bot_toast/bot_toast.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:neer/bloc/waitTimeBloc.dart';
import 'package:neer/providers/authProvider.dart';
import 'package:neer/providers/rainwaterDataProvider.dart';
import 'package:neer/ui/firstPageDecider.dart';

import 'bloc/connectivityBloc.dart';
import 'globals/constants.dart' as globals;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var connection = await Connectivity().checkConnectivity();
  globals.connectivityBloc = ConnectivityBloc(connection);
  globals.phoneAuthProvider = MyPhoneAuthProvider();
  globals.rainWaterDataProvider = RainWaterDataProvider();
  globals.waitingTimeBloc = WaitingTimeBloc();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // globals.navigatorState = GlobalKey<NavigatorState>();
    return MaterialApp(
      title: 'Neer',
      builder: BotToastInit(), //1. call BotToastInit
      navigatorObservers: [BotToastNavigatorObserver()],
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
      home: FirstPageDecider(),
    );
  }
}
