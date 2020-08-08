import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:neer/bloc/phoneAuthBloc.dart';
import 'package:neer/globals/constants.dart' as globals;
import 'package:neer/models/user.dart';
import 'package:neer/ui/createAnAccount.dart';
import 'package:neer/ui/homeScreen.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

enum _StopWatchEvents { start, stop, decrement }

class _WaitingTimeBloc extends Bloc<_StopWatchEvents, int> {
  Timer timer;
  final int maxTime = 15;
  _WaitingTimeBloc() : super(15) {
    timer = Timer.periodic(Duration(seconds: 1), (_timer) {
      add(_StopWatchEvents.decrement);
    });
  }

  void dispose() {
    timer?.cancel();
  }

  @override
  Stream<int> mapEventToState(event) async* {
    print(event);
    if (event == _StopWatchEvents.start) {
      timer?.cancel();
      timer = Timer.periodic(Duration(seconds: 1), (_timer) {
        add(_StopWatchEvents.decrement);
      });
      yield 15;
    } else if (event == _StopWatchEvents.decrement) {
      if (state == 1) {
        timer?.cancel();
      }
      yield state - 1;
    } else if (event == _StopWatchEvents.stop) {
      timer?.cancel();
      yield 0;
    }
  }
}

class PhoneVerificationCodeRoute extends StatefulWidget {
  PhoneVerificationCodeRoute({Key key}) : super(key: key);

  @override
  _PhoneVerificationCodeRouteState createState() =>
      _PhoneVerificationCodeRouteState();
}

class _PhoneVerificationCodeRouteState
    extends State<PhoneVerificationCodeRoute> {
  // bool incomplete = true;
  bool isLoading = false;
  String code = '';
  _WaitingTimeBloc _waitingTimeBloc;
  @override
  void initState() {
    super.initState();
    _waitingTimeBloc = _WaitingTimeBloc();
    _waitingTimeBloc.add(_StopWatchEvents.start);
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Login/Signup',
                style: textTheme.headline5,
              ),
              SizedBox(
                height: 40,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Enter Verification Code',
                  style: textTheme.headline5.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'We have Sent a 4 digit verification code on \n${globals.phoneAuthProvider.phoneNumber}',
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: StreamBuilder<PhoneAuthState>(
                        stream: globals.phoneAuthProvider.phoneAuthBloc,
                        builder: (context, snapshot) {
                          if (snapshot.hasData &&
                              snapshot.data == PhoneAuthState.authenticated) {
                            WidgetsBinding.instance
                                .addPostFrameCallback((timeStamp) async {
                              setState(() {
                                isLoading = true;
                              });
                              AuthResult result = await FirebaseAuth.instance
                                  .signInWithCredential(
                                      globals.phoneAuthProvider.credentials)
                                  .catchError((error) => null);
                              if (result?.user != null) {
                                setState(() {
                                  isLoading = false;
                                });
                                Navigator.of(context).pushAndRemoveUntil(
                                    CupertinoPageRoute(
                                      builder: (context) => HomeScreenRoute(),
                                      settings: RouteSettings(
                                        name: HomeScreenRoute.name,
                                      ),
                                    ),
                                    (route) => false);
                              }
                            });

                            // return OTPTextField(
                            //   length: 6,
                            //   fieldStyle: FieldStyle.box,
                            //   fieldWidth: 40,
                            //   width: 300,
                            //   onCompleted: (text) async {},
                            // );
                          }
                          return OTPTextField(
                            length: 6,
                            fieldStyle: FieldStyle.box,
                            fieldWidth: 40,
                            width: 300,
                            onCompleted: (text) async {
                              code = globals.phoneAuthProvider.verificationId;
                              setState(() {
                                isLoading = true;
                              });
                              var credentials = PhoneAuthProvider.getCredential(
                                verificationId: code,
                                smsCode: text,
                              );
                              var authResult = await FirebaseAuth.instance
                                  .signInWithCredential(credentials)
                                  .catchError((error) => null);
                              if (authResult?.user != null) {
                                Firestore.instance
                                    .collection('users')
                                    .document(authResult.user.uid)
                                    .get()
                                    .then((value) async {
                                  if (value.exists) {
                                    globals.user = User();
                                    globals.user.uid = value.documentID;
                                    User.copySnapshotToUser(
                                        globals.user, value);
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) =>
                                              HomeScreenRoute(),
                                          settings: RouteSettings(
                                            name: HomeScreenRoute.name,
                                          ),
                                        ),
                                        (route) => false);
                                  } else {
                                    globals.user = User();
                                    globals.user.phoneNumber =
                                        globals.phoneAuthProvider.phoneNumber;
                                    globals.user.uid = authResult.user.uid;
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) =>
                                            CreateAnAccountRoute(),
                                      ),
                                    );
                                  }
                                }).catchError((error) {
                                  showInSnackbar(
                                    error.toString(),
                                    context,
                                    color: Colors.red,
                                  );
                                  setState(() {
                                    isLoading = false;
                                  });
                                });
                              } else {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                          );
                        }),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 60,
                  width: 120,
                  child: StreamBuilder<int>(
                      initialData: 15,
                      stream: _waitingTimeBloc,
                      builder: (context, snapshot) {
                        return RaisedButton(
                          // initialTimer: _waitingTimeBloc?.state ?? 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          color: Colors.black,
                          onPressed: snapshot.data > 0
                              ? null
                              : () {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  globals.phoneAuthProvider.sendCode(
                                      onCodeSent: () {
                                        _waitingTimeBloc
                                            .add(_StopWatchEvents.start);
                                        setState(() {
                                          isLoading = false;
                                        });
                                      },
                                      codeAutoRetrievalTimeout: () {},
                                      verificationFailed: (str) {
                                        _waitingTimeBloc
                                            .add(_StopWatchEvents.start);
                                        setState(() {
                                          isLoading = false;
                                        });
                                        Scaffold.of(context)
                                            .showSnackBar(SnackBar(
                                          content:
                                              Text('Verification Failed: $str'),
                                          backgroundColor: Colors.red,
                                        ));
                                      },
                                      onVerificationCompleted: () async {
                                        globals.user = User();
                                        globals.user.phoneNumber = globals
                                            .phoneAuthProvider.phoneNumber;
                                        var result = await FirebaseAuth.instance
                                            .signInWithCredential(
                                          globals.phoneAuthProvider.credentials,
                                        )
                                            .catchError((error) {
                                          print(error);
                                          return null;
                                        });
                                        if (result.user != null) {
                                          globals.user.uid = result.user.uid;
                                          final snapshot = await Firestore
                                              .instance
                                              .collection('users')
                                              .document(globals.user.uid)
                                              .get();
                                          if (snapshot.exists) {
                                            User.copySnapshotToUser(
                                                globals.user, snapshot);
                                            Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                builder: (ctx) =>
                                                    HomeScreenRoute(),
                                                settings: RouteSettings(
                                                  name: HomeScreenRoute.name,
                                                ),
                                              ),
                                            );
                                          } else {
                                            Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                  builder: (crx) =>
                                                      CreateAnAccountRoute(),
                                                ));
                                          }
                                        } else {
                                          _waitingTimeBloc
                                              .add(_StopWatchEvents.start);
                                          setState(() {
                                            isLoading = false;
                                          });
                                          Scaffold.of(context)
                                              .showSnackBar(SnackBar(
                                            content:
                                                Text("Invalid Credentials"),
                                            backgroundColor: Colors.red,
                                          ));
                                        }
                                      },
                                      phoneNumber: globals
                                          .phoneAuthProvider.phoneNumber);
                                },
                          child: Text(
                            snapshot.data > 0
                                ? 'Wait | ${snapshot.data}'
                                : 'Resend OTP',
                            style: textTheme.button.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          // roundLoadingShape: false,
                          // loader: (time) {
                          //   return Text(
                          //     'Wait | $time',
                          //     style: textTheme.button.copyWith(
                          //       color: Colors.white,
                          //     ),
                          //   );
                          // },
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showInSnackbar(String text, BuildContext context,
      {Color color = Colors.black}) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
          style: Theme.of(context).textTheme.subtitle2.copyWith(
                color:
                    color.computeLuminance() == 0 ? Colors.white : Colors.black,
              ),
        ),
        backgroundColor: color,
      ),
    );
  }
}
