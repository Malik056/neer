import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neer/globals/constants.dart' as globals;
import 'package:neer/models/contract.dart';
import 'package:neer/models/openRequest.dart';
import 'package:neer/models/payment.dart';
import 'package:neer/models/serviceProviderModel.dart';
import 'package:neer/ui/paymentRoute.dart';
import 'package:neer/widgets/customDialogWidget.dart';

class ServicingOptionRoute extends StatelessWidget {
  final Contract contract;

  const ServicingOptionRoute({Key key, this.contract}) : super(key: key);

  Widget horizontalKeyValue(
    BuildContext context,
    String key,
    String value, [
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.normal,
  ]) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Expanded(
          child: Text(
            key,
            textAlign: TextAlign.right,
            style: textTheme.bodyText2.copyWith(
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        Container(
          color: Colors.black,
          height: 35,
          width: 1,
          margin: EdgeInsets.only(
            left: 35,
            right: 20,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: textTheme.bodyText2.copyWith(
              color: color,
              fontWeight: fontWeight,
            ),
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    OpenRequest request = globals.openRequests.firstWhere(
      (element) => element.requestId == contract.requestId,
    );
    ServiceProviderModel serviceProvider = globals.serviceProviders.firstWhere(
      (element) => element.id == contract.serviceProviderId,
    );
    return Scaffold(
      body: Material(
        child: Padding(
          padding: EdgeInsets.only(
            left: 15,
            bottom: 10,
            right: 15,
            top: MediaQuery.of(context).padding.top + 25,
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        " Servicing Options",
                        style: textTheme.headline5
                            .copyWith(fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      horizontalKeyValue(
                        context,
                        'Status',
                        contract.status,
                        contract.status == globals.ContractStatus.inProgress
                            ? Colors.green
                            : null,
                        FontWeight.bold,
                      ),
                      horizontalKeyValue(
                        context,
                        'Service Type',
                        request.serviceType,
                      ),
                      horizontalKeyValue(
                        context,
                        'Job Reference ID',
                        contract.requestId,
                      ),
                      horizontalKeyValue(
                        context,
                        'Date Started',
                        DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY).format(
                          DateTime.fromMillisecondsSinceEpoch(
                              contract.startDate),
                        ),
                      ),
                      horizontalKeyValue(
                        context,
                        'Service By',
                        serviceProvider.name,
                      ),
                      horizontalKeyValue(
                        context,
                        'Project Value',
                        contract.projectValue.toString(),
                      ),
                      horizontalKeyValue(
                        context,
                        'In Escrow',
                        contract.escrow.toString(),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                        children: <Widget>[
                          Spacer(),
                          Expanded(
                            flex: 2,
                            child: GestureDetector(
                              onTap: () {
                                List<Payment> payments = [];
                                contract.milestones.forEach((element) {
                                  payments.addAll(element.payments);
                                });
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => PaymentRoute(
                                        contract: contract, payments: payments),
                                    settings:
                                        RouteSettings(name: PaymentRoute.name),
                                  ),
                                );
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.border_all,
                                    size: 40,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Make a Payment',
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Spacer(),
                          Expanded(
                            flex: 2,
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  barrierColor: Colors.black.withAlpha(1),
                                  child: TermsAndMilestoneDialogWidget(
                                      contract: contract),
                                );
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.border_all,
                                    size: 40,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Milestone & Terms',
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Spacer(),
                          Expanded(
                            flex: 2,
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    barrierColor: Colors.black.withAlpha(1),
                                    child: FinalizeContractDialogWidget(
                                      contract: contract,
                                    ));
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.border_all,
                                    size: 40,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Finalize Contract',
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
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
                          Expanded(
                            flex: 2,
                            child: GestureDetector(
                              onTap: () {},
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.border_all,
                                    size: 40,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Document Center',
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Spacer(),
                          Expanded(
                            flex: 2,
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  barrierColor: Colors.black.withAlpha(1),
                                  child: ReviewWidget(
                                    contract: contract,
                                  ),
                                );
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.border_all,
                                    size: 40,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Review Service Provider',
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Spacer(),
                          Expanded(
                            flex: 2,
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  barrierColor: Colors.black.withAlpha(1),
                                  child: CancelServiceWidget(),
                                );
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.border_all,
                                    size: 40,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Cancel Service',
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                onPressed: () {},
                color: Colors.black,
                textColor: Colors.white,
                child: Text('Chat with provider'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
