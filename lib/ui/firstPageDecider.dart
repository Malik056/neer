import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neer/globals/constants.dart';
import 'package:neer/models/user.dart';
import 'package:neer/ui/createAnAccount.dart';
import 'package:neer/ui/homeScreen.dart';
import 'package:neer/ui/login_signup.dart';
import '../globals/methods.dart' as methods;

class FirstPageDecider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "N E E R",
                  style: Theme.of(context).textTheme.headline3.copyWith(
                        color: Colors.white,
                      ),
                ),
                SizedBox(
                  height: 20,
                ),
                StatefulBuilder(builder: (context, setState) {
                  return FutureBuilder<FirebaseUser>(
                    future: FirebaseAuth.instance.currentUser(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (connectivityBloc.state == ConnectivityResult.none) {
                        WidgetsBinding.instance
                            .addPostFrameCallback((timeStamp) {
                          showInSnackbar('Waiting for Connection', context);
                        });

                        connectivityBloc.listen((state) {
                          if (state != ConnectivityResult.none) {
                            WidgetsBinding.instance
                                .addPostFrameCallback((timeStamp) {
                              setState(() {});
                            });
                          }
                        });
                        return CircularProgressIndicator();
                      }
                      if (snapshot.connectionState != ConnectionState.waiting) {
                        if (snapshot.data == null) {
                          WidgetsBinding.instance
                              .addPostFrameCallback((timeStamp) {
                            Navigator.of(context).pushReplacement(
                              CupertinoPageRoute(
                                builder: (c) => PhoneNumberAuthRoute(),
                              ),
                            );
                          });
                        } else {
                          user = User();
                          user.phoneNumber = snapshot.data.phoneNumber;
                          user.uid = snapshot.data.uid;
                          methods
                              .getUserFromFirebase(snapshot.data.uid)
                              .then((value) {
                            if (value) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => HomeScreenRoute(),
                                      settings: RouteSettings(
                                        name: HomeScreenRoute.name,
                                      ),
                                    ),
                                    (route) => false);
                              });
                            } else if (!value) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) =>
                                          CreateAnAccountRoute(),
                                    ),
                                    (route) => false);
                              });
                            } else {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                showInSnackbar(
                                  'Something Wrong! Retrying',
                                  context,
                                  color: Colors.red,
                                );
                                setState(() {});
                              });
                            }
                          });
                        }
                      }
                      return CircularProgressIndicator();
                    },
                  );
                }),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 10,
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                'Powered By ICCW',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
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
