import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:neer/globals/constants.dart';
import 'package:neer/globals/methods.dart' as methods;
import 'package:neer/models/openRequest.dart';
import 'package:neer/models/requestStatus.dart';
import 'package:neer/models/serviceType.dart';
import 'package:neer/ui/homeScreen.dart';
import 'package:neer/ui/thankyouRoute.dart';

class RainWaterRoute extends StatefulWidget {
  static String routeName = "RainWaterRoute";
  @override
  State<StatefulWidget> createState() {
    return RainWaterRouteState();
  }
}

class _WaterSourcesProvider {
  String name;
  bool selected;
  _WaterSourcesProvider(this.name, this.selected);
}

class RainWaterRouteState extends State<RainWaterRoute> {
  String roofType;
  bool existingSetup;
  bool demandBeingMet;
  final _formKey = GlobalKey<FormState>();
  List<_WaterSourcesProvider> sources = [
    _WaterSourcesProvider('Municipal Water', false),
    _WaterSourcesProvider('Ground Water', false),
    _WaterSourcesProvider('Outsourced', false),
    _WaterSourcesProvider('Bubbletop', false),
  ];
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Builder(builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 10,
            bottom: 10,
            right: 10,
            top: MediaQuery.of(context).padding.top + 25,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Rain Water Harvesting",
                    style: textTheme.headline5
                        .copyWith(fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    "Help us understand, a little better...",
                    style: textTheme.headline6.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value == '') {
                        return "This field is required";
                      }
                      rainWaterDataProvider.rainWater.jobAddress = value;
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Job Site Address",
                      border: UnderlineInputBorder(),
                      suffixIcon: Icon(Icons.my_location),
                    ),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value == '') {
                        return "This field is required";
                      }
                      rainWaterDataProvider.rainWater.serviceArea = value;
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Approximate Service Area",
                      border: UnderlineInputBorder(),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        "Roof Type: ",
                        style: textTheme.subtitle2,
                      ),
                      // SizedBox(
                      //   width: 40,
                      // ),
                      Expanded(
                        child: RadioGroup<String>.builder(
                          horizontalAlignment: MainAxisAlignment.spaceAround,
                          direction: Axis.horizontal,
                          groupValue: roofType,
                          onChanged: (value) {
                            rainWaterDataProvider.rainWater.roofType = value;
                            setState(() {
                              roofType = value;
                            });
                          },
                          items: ['Flat', 'Sloping'],
                          itemBuilder: (value) => RadioButtonBuilder(
                            value,
                            textPosition: RadioButtonTextPosition.right,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  Text(
                    "Existing Rain Water harvest setup / structure?",
                    style: textTheme.subtitle2,
                  ),
                  Container(
                    width: 200,
                    child: RadioGroup<bool>.builder(
                      horizontalAlignment: MainAxisAlignment.spaceBetween,
                      direction: Axis.horizontal,
                      groupValue: existingSetup,
                      onChanged: (value) {
                        rainWaterDataProvider.rainWater.existingSetupAvailable =
                            value;
                        setState(() {
                          existingSetup = value;
                        });
                      },
                      items: [true, false],
                      itemBuilder: (value) => RadioButtonBuilder(
                        value ? 'Yes' : "No",
                        textPosition: RadioButtonTextPosition.right,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Sources To Meet the demand at present?",
                    style: textTheme.subtitle2,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  for (int i = 0; i < sources.length; i++)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                            visualDensity: VisualDensity.compact,
                            value: sources[i].selected,
                            activeColor: Colors.black,
                            onChanged: (value) {
                              if (value) {
                                rainWaterDataProvider.rainWater.sources
                                    .add(sources[i].name);
                              } else {
                                rainWaterDataProvider.rainWater.sources
                                    .remove(sources[i].name);
                              }
                              setState(() {
                                sources[i].selected = !sources[i].selected;
                              });
                            }),
                        SizedBox(
                          height: 10,
                        ),
                        Text('${sources[i].name}'),
                      ],
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Is the demand being met?',
                    style: textTheme.subtitle2,
                  ),
                  Container(
                    width: 200,
                    child: RadioGroup<bool>.builder(
                      horizontalAlignment: MainAxisAlignment.spaceBetween,
                      direction: Axis.horizontal,
                      groupValue: demandBeingMet,
                      onChanged: (value) {
                        rainWaterDataProvider.rainWater.demandBeingMet = value;
                        setState(() {
                          demandBeingMet = value;
                        });
                      },
                      items: [true, false],
                      itemBuilder: (value) => RadioButtonBuilder(
                        value ? 'Yes' : "No",
                        textPosition: RadioButtonTextPosition.right,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 130,
                      height: 44,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        color: Colors.black,
                        textColor: Colors.white,
                        child: Text('Next'),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            if (roofType != null &&
                                demandBeingMet != null &&
                                existingSetup != null) {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => _RainWaterForm2Route(),
                                  settings: RouteSettings(
                                    name: _RainWaterForm2Route.name,
                                  ),
                                ),
                              );
                            } else {
                              methods.showInSnackbar(
                                'Error: Missing some information',
                                context,
                                color: Colors.red,
                              );
                            }
                          }
                        },
                      ),
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

class _RainWaterForm2Route extends StatefulWidget {
  static final String name = "_RainWaterForm2Route";
  @override
  State<StatefulWidget> createState() {
    return _RainWaterForm2RouteState();
  }
}

class _RainWaterForm2RouteState extends State<_RainWaterForm2Route> {
  List<_WaterSourcesProvider> sources = [
    _WaterSourcesProvider('Municipal Water', false),
    _WaterSourcesProvider('Ground Water', false),
    _WaterSourcesProvider('Outsourced', false),
    _WaterSourcesProvider('Bubbletop', false),
  ];
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  String availableWells;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Builder(builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 10,
            bottom: 10,
            right: 10,
            top: MediaQuery.of(context).padding.top + 25,
          ),
          child: ModalProgressHUD(
            inAsyncCall: isLoading,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Rain Water Harvesting",
                      style: textTheme.headline5
                          .copyWith(fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      "And we're almost done",
                      style: textTheme.headline6.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      validator: (text) {
                        if (text?.isEmpty ?? true) {
                          return "This field is required";
                        }
                        rainWaterDataProvider.rainWater.qualityOfWaterPerDay =
                            text;
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Quantity of water required a day",
                        border: UnderlineInputBorder(),
                      ),
                    ),
                    // Row(
                    //   children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Available Wells:",
                      style: textTheme.subtitle2,
                    ),
                    // SizedBox(
                    //   width: 40,
                    // ),
                    RadioGroup<String>.builder(
                      horizontalAlignment: MainAxisAlignment.spaceEvenly,
                      direction: Axis.horizontal,
                      groupValue: availableWells,
                      onChanged: (value) {
                        rainWaterDataProvider.rainWater.availableWells = value;
                        setState(() {
                          availableWells = value;
                        });
                      },
                      items: ['Open', 'Bore', 'Both'],
                      itemBuilder: (value) => RadioButtonBuilder(
                        value,
                        textPosition: RadioButtonTextPosition.right,
                      ),
                      //   ),
                      // ],
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      validator: (text) {
                        if (text?.isEmpty ?? true) {
                          return "This field is required";
                        }
                        rainWaterDataProvider.rainWater.countAndDepthOfWells =
                            text;
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Count and depth of above mentioned wells",
                        border: UnderlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      validator: (text) {
                        if (text?.isEmpty ?? true) {
                          return "This field is required";
                        }
                        rainWaterDataProvider
                            .rainWater.noOfRainWaterDischargePipes = text;
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText:
                            "No. of rain water discharge piped from the roof",
                        border: UnderlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Other Information you might want us to know?',
                      style: textTheme.subtitle2,
                    ),
                    TextFormField(
                      validator: (text) {
                        rainWaterDataProvider.rainWater.otherInformation =
                            (text ?? '');
                        return null;
                      },
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        counter: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              Icons.info,
                              size: 12,
                            ),
                            Text('Useful Information')
                          ],
                        ),
                      ),
                      minLines: 4,
                      maxLines: 4,
                    ),

                    SizedBox(height: 60),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 160,
                        height: 44,
                        child: RaisedButton(
                          color: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              if (availableWells != null) {
                                int now = DateTime.now()
                                    .toUtc()
                                    .millisecondsSinceEpoch;
                                OpenRequest openRequest = OpenRequest(
                                  initializeDate: now,
                                  requestData: rainWaterDataProvider.rainWater,
                                  serviceType: ServiceTypes.rainWaterHarvest,
                                  status: RequestStatus.active,
                                  userId: user.uid,
                                );
                                await Firestore.instance
                                    .collection('requests')
                                    .add(
                                      openRequest.toMap(),
                                    )
                                    .then(
                                  (value) {
                                    // openRequest.requestId = value.documentID;
                                    // openRequests.add(openRequest);
                                    rainWaterDataProvider.reset();
                                    setState(() {
                                      isLoading = false;
                                    });
                                    openRequest.requestId = value.documentID;
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) => ThankYouRoute(
                                          requestData: openRequest,
                                        ),
                                        settings: RouteSettings(
                                          name: ThankYouRoute.name,
                                        ),
                                      ),
                                      (route) {
                                        print(
                                            'RouteSettings: ${route.settings ?? ''}');
                                        print(
                                            'RouteName: ${route.settings.name ?? ''}');
                                        return route.settings.name ==
                                            HomeScreenRoute.name;
                                      },
                                    );
                                  },
                                ).catchError(
                                  (error) {
                                    print(error);
                                    methods.showInSnackbar(error, context);
                                    isLoading = false;
                                  },
                                );
                              } else {
                                methods.showInSnackbar(
                                    'Error: Missing Information', context,
                                    color: Colors.red);
                              }
                            }
                          },
                          textColor: Colors.white,
                          child: Text(
                            'Submit',
                          ),
                        ),
                      ),
                    ),
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
