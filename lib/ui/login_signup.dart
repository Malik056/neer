import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:neer/bloc/phoneAuthBloc.dart';
import 'package:neer/globals/constants.dart' as globals;
import 'package:neer/ui/phoneVerificationCodePage.dart';

class _PhoneNumberDropDownValue {
  String value = "+92";
}

class PhoneNumberAuthRoute extends StatelessWidget {
  static final String name = "PhoneNumberAuthRoute";
  final _PhoneNumberDropDownValue downValue = _PhoneNumberDropDownValue();
  final TextEditingController _phoneNumberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.white,
      body: StatefulBuilder(builder: (context, setState) {
        return ModalProgressHUD(
          inAsyncCall: isLoading,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 40.0,
              horizontal: 20,
            ),
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
                    'Login/Signup',
                    style: textTheme.headline5.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                // InternationalPhoneNumberInput(
                //   autoValidate: false,
                //   onInputValidated: (value) {},
                //   hintText: "Mobile Number",
                //   initialValue: PhoneNumber(dialCode: "+1"),
                //   ignoreBlank: true,
                // ),
                Row(
                  children: <Widget>[
                    StatefulBuilder(
                      builder: (ctx, setState) => DropdownButton<String>(
                        value: downValue.value,
                        onTap: null,
                        items: List<DropdownMenuItem<String>>.generate(
                          globals.phoneNumberCountryCodes.length,
                          (index) {
                            return DropdownMenuItem<String>(
                              child: Text(
                                globals.phoneNumberCountryCodes[index],
                              ),
                              value: globals.phoneNumberCountryCodes[index],
                            );
                          },
                        ),
                        onChanged:
                            // null, //REMOVED: on Changed dropdown feature, fixed dropdown to +91
                            (a) {
                          setState(() {
                            downValue.value = a;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          maxLength: 12,
                          minLines: 1,
                          maxLines: 1,
                          validator: (text) {
                            if (text != null &&
                                text.isNotEmpty &&
                                text.length > 7) {
                              return null;
                            } else {
                              return "Please Enter a valid number";
                            }
                          },
                          controller: _phoneNumberController,
                          keyboardType: TextInputType.numberWithOptions(
                            decimal: false,
                            signed: false,
                          ),
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: "Mobile Number",
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 200,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.all(15),
                      onPressed: () {
                        if (globals.connectivityBloc.state ==
                            ConnectivityResult.none) {
                          showInSnackbar(
                            'No Internet Connection',
                            context,
                            color: Colors.red,
                          );
                          return;
                        }
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          globals.phoneAuthProvider.phoneNumber =
                              downValue.value +
                                  _phoneNumberController.text.trim();
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) {
                                return PhoneVerificationCodeRoute();
                              },
                              settings: RouteSettings(
                                name: PhoneVerificationCodeRoute.name,
                              ),
                            ),
                          );
                          FirebaseAuth.instance.verifyPhoneNumber(
                            phoneNumber: downValue.value +
                                _phoneNumberController.text.trim(),
                            timeout: Duration(seconds: 10),
                            verificationCompleted: (credentials) async {
                              globals.phoneAuthProvider.phoneAuthBloc
                                  .add(PhoneAuthState.authenticated);
                              globals.phoneAuthProvider.credentials =
                                  credentials;
                              globals.phoneAuthProvider.phoneAuthBloc
                                  .add(PhoneAuthState.authenticated);
                              setState(() {
                                isLoading = false;
                              });
                            },
                            verificationFailed: (err) {
                              globals.phoneAuthProvider.phoneAuthBloc
                                  .add(PhoneAuthState.authenticationFailed);
                              globals.phoneAuthProvider.phoneAuthBloc
                                  .add(PhoneAuthState.authenticationFailed);
                              setState(() {
                                isLoading = false;
                              });
                              showInSnackbar(err.message, context);
                            },
                            codeSent: (verId, [forceResendingCode]) {
                              globals.phoneAuthProvider.phoneAuthBloc
                                  .add(PhoneAuthState.codeSent);
                              globals.phoneAuthProvider.verificationId = verId;
                              globals.phoneAuthProvider.phoneAuthBloc.add(
                                PhoneAuthState.codeSent,
                              );
                              setState(() {
                                isLoading = false;
                              });
                              showInSnackbar('Code Sent', context);
                            },
                            codeAutoRetrievalTimeout: (verificationId) {},
                          );
                        }
                      },
                      color: Colors.black,
                      child: Text(
                        "Login/Signup",
                        style: textTheme.button.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
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
