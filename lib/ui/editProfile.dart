import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:neer/globals/constants.dart' as globals;
import 'package:neer/globals/methods.dart' as methods;
import 'package:neer/models/user.dart';
import 'package:neer/widgets/customDialogWidget.dart';

class EditProfileRoute extends StatelessWidget {
  static final String name = "EditProfileRoute";
  final GlobalKey<FormState> formState = GlobalKey<FormState>();
  final User tempUser = User();

  EditProfileRoute({
    Key key,
  }) : super(key: key) {
    tempUser.name = globals.user.name;
    tempUser.city = globals.user.city;
    tempUser.email = globals.user.email;
    tempUser.phoneNumber = globals.user.phoneNumber;
    tempUser.uid = globals.user.uid;
  }

  @override
  Widget build(BuildContext context) {
    // globals.waitingTimeBloc.add(StopWatchEvents.start);
    bool isLoading = false;
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.white,
      body: StatefulBuilder(builder: (context, setState) {
        return ModalProgressHUD(
          inAsyncCall: isLoading,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 40,
            ),
            child: SingleChildScrollView(
              child: Form(
                key: formState,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Create An Account',
                      style: textTheme.headline5,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    TextFormField(
                      initialValue: tempUser.name,
                      validator: (text) {
                        if (text != null && text.length > 3) {
                          tempUser.name = text;
                          return null;
                        }
                        return (text ?? '').isEmpty
                            ? "Your name is required"
                            : "Name should be at least 3 letter long";
                      },
                      maxLength: 30,
                      maxLines: 1,
                      minLines: 1,
                      decoration: InputDecoration(
                        hintText: "John Smith",
                        labelText: "Full Name",
                        border: UnderlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      initialValue: tempUser.phoneNumber,
                      decoration: InputDecoration(
                        helperText: "e.g. +91XXXXXXXXXX",
                      ),
                      validator: (text) {
                        if (text != null && text.length > 7) {
                          tempUser.phoneNumber = text;
                          return null;
                        } else {
                          return "Invalid phone number";
                        }
                      },
                      style: textTheme.subtitle2,
                      enabled: false,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      initialValue: tempUser.email,
                      validator: (text) {
                        if (text != null && text.contains('@')) {
                          tempUser.email = text;
                          return null;
                        } else {
                          return "Invalid Email";
                        }
                      },
                      maxLength: 50,
                      maxLines: 1,
                      minLines: 1,
                      decoration: InputDecoration(
                        labelText: "Email",
                        hintText: "JohnSmith@email.com",
                      ),
                    ),
                    TextFormField(
                      initialValue: tempUser.city,
                      validator: (text) {
                        if (text != null && text.length > 2) {
                          tempUser.city = text;
                          return null;
                        } else if (text == null || text == '') {
                          return "City is Required";
                        } else {
                          return "City Name Should be at least 3 character long";
                        }
                      },
                      maxLength: 50,
                      maxLines: 1,
                      minLines: 1,
                      decoration: InputDecoration(
                        labelText: "City",
                      ),
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: <Widget>[
                    //     Checkbox(
                    //         value: isTermsAccepted,
                    //         onChanged: (value) {
                    //           setState(() {
                    //             isTermsAccepted = value;
                    //           });
                    //         }),
                    //     // SizedBox(
                    //     //   width: 10,
                    //     // ),
                    //   ],
                    // ),
                    Align(
                      alignment: Alignment.center,
                      child: RaisedButton(
                        onPressed: () async {
                          // showDialog<bool>(
                          //   context: context,
                          //   child: CodeVerificationDialog(
                          //     phoneNumber: globals.user.phoneNumber,
                          //   ),
                          // );
                          // return;
                          if (formState.currentState.validate()) {
                            if (globals.waitingTimeBloc.state > 0) {
                              setState(() {
                                isLoading = true;
                              });
                              bool result =
                                  await showVerificationDialog(context);
                              if (result != null && result) {
                                await updateUser(context);
                                setState(() {
                                  isLoading = false;
                                });
                              }
                              return;
                            } else {
                              FirebaseAuth.instance.verifyPhoneNumber(
                                  phoneNumber: tempUser.phoneNumber,
                                  timeout: Duration(milliseconds: 1),
                                  verificationCompleted: (credentials) async {
                                    globals.phoneAuthProvider.credentials =
                                        credentials;
                                    await updateUser(context);
                                    setState(() {
                                      isLoading = false;
                                    });
                                  },
                                  verificationFailed: (err) {
                                    methods.showInSnackbar(
                                      err.message,
                                      context,
                                    );
                                  },
                                  codeSent: (verificationId, [forceResend]) {
                                    globals.phoneAuthProvider.verificationId =
                                        verificationId;
                                  },
                                  codeAutoRetrievalTimeout:
                                      (verificationId) async {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    globals.phoneAuthProvider.verificationId =
                                        verificationId;
                                    bool result =
                                        await showVerificationDialog(context);
                                    if (result == null) {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      return;
                                    } else if (result) {
                                      await updateUser(context);
                                    }
                                    setState(() {
                                      isLoading = false;
                                    });
                                  });
                              // globals.phoneAuthProvider.sendCode(
                              //   phoneNumber: globals.user.phoneNumber,
                              //   timeout: 1,
                              //   onCodeSent: () async {
                              //     print('Code Sent');
                              //     globals.waitingTimeBloc
                              //         .add(StopWatchEvents.start);
                              //     bool result =
                              //         await showVerificationDialog(context);
                              //     if (result != null && result) {
                              //       updateUser(context);
                              //     }
                              //   },
                              //   onVerificationCompleted: () async {
                              //     try {
                              //       final authResult = await FirebaseAuth
                              //           .instance
                              //           .signInWithCredential(globals
                              //               .phoneAuthProvider.credentials);
                              //       if (authResult?.user == null) {
                              //         bool result =
                              //             await showVerificationDialog(context);
                              //         if (result ?? false) {
                              //           updateUser(context);
                              //         } else {
                              //           return;
                              //         }
                              //       } else {
                              //         updateUser(context);
                              //       }
                              //     } catch (ex) {
                              //       print(ex);
                              //       bool result =
                              //           await showVerificationDialog(context);
                              //       if (result ?? false) {
                              //         updateUser(context);
                              //       } else {
                              //         return;
                              //       }
                              //       return;
                              //     }
                              //     print('complete');
                              //   },
                              //   codeAutoRetrievalTimeout: () {
                              //     print('timeout');
                              //   },
                              //   verificationFailed: (err) {
                              //     print('$err');
                              //     methods.showInSnackbar(err, context);
                              //   },
                              // );
                            }
                          }
                        },
                        color: Colors.black,
                        textColor: Colors.white,
                        child: Text('Update Now'),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Future updateUser(BuildContext context) async {
    globals.user = tempUser;
    await Firestore.instance
        .collection('users')
        .document(tempUser.uid)
        .setData(
          globals.user.toMap(),
        )
        .then((value) {
      methods.showInSnackbar(
        'Information Updated',
        context,
      );
    }).catchError((error) {
      print(error);
      methods.showInSnackbar(
        '$error',
        context,
        color: Colors.red,
      );
    });
  }

  Future<bool> showVerificationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      child: CodeVerificationDialog(
        phoneNumber: globals.user.phoneNumber,
      ),
    );
  }
}
