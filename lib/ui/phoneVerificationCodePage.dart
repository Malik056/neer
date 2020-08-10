import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:neer/bloc/phoneAuthBloc.dart';
import 'package:neer/bloc/waitTimeBloc.dart';
import 'package:neer/globals/constants.dart' as globals;
import 'package:neer/globals/methods.dart' as methods;
import 'package:neer/models/user.dart';
import 'package:neer/ui/createAnAccount.dart';
import 'package:neer/ui/homeScreen.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

class PhoneVerificationCodeRoute extends StatefulWidget {
  static final String name = "PhoneVerificationCodeRoute";
  PhoneVerificationCodeRoute({Key key}) : super(key: key);

  @override
  _PhoneVerificationCodeRouteState createState() =>
      _PhoneVerificationCodeRouteState();
}

class _PhoneVerificationCodeRouteState
    extends State<PhoneVerificationCodeRoute> {
  bool isLoading = false;
  String code = '';
  WaitingTimeBloc _waitingTimeBloc;
  bool stopAutoAuth = false;

  @override
  void initState() {
    super.initState();
    _waitingTimeBloc = globals.waitingTimeBloc;
    _waitingTimeBloc.add(StopWatchEvents.start);
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: StreamBuilder<PhoneAuthState>(
        stream: globals.phoneAuthProvider.phoneAuthBloc,
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.data == PhoneAuthState.authenticated) {
            globals.phoneAuthProvider.phoneAuthBloc.add(PhoneAuthState.idle);
            if (!stopAutoAuth) {
              WidgetsBinding.instance.addPostFrameCallback(
                (timeStamp) async {
                  isLoading = true;
                  bool exists = await globals.phoneAuthProvider.signIn();
                  if (exists == null) {
                    isLoading = false;
                  } else if (exists) {
                    Navigator.of(context).pushAndRemoveUntil(
                      CupertinoPageRoute(
                        builder: (context) => HomeScreenRoute(),
                        settings: RouteSettings(
                          name: HomeScreenRoute.name,
                        ),
                      ),
                      (route) => false,
                    );
                  } else {
                    Navigator.of(context).pushAndRemoveUntil(
                      CupertinoPageRoute(
                        builder: (context) => CreateAnAccountRoute(),
                        settings: RouteSettings(
                          name: CreateAnAccountRoute.name,
                        ),
                      ),
                      (route) => false,
                    );
                  }
                },
              );
            }
          }
          return StatefulBuilder(builder: (context, setState) {
            return ModalProgressHUD(
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
                        'We have Sent a 6 digit verification code on \n${globals.phoneAuthProvider.phoneNumber}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: OTPTextField(
                            length: 6,
                            fieldStyle: FieldStyle.box,
                            fieldWidth: 40,
                            width: 300,
                            onCompleted: (text) async {
                              stopAutoAuth = true;
                              code = globals.phoneAuthProvider.verificationId;
                              setState(() {
                                isLoading = true;
                              });
                              try {
                                var credentials =
                                    PhoneAuthProvider.getCredential(
                                  verificationId: code,
                                  smsCode: text,
                                );
                                globals.phoneAuthProvider.credentials =
                                    credentials;
                                signIn(credentials);
                              } catch (err) {
                                methods.showInSnackbar('Bad OTP', context);
                                stopAutoAuth = false;
                                print(err);
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                          ),
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
                            initialData: 30,
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
                                        _waitingTimeBloc
                                            .add(StopWatchEvents.start);
                                        FirebaseAuth.instance.verifyPhoneNumber(
                                            phoneNumber: globals
                                                .phoneAuthProvider.phoneNumber,
                                            timeout: Duration(seconds: 30),
                                            verificationCompleted:
                                                (credentials) {
                                              globals.phoneAuthProvider
                                                  .phoneAuthBloc
                                                  .add(PhoneAuthState
                                                      .authenticated);
                                              globals.phoneAuthProvider
                                                  .credentials = credentials;
                                              signIn(credentials);
                                            },
                                            verificationFailed: (ex) {
                                              globals.phoneAuthProvider
                                                  .phoneAuthBloc
                                                  .add(PhoneAuthState
                                                      .authenticationFailed);
                                              methods.showInSnackbar(
                                                ex.message,
                                                context,
                                              );
                                              setState(() {
                                                isLoading = false;
                                              });
                                            },
                                            codeSent: (code, [forceResending]) {
                                              globals.phoneAuthProvider
                                                  .phoneAuthBloc
                                                  .add(PhoneAuthState.codeSent);
                                              globals.phoneAuthProvider
                                                  .verificationId = code;
                                            },
                                            codeAutoRetrievalTimeout:
                                                (verificationId) {
                                              globals.phoneAuthProvider
                                                  .verificationId = code;
                                            });
                                      },
                                child: Text(
                                  snapshot.data > 0
                                      ? 'Wait | ${snapshot.data}'
                                      : 'Resend OTP',
                                  style: textTheme.button.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Future signIn(credentials) async {
    if (credentials == null) {
      stopAutoAuth = false;
      setState(() {
        isLoading = false;
      });
      return;
    }
    try {
      bool result = await globals.phoneAuthProvider.signIn();
      if (result ?? false) {
        Navigator.pushAndRemoveUntil(
            context,
            CupertinoPageRoute(
              builder: (context) => HomeScreenRoute(),
              settings: RouteSettings(
                name: HomeScreenRoute.name,
              ),
            ),
            (route) => false);
      } else {
        globals.user = User();
        globals.user.phoneNumber = globals.phoneAuthProvider.phoneNumber;
        globals.user.uid = (await FirebaseAuth.instance.currentUser()).uid;
        setState(() {
          isLoading = false;
        });
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => CreateAnAccountRoute(),
            settings: RouteSettings(
              name: CreateAnAccountRoute.name,
            ),
          ),
        );
      }
    } catch (ex) {
      stopAutoAuth = false;
      methods.showInSnackbar('$ex', context);
    }
    var authResult = await FirebaseAuth.instance
        .signInWithCredential(credentials)
        .catchError((error) {
      print(error);
      return null;
    });
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
            globals.user,
            value,
          );
          Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute(
                builder: (context) => HomeScreenRoute(),
                settings: RouteSettings(
                  name: HomeScreenRoute.name,
                ),
              ),
              (route) => false);
        } else {
          globals.user = User();
          globals.user.phoneNumber = globals.phoneAuthProvider.phoneNumber;
          globals.user.uid = authResult.user.uid;
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => CreateAnAccountRoute(),
              settings: RouteSettings(
                name: CreateAnAccountRoute.name,
              ),
            ),
          );
        }
      }).catchError((error) {
        methods.showInSnackbar(
          error.toString(),
          context,
          color: Colors.red,
        );
        stopAutoAuth = false;
        setState(() {
          isLoading = false;
        });
      });
    } else {
      methods.showInSnackbar('Bad OTP', context);
      stopAutoAuth = false;
      setState(() {
        isLoading = false;
      });
    }
  }
}
