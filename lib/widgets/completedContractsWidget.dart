import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neer/models/contract.dart';
import 'package:neer/models/openRequest.dart';
import 'package:neer/models/serviceProviderModel.dart';
import 'package:neer/ui/servicingOptions.dart';
import 'package:neer/widgets/customDialogWidget.dart';

class CompletedContractWidget extends StatelessWidget {
  final Contract contract;

  CompletedContractWidget({Key key, this.contract}) : super(key: key) {
    assert(contract?.endDate != null);
  }
  @override
  Widget build(BuildContext context) {
    ServiceProviderModel provider = contract.serviceProviderModel;
    OpenRequest request = contract.openRequest;

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
              style: textTheme.bodyText2,
              children: [
                TextSpan(
                  text: provider.name,
                  style: textTheme.bodyText1.copyWith(
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
              'Completed on ${DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY).format(
            DateTime.fromMillisecondsSinceEpoch(
              contract.endDate,
              isUtc: true,
            ),
          )}'),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ServicingOptionRoute(
                      contract: contract,
                    ),
                  ));
            },
            child: Row(
              children: [
                InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      'Review',
                      style: textTheme.bodyText2.copyWith(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  height: 8,
                  color: Colors.black,
                  width: 1,
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierColor: Colors.black.withAlpha(1),
                      child: DisputeContractWidget(),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      'Dispute',
                      style: textTheme.bodyText2.copyWith(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
