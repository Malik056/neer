import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neer/ui/contactUs.dart';

class HelpCenterRoute extends StatelessWidget {
  static final String name = "HelpCenter";

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 20,
          left: 20,
          right: 20,
          bottom: 20,
        ),
        child: Column(
          children: [
            Text(
              'My Jobs',
              style: textTheme.headline5,
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ExpandableNotifier(
                      child: ScrollOnExpand(
                        child: Container(
                          padding: EdgeInsets.only(
                            bottom: 10,
                          ),
                          decoration: BoxDecoration(
                              border: Border(
                            bottom: BorderSide(
                                color: Colors.black,
                                width: 1,
                                style: BorderStyle.solid),
                          )),
                          child: ExpandablePanel(
                            header: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                'FAQ',
                                style: textTheme.headline6,
                              ),
                            ),
                            expanded: Container(),
                          ),
                        ),
                      ),
                    ),
                    ExpandableNotifier(
                      child: ScrollOnExpand(
                        child: Container(
                          padding: EdgeInsets.only(
                            bottom: 10,
                          ),
                          decoration: BoxDecoration(
                              border: Border(
                            bottom: BorderSide(
                                color: Colors.black,
                                width: 1,
                                style: BorderStyle.solid),
                          )),
                          child: ExpandablePanel(
                            header: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                'Recommended Topics',
                                style: textTheme.headline6,
                              ),
                            ),
                            expanded: Container(),
                          ),
                        ),
                      ),
                    ),
                    ExpandableNotifier(
                      child: ScrollOnExpand(
                        child: Container(
                          padding: EdgeInsets.only(
                            bottom: 10,
                          ),
                          decoration: BoxDecoration(
                              border: Border(
                            bottom: BorderSide(
                                color: Colors.black,
                                width: 1,
                                style: BorderStyle.solid),
                          )),
                          child: ExpandablePanel(
                            header: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                'All Topics',
                                style: textTheme.headline6,
                              ),
                            ),
                            expanded: Container(),
                          ),
                        ),
                      ),
                    ),
                    ExpandableNotifier(
                      child: ScrollOnExpand(
                        child: Container(
                          padding: EdgeInsets.only(
                            bottom: 10,
                          ),
                          decoration: BoxDecoration(
                              border: Border(
                            bottom: BorderSide(
                                color: Colors.black,
                                width: 1,
                                style: BorderStyle.solid),
                          )),
                          child: ExpandablePanel(
                            header: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                'Service Agreements',
                                style: textTheme.headline6,
                              ),
                            ),
                            expanded: Container(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Text(
                  'Still need help?',
                  style: textTheme.subtitle2,
                ),
                Spacer(),
                RaisedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => ContactUsRoute(),
                        settings: RouteSettings(
                          name: ContactUsRoute.name,
                        ),
                      ),
                    );
                  },
                  textColor: Colors.white,
                  child: Text('Contact ICCW'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
