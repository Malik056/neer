import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neer/globals/constants.dart';
import 'package:neer/models/contract.dart';
import 'package:neer/models/openRequest.dart';
import 'package:neer/models/serviceProviderModel.dart';
import 'package:neer/ui/servicingOptions.dart';

class ContractWidget extends StatelessWidget {
  final Contract contract;

  const ContractWidget({Key key, this.contract}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    ServiceProviderModel provider = serviceProviders
        .firstWhere((element) => element.id == contract.serviceProviderId);
    OpenRequest request = openRequests
        .firstWhere((element) => element.requestId == contract.requestId);
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${request.serviceType} (${request.requestId})',
            style: textTheme.subtitle2,
          ),
          SizedBox(
            height: 4,
          ),
          Text.rich(
            TextSpan(
              text: 'Service by - ',
              style: textTheme.caption.copyWith(
                fontSize: textTheme.bodyText2.fontSize,
              ),
              children: [
                TextSpan(
                  text: provider.name,
                  style: textTheme.caption.copyWith(
                    fontSize: textTheme.bodyText2.fontSize,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            'Started on ${DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY).format(
              DateTime.fromMillisecondsSinceEpoch(
                contract.startDate,
                isUtc: true,
              ),
            )}',
            style: textTheme.caption.copyWith(
              fontSize: textTheme.bodyText2.fontSize,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => ServicingOptionRoute(
                    contract: contract,
                  ),
                  settings: RouteSettings(
                    name: ServicingOptionRoute.name,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                'More Options',
                style: textTheme.bodyText2.copyWith(
                  color: Colors.blue,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
