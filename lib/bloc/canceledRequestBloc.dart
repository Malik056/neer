import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:neer/globals/constants.dart';
import 'package:neer/models/openRequest.dart';
import 'package:neer/models/requestStatus.dart';

class CanceledRequestBloc extends Bloc<QuerySnapshot, List<OpenRequest>> {
  StreamSubscription<QuerySnapshot> _subscription;
  CanceledRequestBloc() : super([]) {
    _subscription = Firestore.instance
        .collection('requests')
        .where('userId', isEqualTo: user.uid)
        .where(
          'status',
          isEqualTo: RequestStatus.canceled,
        )
        .orderBy('initializeDate', descending: true)
        .snapshots()
        .listen((event) {
      add(event);
    });
  }

  @override
  Stream<List<OpenRequest>> mapEventToState(QuerySnapshot event) async* {
    yield event.documents
        .map(
          (e) => OpenRequest.fromMap(
            e.data
              ..update('requestId', (value) => e.documentID, ifAbsent: () {
                return e.documentID;
              }),
          ),
        )
        .toList();
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
