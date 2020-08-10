import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:neer/globals/constants.dart';
import 'package:neer/globals/methods.dart';
import 'package:neer/models/openRequest.dart';
import 'package:neer/models/quotesModel.dart';
import 'package:neer/widgets/actionCenterRequestWidget.dart';
import 'package:neer/widgets/customDialogWidget.dart';

class ActionCenterRoute extends StatelessWidget {
  static final String name = "ActionCenterRoute";
  final OpenRequest request;
  final List<QuoteRequest> quoteRequests;

  const ActionCenterRoute({Key key, this.quoteRequests, this.request})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    bool isLoading = false;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 20,
          left: 20,
          right: 20,
          bottom: 20,
        ),
        child: StatefulBuilder(builder: (context, setState) {
          return ModalProgressHUD(
            inAsyncCall: isLoading,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Action Center',
                  style: textTheme.headline5,
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Quotes Job, ${quoteRequests[0].request.requestId}',
                  style: textTheme.headline6,
                ),
                SizedBox(
                  height: 10,
                ),
                quoteRequests.length > 0
                    ? Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: List.generate(
                                quoteRequests.length,
                                (index) => Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ActionCenterRequestWidget(
                                        quote: quoteRequests[0],
                                      ),
                                    )),
                          ),
                        ),
                      )
                    : Center(
                        child: Text('No Quote yet!'),
                      ),
                SizedBox(
                  height: 50,
                ),
                Align(
                  alignment: Alignment.center,
                  child: RaisedButton(
                    textColor: Colors.white,
                    color: Colors.red,
                    child: Text('Cancel Job Request'),
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      await cancelJobRequest(context);
                      setState(() {
                        isLoading = false;
                      });
                      // Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Future<bool> cancelJobRequest(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return CancelJobRequestDialogWidget(
          description:
              "This is cancel Rain Water Harvest (XXXXXXXXXXXXX) request and all collected information. Are you sure?",
          title: "Cancel Job Request ?",
          actionButtonTextColor: Colors.red,
          buttonText: 'YES',
          onClose: () {
            // Navigator.pop(context);
          },
          onDone: () async {
            if (connectivityBloc.state == ConnectivityResult.none) {
              showInSnackbar('No Internet connection!', context);
              return;
            }
            await Firestore.instance
                .collection('requests')
                .document(request.requestId)
                .delete()
                .then((value) {
              Navigator.pop(context);
            }).catchError(
              (error) {
                print(error);
                showInSnackbar('$error', context);
              },
            );
          },
        );
      },
    );
  }
}
