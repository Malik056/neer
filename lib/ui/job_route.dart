import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:neer/globals/constants.dart' as globals;
import 'package:neer/models/contract.dart';
import 'package:neer/widgets/completedContractsWidget.dart';
import 'package:neer/widgets/contractsWidget.dart';
import 'package:neer/widgets/openRequestWidget.dart';

class JobRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    List<Contract> completedContracts = globals.contracts
        .where(
          (element) => element.status == globals.ContractStatus.completed,
        )
        .toList();
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 20,
          left: 20,
          right: 20,
          bottom: 20,
        ),
        child: StatefulBuilder(builder: (context, setState) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'My Jobs',
                  style: textTheme.headline5,
                ),
                SizedBox(
                  height: 20,
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
                            'Open Service Request',
                            style: textTheme.headline6,
                          ),
                        ),
                        expanded: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 300,
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: List.generate(
                                globals.openRequests.length,
                                (index) => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    OpenRequestWidget(
                                      openRequest: globals.openRequests[index],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
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
                            'Service Under Contract',
                            style: textTheme.headline6,
                          ),
                        ),
                        expanded: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 300,
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: List.generate(
                                globals.contracts.length,
                                (index) => ContractWidget(
                                  contract: globals.contracts[index],
                                ),
                              ),
                            ),
                          ),
                        ),
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
                            'Completed Services',
                            style: textTheme.headline6,
                          ),
                        ),
                        expanded: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 300,
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: List.generate(
                                completedContracts.length,
                                (index) => CompletedContractWidget(
                                  contract: completedContracts[index],
                                ),
                              ),
                            ),
                          ),
                        ),
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
                            'Open Service Request',
                            style: textTheme.headline6,
                          ),
                        ),
                        expanded: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 300,
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: List.generate(
                                globals.openRequests.length,
                                (index) => OpenRequestWidget(
                                  openRequest: globals.openRequests[index],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
