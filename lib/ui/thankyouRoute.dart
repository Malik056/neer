import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neer/globals/constants.dart' as constants;
import 'package:neer/ui/homeScreen.dart';
import 'package:neer/widgets/serviceProviderWidget.dart';

class ThankYouRoute extends StatelessWidget {
  static final String name = "ThankYouRoute";
  final String requestId;

  const ThankYouRoute({Key key, this.requestId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      persistentFooterButtons: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 130,
              height: 40,
              child: RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0)),
                color: Colors.black,
                textColor: Colors.white,
                child: Text('Done'),
              ),
            ),
          ],
        ),
      ],
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
                  "You Job Reference ID - $requestId",
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
