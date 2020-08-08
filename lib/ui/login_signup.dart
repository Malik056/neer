import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neer/globals/constants.dart' as globals;
import 'package:neer/ui/phoneVerificationCodePage.dart';

class _PhoneNumberDropDownValue {
  String value = "+92";
}

class PhoneNumberAuthRoute extends StatelessWidget {
  final _PhoneNumberDropDownValue downValue = _PhoneNumberDropDownValue();
  final TextEditingController _phoneNumberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
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
                    onChanged: (a) {
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
                child: StatefulBuilder(builder: (context, setState) {
                  return RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.all(15),
                    onPressed: isLoading
                        ? null
                        : () {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                isLoading = false;
                              });
                              globals.phoneAuthProvider.sendCode(
                                  phoneNumber: downValue.value +
                                      _phoneNumberController.text.trim(),
                                  codeAutoRetrievalTimeout: () {},
                                  onCodeSent: () {
                                    Navigator.of(context).push(
                                      CupertinoPageRoute(
                                        builder: (ctx) {
                                          return PhoneVerificationCodeRoute();
                                        },
                                      ),
                                    );
                                  },
                                  onVerificationCompleted: () async {},
                                  verificationFailed: (str) {
                                    showInSnackbar('Error: $str', context);
                                  });
                            }
                          },
                    color: Colors.black,
                    child: Text(
                      "Login/Signup",
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
