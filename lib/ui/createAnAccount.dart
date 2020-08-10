import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:neer/globals/constants.dart' as globals;
import 'package:neer/ui/homeScreen.dart';

class CreateAnAccountRoute extends StatelessWidget {
  final GlobalKey<FormState> formState = GlobalKey<FormState>();

  static var name = "CreateAnAccountRoute";

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

  @override
  Widget build(BuildContext context) {
    bool isTermsAccepted = false;
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
                      validator: (text) {
                        if (text != null && text.length > 3) {
                          globals.user.name = text;
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
                    TextField(
                      controller: TextEditingController()
                        ..text = globals.user.phoneNumber,
                      style: textTheme.subtitle2,
                      enabled: false,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: (text) {
                        if (text != null && text.contains('@')) {
                          globals.user.email = text;
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
                      validator: (text) {
                        if (text != null && text.length > 2) {
                          globals.user.city = text;
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Checkbox(
                            value: isTermsAccepted,
                            onChanged: (value) {
                              setState(() {
                                isTermsAccepted = value;
                              });
                            }),
                        // SizedBox(
                        //   width: 10,
                        // ),
                        Text.rich(
                          TextSpan(
                            text: 'I agree with ',
                            children: [
                              TextSpan(
                                text: 'Terms And Conditions',
                                style: textTheme.bodyText2
                                    .copyWith(color: Colors.blue),
                              )
                            ],
                          ),
                          style: textTheme.bodyText2,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: RaisedButton(
                        onPressed: () async {
                          if (!isTermsAccepted) {
                            showInSnackbar(
                              "You need to accept terms and Conditions",
                              context,
                              color: Colors.red,
                            );
                          }
                          if (formState.currentState.validate()) {
                            if (globals.connectivityBloc.state !=
                                ConnectivityResult.none) {
                              setState(() {
                                isLoading = true;
                              });
                              Firestore.instance
                                  .collection('users')
                                  .document(globals.user.uid)
                                  .setData(
                                    globals.user.toMap(),
                                  )
                                  .then((value) {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => HomeScreenRoute(),
                                      settings: RouteSettings(
                                        name: HomeScreenRoute.name,
                                      ),
                                    ),
                                    (route) => false);
                              }).catchError((error) {
                                setState(() {
                                  isLoading = false;
                                });
                              });
                            } else {
                              showInSnackbar(
                                'No Internet Connection!',
                                context,
                                color: Colors.yellow[600],
                              );
                            }
                          }
                        },
                        color: Colors.black,
                        textColor: Colors.white,
                        child: Text('Create Account'),
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
}
