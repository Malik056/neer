import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neer/globals/constants.dart' as globals;
import 'package:neer/models/contract.dart';
import 'package:neer/models/openRequest.dart';
import 'package:neer/models/payment.dart';
import 'package:neer/models/serviceProviderModel.dart';

class CompletedJobDetailsRoute extends StatelessWidget {
  final Contract contract;

  CompletedJobDetailsRoute({Key key, this.contract}) : super(key: key) {
    assert(contract?.endDate != null);
  }

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
    OpenRequest request = contract.openRequest;
    ServiceProviderModel serviceProvider = contract.serviceProviderModel;
    Map<String, String> latestPayment = getFinalInvoiceDateAndAmount();
    String finalInvoiceDate = latestPayment['date'];
    String finalInvoiceAmount = latestPayment['amount'];

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
                        " Job Details",
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
                        contract.status != globals.ContractStatus.canceled
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
                        'Date Completed',
                        DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY).format(
                          DateTime.fromMillisecondsSinceEpoch(
                            contract.endDate,
                          ),
                        ),
                      ),
                      horizontalKeyValue(
                        context,
                        'Serviced By',
                        serviceProvider.name,
                      ),
                      if (contract.dateInspected != null)
                        horizontalKeyValue(
                          context,
                          'Date Inspected',
                          DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY).format(
                            DateTime.fromMillisecondsSinceEpoch(
                              contract.dateInspected,
                            ),
                          ),
                        ),
                      if (contract.inspectedBy != null)
                        horizontalKeyValue(
                          context,
                          'Date Inspected',
                          'Mr. ${contract.inspectedBy}, ICCW',
                        ),
                      horizontalKeyValue(
                        context,
                        'Final Invoice Amount',
                        finalInvoiceAmount,
                      ),
                      horizontalKeyValue(
                        context,
                        'Date Paid',
                        finalInvoiceDate,
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
                textColor: Colors.white,
                child: Text('    Download Invoice    '),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, String> getFinalInvoiceDateAndAmount() {
    int latestTime = 0;
    double amount;
    contract.milestones.forEach((milestone) {
      milestone.payments.forEach((payment) {
        if (payment.date > latestTime) {
          latestTime = payment.date;
          amount = payment.amount;
        }
      });
    });
    if (amount == null) {
      return null;
    } else {
      return {
        'amount': amount.toStringAsFixed(2),
        'date': DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY).format(
          DateTime.fromMillisecondsSinceEpoch(
            latestTime,
            isUtc: true,
          ),
        )
      };
    }
  }
}

class CanceledJobDetailsRoute extends StatelessWidget {
  final Contract contract;

  CanceledJobDetailsRoute({Key key, this.contract}) : super(key: key) {
    assert(contract?.endDate != null);
  }

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
    OpenRequest request = contract.openRequest;
    // Map<String, String> latestPayment = getFinalInvoiceDateAndAmount();
    // String finalInvoiceDate = latestPayment['date'];
    // String finalInvoiceAmount = latestPayment['amount'];

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
                        " Job Details",
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
                        contract.status != globals.ContractStatus.canceled
                            ? Colors.green
                            : Colors.black,
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
                        'Date Requested',
                        DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY).format(
                          DateTime.fromMillisecondsSinceEpoch(
                              contract.startDate),
                        ),
                      ),
                      horizontalKeyValue(
                        context,
                        'Date Canceled',
                        DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY).format(
                          DateTime.fromMillisecondsSinceEpoch(
                            contract.endDate,
                          ),
                        ),
                      ),
                      horizontalKeyValue(
                        context,
                        'Cancellation Reason',
                        contract.cancelReason,
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
                textColor: Colors.white,
                child: Text('    Download Invoice    '),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, String> getFinalInvoiceDateAndAmount() {
    int latestTime = 0;
    double amount;
    contract.milestones.forEach((milestone) {
      milestone.payments.forEach((payment) {
        if (payment.date > latestTime) {
          latestTime = payment.date;
          amount = payment.amount;
        }
      });
    });
    if (amount == null) {
      return null;
    } else {
      return {
        'amount': amount.toStringAsFixed(2),
        'date': DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY).format(
          DateTime.fromMillisecondsSinceEpoch(
            latestTime,
            isUtc: true,
          ),
        )
      };
    }
  }
}
