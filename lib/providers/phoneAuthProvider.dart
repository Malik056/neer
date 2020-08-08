import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:neer/bloc/phoneAuthBloc.dart';
import 'package:neer/models/user.dart';

enum PhoneAuthEvent {
  codeSent,
  failed,
  authCompleted,
  idle,
}

class PhoneAuthProvider {
  String verificationId = '';
  AuthCredential credentials;
  bool valid = false;
  String phoneNumber;

  final PhoneAuthBloc phoneAuthBloc = PhoneAuthBloc();

  void dispose() {
    phoneAuthBloc.close();
  }

  void sendCode({
    VoidCallback onCodeSent,
    VoidCallback onVerificationCompleted,
    VoidCallback codeAutoRetrievalTimeout,
    Function(String) verificationFailed,
    String phoneNumber,
  }) {
    this.phoneNumber = phoneNumber;
    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber.trim(),
      timeout: Duration(minutes: 1),
      verificationCompleted: (credentials) {
        this.credentials = credentials;
        phoneAuthBloc.add(PhoneAuthState.authenticated);
        onVerificationCompleted();
      },
      verificationFailed: (authException) {
        print(authException.toString());
        verificationFailed(authException.message);
      },
      codeSent: (verificationId, [number]) {
        this.verificationId = verificationId;
        onCodeSent();
      },
      codeAutoRetrievalTimeout: (verificationId) {
        this.verificationId = verificationId;
        codeAutoRetrievalTimeout();
      },
    );
  }

  // @override
  // Stream<PhoneAuthState> mapEventToState(PhoneAuthEvent event) async* {
  //   if (this.state.secondRemaining == 0) {
  //     Timer.periodic(Duration(seconds: 1), (timer) {
  //       add(event);
  //     });
  //     yield PhoneAuthState(event.code, event.authCompleted, maxInactiveTime,
  //         credential: event.credentials);
  //   } else {
  //     yield PhoneAuthState(
  //         event.code, event.authCompleted, this.state.secondRemaining - 1,
  //         credential: event.credentials);
  //   }
  // }

}
