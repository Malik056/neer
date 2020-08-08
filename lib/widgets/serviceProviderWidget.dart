import 'package:flutter/material.dart';
import 'package:neer/models/serviceProviderModel.dart';
import 'package:rating_bar/rating_bar.dart';

class ServiceProviderWidget extends StatelessWidget {
  final ServiceProviderModel serviceProvider;
  final bool fullVersion;

  ServiceProviderWidget({
    Key key,
    @required this.serviceProvider,
    this.fullVersion = true,
  }) : super(key: key) {
    assert(serviceProvider != null);
  }
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                serviceProvider.name.toUpperCase() ?? '',
                style: textTheme.subtitle1.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              fullVersion
                  ? Opacity(
                      opacity: 0,
                    )
                  : IconButton(
                      icon: Icon(Icons.open_in_browser),
                      onPressed: () {},
                    ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text(
                  serviceProvider.description ?? '',
                  style: textTheme.caption,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              fullVersion
                  ? StatefulBuilder(builder: (context, setState) {
                      return IconButton(
                        icon: Icon(
                          (serviceProvider.isFavorite ?? false)
                              ? Icons.favorite
                              : Icons.favorite_border,
                        ),
                        onPressed: () {
                          setState(() {
                            serviceProvider.isFavorite =
                                !serviceProvider.isFavorite;
                          });
                        },
                      );
                    })
                  : Opacity(opacity: 0),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            getLicenseString(),
            style: textTheme.subtitle1,
          ),
          SizedBox(
            height: 4.0,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                RatingBar.readOnly(
                  initialRating: serviceProvider.rating / 2,
                  isHalfAllowed: true,
                  size: 35,
                  halfFilledIcon: Icons.star_half,
                  filledIcon: Icons.star,
                  emptyIcon: Icons.star_border,
                  maxRating: 5,
                  emptyColor: Colors.black,
                  filledColor: Colors.black,
                  halfFilledColor: Colors.black,
                ),
                SizedBox(width: 5),
                fullVersion
                    ? Text(
                        ' ${serviceProvider.totalReviews} Reviews',
                        style: textTheme.caption.copyWith(
                          color: Colors.blue,
                          fontStyle: FontStyle.normal,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Text('ICCW Rating     ${serviceProvider.rating}'),
          SizedBox(
            height: 20,
          ),
          fullVersion
              ? Row(
                  children: <Widget>[
                    Icon(Icons.phone_in_talk),
                    SizedBox(
                      width: 15,
                    ),
                    Icon(Icons.web),
                    SizedBox(
                      width: 15,
                    ),
                    RaisedButton(
                      color: Colors.black,
                      textColor: Colors.white,
                      onPressed: () {},
                      child: Text('Request Free Quote'),
                    ),
                  ],
                )
              : Opacity(
                  opacity: 0,
                ),
        ],
      ),
    );
  }

  String getLicenseString() {
    int expiryDateMillis = serviceProvider.licenseExpiryDate;
    DateTime expiryDate =
        DateTime.fromMillisecondsSinceEpoch(expiryDateMillis, isUtc: true);
    DateTime now = DateTime.now().toUtc();

    int days = expiryDate.difference(now).inDays;

    if (days <= 0) {
      return "License Expired";
    }
    int years = days ~/ 365;
    if (years > 0) {
      return "Licensed for $years ${years == 1 ? 'year' : 'years'}";
    }
    int months = days ~/ 30;
    if (months > 0) {
      return "Licensed for $months ${months == 1 ? 'month' : 'months'}";
    }
    return "Licensed for $days ${days == 1 ? 'day' : 'days'}";
  }
}
