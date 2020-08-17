import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart' as gmailSMTP;
import 'package:neer/globals/constants.dart';
import 'package:neer/globals/methods.dart';
import 'package:neer/globals/secrets.dart' as secrets;
import 'package:neer/models/serviceProviderModel.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';

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
    bool mailSent = false;
    bool sendingEmail = false;
    return StatefulBuilder(builder: (context, setState) {
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
                      InkWell(
                        child: Icon(Icons.phone_in_talk),
                        onTap: () async {
                          final url =
                              'tel:${serviceProvider.phone ?? '+911234512345'}';
                          if (await canLaunch(url)) {
                            launch(url);
                          } else {
                            showInSnackbar(
                              'Can\'t open dialer',
                              context,
                              color: Colors.red,
                            );
                          }
                        },
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      InkWell(
                        child: Icon(Icons.web),
                        onTap: () async {
                          final url =
                              '${serviceProvider.website ?? 'https://www.iccwindia.org/'}';
                          if (await canLaunch(url)) {
                            launch(url);
                          } else {
                            showInSnackbar(
                              'Couldn\'t open the url',
                              context,
                              color: Colors.red,
                            );
                          }
                        },
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      RaisedButton(
                        color: Colors.black,
                        textColor: Colors.white,
                        onPressed: mailSent
                            ? null
                            : () async {
                                if (!sendingEmail) {
                                  sendingEmail = true;
                                  final smtpServer = gmailSMTP.gmail(
                                      secrets.email, secrets.password);
                                  // Use the SmtpServer class to configure an SMTP server:
                                  // final smtpServer = SmtpServer('smtp.domain.com');
                                  // See the named arguments of SmtpServer for further configuration
                                  // options.

                                  // Create our message.
                                  final message = Message()
                                    ..from = Address(user.email, user.name)
                                    ..recipients.add(
                                        '${serviceProvider.email ?? 'iccw@email.com'}')
                                    ..subject = emailDataBloc.state?.subject ??
                                        'Quote request by NEER'
                                    ..text = emailDataBloc.state?.body ?? "";

                                  try {
                                    final sendReport =
                                        await send(message, smtpServer);
                                    print(sendReport.toString());
                                    setState(() {
                                      mailSent = true;
                                    });
                                  } on MailerException catch (e) {
                                    sendingEmail = false;
                                    showInSnackbar(
                                      'Error: Sending Email',
                                      context,
                                      color: Colors.red,
                                    );
                                    for (var p in e.problems) {
                                      print('Problem: ${p.code}: ${p.msg}');
                                    }
                                  }
                                }
                              },
                        child: Text(mailSent
                            ? 'Quote Requested'
                            : 'Request Free Quote'),
                      ),
                    ],
                  )
                : Opacity(
                    opacity: 0,
                  ),
          ],
        ),
      );
    });
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
