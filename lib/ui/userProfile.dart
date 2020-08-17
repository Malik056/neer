import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:neer/globals/constants.dart' as globals;
import 'package:neer/globals/methods.dart' as methods;
import 'package:neer/ui/editProfile.dart';
import 'package:neer/ui/feedback.dart';
import 'package:neer/ui/helpCenter.dart';
import 'package:neer/ui/login_signup.dart';

class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    bool isLoading = false;
    return Scaffold(
      body: StatefulBuilder(builder: (context, setState) {
        return ModalProgressHUD(
          inAsyncCall: isLoading,
          child: Material(
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            " My Profile",
                            style: textTheme.headline5
                                .copyWith(fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Text(
                            globals.user?.name ?? '',
                            style: textTheme.bodyText2,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      globals.user?.email ?? '',
                                      style: textTheme.bodyText2,
                                    ),
                                    Text(
                                      globals.user?.phoneNumber ?? '',
                                      style: textTheme.bodyText2,
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  //REMOVED: Link To Edit Profile
                                  // Navigator.push(
                                  //     context,
                                  //     CupertinoPageRoute(
                                  //       builder: (context) {
                                  //         return EditProfileRoute();
                                  //       },
                                  //       settings: RouteSettings(
                                  //         name: EditProfileRoute.name,
                                  //       ),
                                  //     ));
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          FlatButton.icon(
                            onPressed: () {
                              //REMOVED: Link to HelpCenterRoute
                              // Navigator.push(
                              //   context,
                              //   CupertinoPageRoute(
                              //     builder: (context) {
                              //       return HelpCenterRoute();
                              //     },
                              //     settings: RouteSettings(
                              //       name: HelpCenterRoute.name,
                              //     ),
                              //   ),
                              // );
                            },
                            icon: Image.asset(
                              'images/support.png',
                              width: 32,
                              height: 32,
                            ),
                            label: Text('Help Center'),
                          ),
                          FlatButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.file_download),
                            label: Text('Download Provider App'),
                          ),
                          FlatButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.info_outline),
                            label: Text('About ICCW'),
                          ),
                          FlatButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.share),
                            label: Text('Share Us'),
                          ),
                          FlatButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.stars),
                            label: Text('Rate Us'),
                          ),
                          FlatButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.settings),
                            label: Text('Settings'),
                          ),
                          FlatButton.icon(
                            onPressed: () {},
                            icon: Icon(FontAwesomeIcons.solidHandshake),
                            label: Text('Terms Of Service'),
                          ),
                          FlatButton.icon(
                            onPressed: () {
                              //REMOVED: Feedback route
                              // Navigator.of(context).push(
                              //   CupertinoPageRoute(
                              //     builder: (context) {
                              //       return FeedBackRoute();
                              //     },
                              //     settings: RouteSettings(
                              //       name: FeedBackRoute.name,
                              //     ),
                              //   ),
                              // );
                            },
                            icon: Icon(Icons.rate_review),
                            label: Text('Give us feedback'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: RaisedButton(
                      textColor: Colors.white,
                      child: Text('Logout'),
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        String error = await globals.phoneAuthProvider.logout();
                        setState(() {
                          isLoading = false;
                        });
                        if (error != null) {
                          methods.showInSnackbar('$error', context);
                        }
                        globals.user = null;
                        globals.openRequestBloc.close();
                        Navigator.of(context).pushAndRemoveUntil(
                            CupertinoPageRoute(
                              builder: (context) => PhoneNumberAuthRoute(),
                              settings: RouteSettings(
                                name: PhoneNumberAuthRoute.name,
                              ),
                            ),
                            (route) => false);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
