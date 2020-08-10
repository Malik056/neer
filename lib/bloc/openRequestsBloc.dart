import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:neer/globals/constants.dart';
import 'package:neer/models/openRequest.dart';

class OpenRequestBloc extends Bloc<QuerySnapshot, List<OpenRequest>> {
  StreamSubscription<QuerySnapshot> _subscription;
  OpenRequestBloc() : super([]) {
    _subscription = Firestore.instance
        .collection('requests')
        .where('userId', isEqualTo: user.uid)
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
          (e) => OpenRequest.fromMap(e.data),
        )
        .toList();
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
