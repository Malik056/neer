import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neer/globals/constants.dart' as globals;
import 'package:neer/models/openRequest.dart';
import 'package:neer/ui/actionCenter.dart';

class OpenRequestWidget extends StatelessWidget {
  final OpenRequest openRequest;

  const OpenRequestWidget({Key key, this.openRequest}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${openRequest.serviceType.toString().replaceFirst('ServiceType.', '')} (${openRequest.requestId})',
          style: textTheme.subtitle2,
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          'initiated on ${DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY).format(DateTime.fromMillisecondsSinceEpoch(
            openRequest.initializeDate,
            isUtc: true,
          ))}',
          style: textTheme.caption,
        ),
        GestureDetector(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Action Center',
              style: textTheme.bodyText2.copyWith(
                color: Colors.blue,
              ),
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (ctx) {
                  return ActionCenterRoute(
                    quoteRequests: globals.quotes
                        .where((element) =>
                            element.requestId == openRequest.requestId)
                        .toList(),
                  );
                },
                settings: RouteSettings(
                  name: ActionCenterRoute.name,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
