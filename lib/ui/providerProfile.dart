import 'package:flutter/material.dart';
import 'package:neer/globals/constants.dart';
import 'package:neer/models/serviceProviderModel.dart';
import 'package:neer/widgets/reviewWidget.dart';
import 'package:neer/widgets/serviceProviderWidget.dart';
import 'package:neer/widgets/tagText.dart';

class ProviderProfile extends StatelessWidget {
  static final String name = "ProviderProfile";
  final ServiceProviderModel serviceProviderModel;

  const ProviderProfile({Key key, this.serviceProviderModel}) : super(key: key);

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Provider Profile', style: textTheme.headline5),
              SizedBox(
                height: 20,
              ),
              ServiceProviderWidget(
                serviceProvider: serviceProviderModel,
                fullVersion: false,
              ),
              Divider(
                height: 0,
                color: Colors.black,
              ),
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.center,
                child: Text('Specializations'),
              ),
              SizedBox(
                height: 20,
              ),
              Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.start,
                children: List<Widget>.generate(
                  serviceProviderModel.services.length,
                  (index) => Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: TagText(
                      tag: serviceProviderModel.services[index],
                    ),
                  ),
                ),
              ),
              Divider(
                height: 0,
                color: Colors.black,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Reviews (${serviceProviderModel.totalReviews})',
                style: textTheme.headline6,
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                children: List.generate(
                  reviews.length,
                  (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ReviewWidget(reviews[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
