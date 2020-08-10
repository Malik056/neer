import 'package:bot_toast/bot_toast.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:neer/bloc/waitTimeBloc.dart';
import 'package:neer/customUIDecorations/customBorder.dart';
import 'package:neer/globals/constants.dart' as globals;
import 'package:neer/models/contract.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:rating_bar/rating_bar.dart';

class CancelJobRequestDialogWidget extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback onDone;
  final String description;
  final String title;
  final String buttonText;
  final Color actionButtonTextColor;

  const CancelJobRequestDialogWidget({
    Key key,
    this.onClose,
    this.onDone,
    this.description,
    this.title,
    this.buttonText,
    this.actionButtonTextColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Dialog(
      elevation: 1,
      insetPadding: EdgeInsets.all(0),
      shape: Border(
        top: BorderSide(
          color: Colors.black,
          width: 2,
        ),
        bottom: BorderSide(
          color: Colors.black,
          width: 2,
        ),
      ),
      child: Material(
        child: Container(
          margin: EdgeInsets.only(top: 2, bottom: 10, left: 20, right: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '\n$title',
                    style: textTheme.headline6,
                  ),
                  Spacer(),
                  IconButton(
                    color: Colors.black,
                    icon: Icon(Icons.cancel),
                    onPressed: () {
                      Navigator.of(context).pop();
                      onClose();
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              SizedBox(
                width: 250,
                child: Text(
                  description,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.center,
                child: FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onDone();
                  },
                  textColor: Colors.red,
                  child: Text(
                    '$buttonText',
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MakeAPaymentDialogWidget extends StatelessWidget {
  final Function(int amount) onDone;
  final VoidCallback onCancel;

  final _formKey = GlobalKey<FormState>();

  MakeAPaymentDialogWidget({
    Key key,
    this.onDone,
    this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Dialog(
      backgroundColor: Colors.transparent,
      shape: MyCustomShapeBorder(
        2,
        Colors.black,
        0,
      ),
      insetPadding: EdgeInsets.all(0),
      child: Card(
        child: Container(
          decoration: ShapeDecoration(
            shape: Border.all(
              color: Color(0xff00ff00),
              width: 2,
            ),
          ),
          padding: EdgeInsets.all(4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Spacer(),
                  Text(
                    '\nPayment'.toUpperCase(),
                    style: textTheme.subtitle1.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(
                    flex: 6,
                  ),
                  InkWell(
                    child: Icon(Icons.cancel),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  Spacer(),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Payment Amount',
                  style: textTheme.subtitle1,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Form(
                key: _formKey,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: TextFormField(
                    decoration: InputDecoration(
                      // labelText: "INR",
                      hintText: "INR",
                      contentPadding: EdgeInsets.all(0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Approve'.toUpperCase(),
                  style: textTheme.button.copyWith(
                    color: Colors.green,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TermsAndMilestoneDialogWidget extends StatelessWidget {
  final Contract contract;

  TermsAndMilestoneDialogWidget({Key key, @required this.contract})
      : super(key: key) {
    assert(contract != null);
  }

  Widget getThreeTextRow(
      BuildContext context, String text1, String text2, String text3,
      [bool isHeading = false]) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            '$text1',
            textAlign: TextAlign.center,
            style: isHeading
                ? textTheme.subtitle2
                : textTheme.caption.copyWith(
                    fontSize: textTheme.bodyText2.fontSize,
                  ),
          ),
        ),
        Expanded(
          child: Text(
            '$text2',
            textAlign: TextAlign.center,
            style: isHeading
                ? textTheme.subtitle2
                : textTheme.caption.copyWith(
                    fontSize: textTheme.bodyText2.fontSize,
                  ),
          ),
        ),
        Expanded(
          child: Text(
            '$text3',
            textAlign: TextAlign.center,
            style: isHeading
                ? textTheme.subtitle2
                : textTheme.caption.copyWith(
                    fontSize: textTheme.bodyText2.fontSize,
                  ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Dialog(
      insetPadding: EdgeInsets.all(0),
      child: Material(
        shape: MyCustomShapeBorder(
          2,
          Colors.black,
          0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(),
                Text(
                  '\nTerms',
                  style: textTheme.subtitle1.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(
                  flex: 6,
                ),
                InkWell(
                  child: Icon(Icons.cancel),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                Spacer(),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              constraints: BoxConstraints(maxHeight: 200),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    getThreeTextRow(context, 'Milestone', 'Terms', 'Due', true),
                    SizedBox(
                      height: 15,
                    ),
                    for (int i = 0; i < contract.milestones.length; i++)
                      Column(
                        children: [
                          getThreeTextRow(
                            context,
                            contract.milestones[i].name,
                            '${((contract.milestones[i].term / contract.projectValue) * 100).toStringAsFixed(0)}%',
                            getDateAsString(contract.milestones[i].dueDate),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getDateAsString(int dueDate) {
    DateFormat formatter = DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY);
    DateTime date = DateTime.fromMillisecondsSinceEpoch(
      dueDate,
      isUtc: true,
    );
    return formatter.format(date);
  }
}

class FinalizeContractDialogWidget extends StatelessWidget {
  final Contract contract;

  FinalizeContractDialogWidget({Key key, this.contract}) : super(key: key) {
    assert(contract != null);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Dialog(
      backgroundColor: Colors.transparent,
      shape: MyCustomShapeBorder(
        2,
        Colors.black,
        0,
      ),
      insetPadding: EdgeInsets.all(0),
      child: Material(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(),
                Text(
                  '\nFinalize',
                  style: textTheme.subtitle1.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(
                  flex: 6,
                ),
                InkWell(
                  child: Icon(Icons.cancel),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                Spacer(),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      checkStatus() ? Icons.check : Icons.close,
                      color: checkStatus() ? Colors.black : Colors.red,
                    ),
                    Text(' Balance paid in full'),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      checkStatus() ? Icons.check : Icons.close,
                      color: checkStatus() ? Colors.black : Colors.red,
                    ),
                    Text(' Approved by ICCW'),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      checkStatus() ? Icons.check : Icons.close,
                      color: checkStatus() ? Colors.black : Colors.red,
                    ),
                    Text(' Review Service Provider'),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                'End Contract'.toUpperCase(),
                style: textTheme.button.copyWith(
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }

  bool checkStatus() {
    double projectValue = contract.projectValue;
    double amountPaid = 0;
    contract.milestones.forEach((element) {
      if (element.payments.length > 1) {
        amountPaid += element.payments
            .reduce((value, element) => value..amount += element.amount)
            .amount;
      } else if (element.payments.length == 1) {
        amountPaid += element.payments[0].amount;
      }
    });
    return amountPaid >= projectValue;
  }
}

class ReviewWidget extends StatelessWidget {
  final Contract contract;
  final TextEditingController reviewTextController =
      TextEditingController(text: '');
  ReviewWidget({Key key, this.contract}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double currentRating = 0.0;
    final textTheme = Theme.of(context).textTheme;
    return Dialog(
      backgroundColor: Colors.transparent,
      shape: MyCustomShapeBorder(
        2,
        Colors.black,
        0,
      ),
      insetPadding: EdgeInsets.all(0),
      child: Material(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(),
                Text(
                  '\nAdd Review',
                  style: textTheme.subtitle1.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(
                  flex: 6,
                ),
                InkWell(
                  child: Icon(Icons.cancel),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                Spacer(),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            RatingBar(
              onRatingChanged: (rating) {
                currentRating = rating * 2;
              },
              isHalfAllowed: true,
              maxRating: 5,
              initialRating: currentRating / 2,
              emptyIcon: Icons.star_border, //FontAwesomeIcons.star,
              halfFilledIcon: Icons.star_half, //FontAwesomeIcons.starHalfAlt,
              filledIcon: Icons.star, // FontAwesomeIcons.solidStar,
              emptyColor: Colors.black,
              filledColor: Colors.black,
              halfFilledColor: Colors.black,
              // size: 55,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Spacer(),
                Expanded(
                  flex: 10,
                  child: TextField(
                    controller: reviewTextController,
                    minLines: 5,
                    maxLines: 6,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          20,
                        ),
                      ),
                      hintText: "Add your review here ...",
                    ),
                  ),
                ),
                Spacer(),
              ],
            ),
            Align(
              alignment: Alignment.center,
              child: FlatButton(
                onPressed: () {},
                child: Text(
                  'Submit'.toUpperCase(),
                  style: textTheme.button.copyWith(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CancelServiceWidget extends StatelessWidget {
  const CancelServiceWidget({
    Key key,
  }) : super(key: key);

  Widget build(BuildContext context) {
    // double currentRating = 0.0;
    final textTheme = Theme.of(context).textTheme;
    return Dialog(
      backgroundColor: Colors.transparent,
      shape: MyCustomShapeBorder(
        2,
        Colors.black,
        0,
      ),
      insetPadding: EdgeInsets.all(0),
      child: Material(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(),
                Text(
                  '\nCancel Service',
                  style: textTheme.subtitle1.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                Spacer(
                  flex: 6,
                ),
                InkWell(
                  child: Icon(Icons.cancel),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                Spacer(),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Spacer(),
                Expanded(
                  flex: 8,
                  child: Text.rich(
                    TextSpan(
                        text:
                            'This will require an ICCW specialist ensure that if both parties are on the same page and the terms are met and provide mediation assistance too and resolve any issues. Send an email to ',
                        children: [
                          TextSpan(
                            text: 'iccw@email.com',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text:
                                ' briefing the case - our specialist will call you at the earliest convenience.',
                          ),
                        ]),
                    style: textTheme.caption.copyWith(
                      fontSize: textTheme.bodyText2.fontSize,
                    ),
                  ),
                ),
                Spacer(),
              ],
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}

class DisputeContractWidget extends StatelessWidget {
  const DisputeContractWidget({
    Key key,
  }) : super(key: key);

  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Dialog(
      backgroundColor: Colors.transparent,
      shape: MyCustomShapeBorder(
        2,
        Colors.black,
        0,
      ),
      insetPadding: EdgeInsets.all(0),
      child: Material(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(),
                Text(
                  '\nDispute a contract',
                  style: textTheme.subtitle1.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                Spacer(
                  flex: 6,
                ),
                InkWell(
                  child: Icon(Icons.cancel),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                Spacer(),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Spacer(),
                Expanded(
                  flex: 8,
                  child: Text.rich(
                    TextSpan(
                        text:
                            'This will require an ICCW specialist, provide mediation assistance to both parties to try and resolve the matter. Send an email to ',
                        children: [
                          TextSpan(
                            text: 'iccw@email.com',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text:
                                ' briefing what went wrong - our specialist will call you at the earliest convenience.',
                          ),
                        ]),
                    style: textTheme.caption.copyWith(
                      fontSize: textTheme.bodyText2.fontSize,
                    ),
                  ),
                ),
                Spacer(),
              ],
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}

class CodeVerificationDialog extends StatelessWidget {
  final String phoneNumber;
  CodeVerificationDialog({Key key, this.phoneNumber}) : super(key: key);

//   @override
//   _CodeVerificationDialogState createState() => _CodeVerificationDialogState();
// }

// class _CodeVerificationDialogState extends State<CodeVerificationDialog> {
//   // int timeRemaining = 4;
//   // Timer _timer;
//   String error;

//   _CodeVerificationDialogState();

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    bool isLoading = false;
    return Dialog(
      backgroundColor: Colors.transparent,
      shape: MyCustomShapeBorder(
        2,
        Colors.black,
        0,
      ),
      insetPadding: EdgeInsets.all(0),
      child: Material(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder<int>(
              stream: globals.waitingTimeBloc,
              initialData: globals.waitingTimeBloc.state,
              builder: (context, snapshot) {
                int timeRemaining = snapshot.data;
                if (timeRemaining == null) {
                  timeRemaining = globals.waitingTimeBloc.state ?? 30;
                }
                return StatefulBuilder(builder: (context, setState) {
                  return ModalProgressHUD(
                    inAsyncCall: isLoading,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Enter verification code',
                          style: textTheme.headline6,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Text.rich(
                            TextSpan(
                              text:
                                  'We have sent you a 6 digit verification code on ',
                              children: [
                                TextSpan(
                                  text: '$phoneNumber',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                            style: textTheme.caption,
                          ),
                        ),
                        SizedBox(height: 20),
                        OTPTextField(
                          fieldStyle: FieldStyle.box,
                          length: 6,
                          fieldWidth: 50,
                          obscureText: false,
                          onCompleted: (text) async {
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              bool result =
                                  await globals.phoneAuthProvider.verify(text);
                              if (result) {
                                if (globals.user.phoneNumber != phoneNumber) {
                                  result = await globals.phoneAuthProvider
                                      .updateCurrentUserCredentials();
                                  if (result == null || result == false) {
                                    showError('Bad OTP');
                                    setState(() {
                                      isLoading = false;
                                    });
                                    return;
                                  }
                                }
                                Navigator.pop(context, true);
                              } else {
                                setState(() {
                                  isLoading = false;
                                });
                                showError('Bad OTP');
                              }
                            } catch (ex) {
                              showError('$ex');
                              setState(() {
                                isLoading = false;
                              });
                            }
                          },
                          textFieldAlignment: MainAxisAlignment.spaceEvenly,
                          width: 420,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          timeRemaining <= 0
                              ? 'Time elapsed.'
                              : '0:${timeRemaining < 10 ? '0$timeRemaining' : timeRemaining}',
                          style: TextStyle(
                            color: timeRemaining <= 0
                                ? Colors.black
                                : Colors.green[400],
                          ),
                        ),
                        // if (timeRemaining <= 0)
                        AnimatedContainer(
                          height: timeRemaining > 0 ? 0 : 45,
                          duration: Duration(
                            milliseconds: 200,
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: FlatButton(
                              child: Text('Resend Code'),
                              onPressed: () {
                                if (globals.connectivityBloc.state ==
                                    ConnectivityResult.none) {
                                  showError("No Internet Connection");
                                  return;
                                }
                                globals.waitingTimeBloc
                                    .add(StopWatchEvents.start);
                                FirebaseAuth.instance.verifyPhoneNumber(
                                  phoneNumber: phoneNumber,
                                  timeout: Duration(seconds: 30),
                                  verificationCompleted: (credentials) {
                                    globals.phoneAuthProvider.credentials =
                                        credentials;
                                    Navigator.pop(context, true);
                                  },
                                  verificationFailed: null,
                                  codeSent: (verificationId,
                                      [forceResendCode]) {
                                    globals.phoneAuthProvider.verificationId =
                                        verificationId;
                                  },
                                  codeAutoRetrievalTimeout: (verificationId) {
                                    globals.phoneAuthProvider.verificationId =
                                        verificationId;
                                  },
                                );
                                // globals.phoneAuthProvider.sendCode(
                                //   onCodeSent: () {},
                                //   verificationFailed: (error) {
                                //     showError(error);
                                //   },
                                //   phoneNumber: phoneNumber,
                                //   onVerificationCompleted: () async {
                                //     AuthResult result;
                                //     try {
                                //       result = await FirebaseAuth.instance
                                //           .signInWithCredential(
                                //         globals.phoneAuthProvider.credentials,
                                //       );
                                //     } catch (ex) {
                                //       print(ex);
                                //       // showError('');
                                //       return;
                                //     }
                                //     if (result?.user != null) {
                                //       Navigator.pop(context, true);
                                //     }
                                //   },
                                //   codeAutoRetrievalTimeout: () {},
                                //   timeout: 1,
                                // );
                              },
                              color: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3.0),
                                side: BorderSide(color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                        // SizedBox(
                        //   height: 8,
                        // ),
                        // error == null ? SizedBox() : Text('$error'),
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            color: Colors.black12,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Text(
                              'All communications and invoices will be sent to your updated contact details',
                              textAlign: TextAlign.start,
                              style: textTheme.caption,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Cancel',
                                style: textTheme.button.copyWith(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            GestureDetector(
                              onTap: null,
                              child: Text(
                                "Confirm",
                                style: textTheme.button
                                    .copyWith(color: Colors.grey),
                              ),
                            ),
                            SizedBox(width: 20),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  );
                });
              }),
        ),
      ),
    );
  }

  void showError(String err) {
    BotToast.showCustomText(toastBuilder: (fn) {
      return Container(
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
        padding: EdgeInsets.all(16.0),
        child: Text('$err'),
      );
    });
  }
}
