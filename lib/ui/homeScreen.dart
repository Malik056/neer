import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neer/bloc/openRequestsBloc.dart';
import 'package:neer/globals/constants.dart' as globals;
import 'package:neer/ui/jobRoute.dart';
import 'package:neer/ui/rainWater.dart';
import 'package:neer/ui/userProfile.dart';

class HomeScreenRoute extends StatefulWidget {
  static String name = "HomeScreenRoute";

  @override
  State<StatefulWidget> createState() {
    return HomeScreenRouteState();
  }
}

class HomeScreenRouteState extends State<HomeScreenRoute> {
  int selectedIndex = 0;
  bool exitApp = false;
  @override
  void initState() {
    if (globals.openRequestBloc == null) {
      globals.openRequestBloc = OpenRequestBloc();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TextTheme textTheme = Theme.of(context).textTheme;
    return WillPopScope(
      onWillPop: () async {
        if (selectedIndex != 0) {
          setState(() {
            selectedIndex = 0;
          });
          return false;
        } else {
          if (exitApp) {
            return true;
          }
          exitApp = true;
          Future.delayed(
              Duration(
                seconds: 2,
              ), () {
            exitApp = false;
          });
          return false;
        }
      },
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            selectedIndex = index;
            setState(() {});
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          currentIndex: selectedIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.work),
              title: Text('Jobs'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Profile'),
            ),
          ],
        ),
        body: selectedIndex == 0
            ? HomeScreenWidget()
            : selectedIndex == 1 ? JobRoute() : UserProfile(),
      ),
    );
  }
}

class HomeScreenWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 30,
            bottom: 20,
            left: 20,
            right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text.rich(
              TextSpan(
                text: 'Welcome, ',
                children: [
                  TextSpan(
                    text: '${globals.user.name.split(' ')[0]}!',
                    style: Theme.of(context).textTheme.headline5.copyWith(
                          fontWeight: FontWeight.w200,
                          color: Colors.grey,
                        ),
                  )
                ],
              ),
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(
              height: 50,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                'We Are NEER!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
              ),
            ),
            SizedBox(
              height: 2,
            ),
            Align(
              alignment: Alignment.center,
              child: Text('Your One-Step shop for all your water needs',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.caption
                  // .copyWith(
                  //       fontWeight: FontWeight.w200,
                  // ),
                  ),
            ),
            SizedBox(
              height: 40,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                'And we\'re glad you\'re here!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
              ),
            ),
            SizedBox(
              height: 2,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                  'We appreciate your initiative contributing to the community',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.caption
                  // .copyWith(
                  //       fontWeight: FontWeight.w200,
                  // ),
                  ),
            ),
            Spacer(),
            Align(
              alignment: Alignment.center,
              child: Text(
                "Services Available",
                textAlign: TextAlign.center,
                style: textTheme.headline5.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              children: <Widget>[
                Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => RainWaterRoute(),
                        settings: RouteSettings(name: RainWaterRoute.routeName),
                      ),
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.border_all,
                        size: 50,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Rain Water'),
                    ],
                  ),
                ),
                Spacer(),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.border_all,
                      size: 50,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Water Quality'),
                  ],
                ),
                Spacer(),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              children: <Widget>[
                Spacer(),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.border_all,
                      size: 50,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Grey Water'),
                  ],
                ),
                Spacer(),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.border_all,
                      size: 50,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Waste Water'),
                  ],
                ),
                Spacer(),
              ],
            ),
            SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
