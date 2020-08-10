import 'package:flutter/material.dart';
import 'package:neer/globals/constants.dart' as globals;

class ContactUsRoute extends StatelessWidget {
  static final String name = "ContactUsRoute";
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Material(
        child: Padding(
          padding: EdgeInsets.only(
            left: 15,
            bottom: 10,
            right: 15,
            top: MediaQuery.of(context).padding.top + 25,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    " Contact Us",
                    style: textTheme.headline5
                        .copyWith(fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    " Get in touch...",
                    style: textTheme.headline6
                        .copyWith(fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    initialValue: globals.user?.name ?? '',
                    validator: (text) {
                      if (text != null && text.isNotEmpty) {
                        return null;
                      } else {
                        return "Please provide you name";
                      }
                    },
                    decoration: InputDecoration(labelText: 'Name'),
                  ),
                  TextFormField(
                    initialValue: globals.user?.phoneNumber ?? '',
                    validator: (text) {
                      if (text != null && text.isNotEmpty) {
                        return null;
                      } else {
                        return "Please provide you phone number";
                      }
                    },
                    decoration: InputDecoration(labelText: 'Phone Number'),
                  ),
                  TextFormField(
                    initialValue: globals.user?.email ?? '',
                    validator: (text) {
                      if (text != null && text.isNotEmpty) {
                        return null;
                      } else {
                        return "Please provide you email address";
                      }
                    },
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  TextFormField(
                    validator: (text) {
                      if (text != null && text.isNotEmpty) {
                        return null;
                      } else {
                        return "Please provide a Job Reference ID";
                      }
                    },
                    decoration: InputDecoration(labelText: 'Job Reference ID'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    minLines: 5,
                    maxLength: 200,
                    maxLines: 5,
                    validator: (value) {
                      final text = value.trim();
                      if (text != null && text.isNotEmpty && text.length > 20) {
                        return null;
                      } else if (text.length < 20) {
                        return "You message must be at least 20 characters long";
                      } else {
                        return "Please provide a message";
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      hintText:
                          'A brief message to put you with the right person',
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: RaisedButton(
                      textColor: Colors.white,
                      child: Text('  Send Message  '),
                      onPressed: () {
                        if (formKey.currentState.validate()) {
                          print('Send Message');
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
