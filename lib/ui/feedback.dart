import 'package:flutter/material.dart';

class FeedBackRoute extends StatelessWidget {
  static final name = "FeedBackRoute";

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Material(
        child: Padding(
          padding: EdgeInsets.only(
            left: 15,
            bottom: 10,
            right: 15,
            top: MediaQuery.of(context).padding.top + 25,
          ),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  " Feedback",
                  style:
                      textTheme.headline5.copyWith(fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: 25,
                ),
                Text(
                  " And we're listening...!",
                  style:
                      textTheme.headline6.copyWith(fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: 25,
                ),
                TextFormField(
                  minLines: 8,
                  maxLength: 200,
                  maxLines: 8,
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
                    hintText: 'How may we help you?',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.center,
                  child: RaisedButton(
                    textColor: Colors.white,
                    child: Text('  Submit  '),
                    onPressed: () {
                      if (formKey.currentState.validate()) {
                        print('Submitted');
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
    );
  }
}
