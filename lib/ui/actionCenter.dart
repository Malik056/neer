import 'package:flutter/material.dart';
import 'package:neer/models/quotesModel.dart';
import 'package:neer/widgets/actionCenterRequestWidget.dart';
import 'package:neer/widgets/customDialogWidget.dart';

class ActionCenterRoute extends StatelessWidget {
  final List<QuoteRequest> quoteRequests;

  const ActionCenterRoute({Key key, this.quoteRequests}) : super(key: key);
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
                  await cancelJobRequest(context);
                  // Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future cancelJobRequest(BuildContext context) async {
    await showDialog(
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
          onDone: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
