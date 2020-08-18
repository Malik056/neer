import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neer/globals/constants.dart' as constants;
import 'package:neer/models/openRequest.dart';
import 'package:neer/ui/homeScreen.dart';
import 'package:neer/widgets/serviceProviderWidget.dart';

class ThankYouRoute extends StatelessWidget {
  static final String name = "ThankYouRoute";
  final OpenRequest requestData;

  const ThankYouRoute({Key key, this.requestData}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      // persistentFooterButtons: <Widget>[
      //   Row(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       Container(
      //         width: 130,
      //         height: 40,
      //         child: RaisedButton(
      //           onPressed: () {
      //             Navigator.pop(context);
      //           },
      //           shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(4.0)),
      //           color: Colors.black,
      //           textColor: Colors.white,
      //           child: Text('Done'),
      //         ),
      //       ),
      //     ],
      //   ),
      // ],
      //REMOVED: Done Button /\ Replaced Done button with bottom navigation
      ///////////////////////||////////////////////////////////////////////
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute(
                builder: (ctx) => HomeScreenRoute(
                  initialIndex: index,
                ),
              ),
              (route) => false);
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
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
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 20.0,
          left: 20,
          right: 20,
          bottom: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Thank You!",
                  style: textTheme.headline5,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "You Job Reference ID - ${requestData.requestId ?? ''}",
                  textAlign: TextAlign.center,
                  style: textTheme.headline6
                      .copyWith(fontWeight: FontWeight.normal),
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Below is the list of recommended service providers for your job",
                  textAlign: TextAlign.center,
                  style: textTheme.caption,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Column(
                children: List.generate(
                  constants.serviceProviders.length,
                  (index) => Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: ServiceProviderWidget(
                      serviceProvider: constants.serviceProviders[index],
                      fullVersion: true,
                      requestData: requestData,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
