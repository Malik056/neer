import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neer/models/quotesModel.dart';
import 'package:neer/ui/quoteCenter.dart';

class StateWrapper {
  bool active = true;
}

class ActionCenterRequestWidget extends StatelessWidget {
  final QuoteRequest quote;
  final StateWrapper _wrapper = StateWrapper();

  ActionCenterRequestWidget({Key key, this.quote}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(right: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            quote.serviceProviderModel.name,
            style: textTheme.subtitle2,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  quote.serviceProviderModel.description,
                  textAlign: TextAlign.start,
                  style: textTheme.caption,
                ),
              ),
              SizedBox(
                width: 40,
              ),
              Container(
                height: 36,
                width: 70,
                child: RaisedButton(
                  textColor: Colors.white,
                  onPressed: () async {
                    if (_wrapper.active) {
                      _wrapper.active = false;
                      await Future.delayed(Duration(seconds: 2));
                      _wrapper.active = true;
                    }
                  },
                  child: Text('Hire'),
                ),
              ),
            ],
          ),
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Review Quote',
                style: textTheme.bodyText2.copyWith(color: Colors.blue),
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => QuoteCenterRoute(
                      quoteRequest: quote,
                    ),
                  ));
            },
          ),
        ],
      ),
    );
  }
}
