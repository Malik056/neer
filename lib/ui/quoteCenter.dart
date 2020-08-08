import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neer/models/quotesModel.dart';
import 'package:neer/ui/providerProfile.dart';

class QuoteCenterRoute extends StatelessWidget {
  final QuoteRequest quoteRequest;

  const QuoteCenterRoute({Key key, this.quoteRequest}) : super(key: key);

  String getTimeEstimation(int milliseconds) {
    Duration duration = Duration(milliseconds: milliseconds);
    if (duration.inDays > 0) {
      int days = duration.inDays;
      int years = days ~/ 365;
      if (years > 0) {
        return "${years > 1 ? '$years Years' : 'A Year'}";
      }
      int months = days ~/ 30;
      if (months > 0) {
        return "${months > 1 ? '$months Months' : 'A Month'}";
      }
      return "${days > 1 ? '$days Days' : 'A Day'}";
    } else if (duration.inHours > 0) {
      return "${duration.inHours > 1 ? '${duration.inHours} Hours' : 'An Hour'}";
    } else {
      return "Less than an Hour";
    }
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 20,
          left: 20,
          right: 20,
          bottom: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Quote Center',
                  style: textTheme.headline5,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          quoteRequest.request.serviceType
                              .toString()
                              .replaceFirst('ServiceType.', ''),
                          style: textTheme.subtitle2,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => ProviderProfile(
                                      serviceProviderModel:
                                          quoteRequest.serviceProviderModel),
                                ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Service Provider\'s Profile',
                              style: textTheme.bodyText2.copyWith(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {},
                    textColor: Colors.white,
                    child: Text(
                      'HIRE US',
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    'Service Type',
                    style: textTheme.bodyText2.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    quoteRequest.request.serviceType
                        .toString()
                        .replaceFirst('ServiceType.', ''),
                    style: textTheme.bodyText2,
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Details Provided',
                  style: textTheme.subtitle2,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                quoteRequest.details,
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Assumptions',
                  style: textTheme.subtitle2,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                quoteRequest.details,
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Time Estimation',
                  style: textTheme.subtitle2,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(getTimeEstimation(quoteRequest.timeEstimation)),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Cost Estimation',
                  style: textTheme.subtitle2,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text('${quoteRequest.costEstimation}'),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.center,
                child: Text('Let\'s schedule a free site visit?',
                    style: textTheme.bodyText2.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
              ),
              Align(
                alignment: Alignment.center,
                child: RaisedButton(
                  textColor: Colors.white,
                  color: Colors.black,
                  child: Text('Chat With Us'),
                  onPressed: () async {
                    // Navigator.of(context).pop();
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
