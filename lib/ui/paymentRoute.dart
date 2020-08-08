import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neer/models/contract.dart';
import 'package:neer/models/payment.dart';
import 'package:neer/widgets/customDialogWidget.dart';

class PaymentRoute extends StatelessWidget {
  final Contract contract;
  final List<Payment> payments;

  static var name = "PaymentRoute";

  const PaymentRoute({Key key, this.contract, this.payments}) : super(key: key);

  getThreeDividedTexts(
      BuildContext context, String text1, String text2, String text3,
      [bool isBold = false]) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment:
          isBold ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            text1,
            textAlign: TextAlign.center,
            style: isBold
                ? textTheme.bodyText2.copyWith(fontSize: 16)
                : textTheme.caption.copyWith(
                    fontSize: 14,
                  ),
          ),
        ),
        Container(
          height: 35,
          margin: EdgeInsets.symmetric(
            horizontal: 5,
          ),
          color: Colors.black,
          width: 1,
        ),
        Expanded(
          child: Text(
            text2,
            textAlign: TextAlign.center,
            style: isBold
                ? textTheme.bodyText2.copyWith(fontSize: 16)
                : textTheme.caption.copyWith(
                    fontSize: 14,
                  ),
          ),
        ),
        Container(
          height: 35,
          margin: EdgeInsets.symmetric(
            horizontal: 5,
          ),
          color: Colors.black,
          width: 1,
        ),
        Expanded(
          child: Text(
            text3,
            textAlign: TextAlign.center,
            style: isBold
                ? textTheme.bodyText2.copyWith(fontSize: 16)
                : textTheme.caption.copyWith(
                    fontSize: 14,
                  ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          left: 15,
          bottom: 10,
          right: 15,
          top: MediaQuery.of(context).padding.top + 25,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  " Payment",
                  style:
                      textTheme.headline5.copyWith(fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Align(
                alignment: Alignment.center,
                child: Text('Recorded Payments'),
              ),
              SizedBox(
                height: 20,
              ),
              payments.length <= 0
                  ? Align(
                      alignment: Alignment.center,
                      child: Text('No Payments Yet!'),
                    )
                  : Column(
                      children: [
                        getThreeDividedTexts(context, 'Date Paid',
                            'Amount Paid', 'Status', true),
                      ]..addAll(
                          List<Widget>.generate(
                            payments.length,
                            (index) {
                              final formatter =
                                  DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY);
                              DateTime date =
                                  DateTime.fromMillisecondsSinceEpoch(
                                payments[index].date,
                                isUtc: true,
                              );
                              String formattedDate = formatter.format(date);
                              return getThreeDividedTexts(
                                context,
                                formattedDate,
                                'INR ${payments[index].amount}',
                                payments[index].status,
                              );
                            },
                          ),
                        ),
                    ),
              SizedBox(height: 50),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Balance Due',
                  style: textTheme.subtitle1,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                getBalanceDue(payments, contract),
                style: textTheme.subtitle1.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierColor: Colors.black.withAlpha(1),
                    child: MakeAPaymentDialogWidget(
                      onCancel: () {},
                      onDone: (text) {},
                    ),
                  );
                },
                textColor: Colors.white,
                child: Text("Make A Payment"),
              ),
              SizedBox(
                height: 40,
              ),
              Align(
                alignment: Alignment.center,
                child: Text('Escrow Balance'),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'INR ${contract.escrow.toStringAsFixed(2)}',
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                onPressed: () {},
                textColor: Colors.white,
                child: Text("Approve From Escrow"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getBalanceDue(List<Payment> payments, Contract contract) {
    double totalPaid = 0;
    payments.forEach((element) {
      totalPaid += element.amount;
    });
    double remaining = contract.projectValue - totalPaid;
    if (remaining <= 0) {
      return "INR 0.00";
    } else {
      return "INR ${remaining.toStringAsFixed(2)}";
    }
  }
}
