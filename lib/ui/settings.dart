import 'package:flutter/material.dart';

class SettingsRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    bool pushSwitch = false;
    bool whatsAppSwitch = false;
    bool textSwitch = false;
    bool emailSwitch = false;
    return Scaffold(
      body: Material(
        child: Padding(
          padding: EdgeInsets.only(
            left: 15,
            bottom: 10,
            right: 15,
            top: MediaQuery.of(context).padding.top + 25,
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: StatefulBuilder(builder: (context, setState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          " Settings",
                          style: textTheme.headline5
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Row(
                          children: [
                            Text(
                              'Push',
                              style: textTheme.caption.copyWith(
                                fontSize: textTheme.headline6.fontSize,
                              ),
                            ),
                            Spacer(),
                            Switch(
                              value: pushSwitch,
                              onChanged: (value) {
                                setState(() {
                                  pushSwitch = value;
                                });
                              },
                              activeColor: Colors.black,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'WhatsApp',
                              style: textTheme.caption.copyWith(
                                fontSize: textTheme.headline6.fontSize,
                              ),
                            ),
                            Spacer(),
                            Switch(
                              value: whatsAppSwitch,
                              onChanged: (value) {
                                setState(() {
                                  whatsAppSwitch = value;
                                });
                              },
                              activeColor: Colors.black,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Text',
                              style: textTheme.caption.copyWith(
                                fontSize: textTheme.headline6.fontSize,
                              ),
                            ),
                            Spacer(),
                            Switch(
                              value: textSwitch,
                              onChanged: (value) {
                                setState(() {
                                  textSwitch = value;
                                });
                              },
                              activeColor: Colors.black,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Email',
                              style: textTheme.caption.copyWith(
                                fontSize: textTheme.headline6.fontSize,
                              ),
                            ),
                            Spacer(),
                            Switch(
                              value: emailSwitch,
                              onChanged: (value) {
                                setState(() {
                                  emailSwitch = value;
                                });
                              },
                              activeColor: Colors.black,
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: RaisedButton(
                  onPressed: () {},
                  textColor: Colors.white,
                  color: Colors.red,
                  child: Text(
                    'DELETE ACCOUNT',
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
