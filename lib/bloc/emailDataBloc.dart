import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:neer/models/myEmail.dart';

class EmailDataBloc extends Bloc<DocumentSnapshot, MyEmail> {
  EmailDataBloc() : super(MyEmail(subject: 'Quote request by NEER', body: '')) {
    Firestore.instance
        .collection('constants')
        .document('email')
        .snapshots()
        .listen((event) {
      add(event);
    });
  }

  @override
  Stream<MyEmail> mapEventToState(DocumentSnapshot event) async* {
    if (event.exists) {
      yield MyEmail(
        subject: event.data['subject'],
        body: event.data['body'],
      );
    } else {
      yield MyEmail();
    }
  }
}
