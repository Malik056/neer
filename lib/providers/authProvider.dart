import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:flutter/material.dart';
import 'package:neer/bloc/phoneAuthBloc.dart';
import 'package:neer/bloc/waitTimeBloc.dart';
import 'package:neer/globals/constants.dart' as globals;
import 'package:neer/models/user.dart';

enum PhoneAuthEvent {
  codeSent,
  failed,
  authCompleted,
  idle,
}

class MyPhoneAuthProvider {
  String verificationId = '';
  FirebaseAuth.AuthCredential credentials;
  bool valid = false;
  String phoneNumber;

  final PhoneAuthBloc phoneAuthBloc = PhoneAuthBloc();

  void dispose() {
    phoneAuthBloc.close();
  }

  void sendCode({
    VoidCallback onCodeSent,
    Function(String) onVerificationCompleted,
    VoidCallback codeAutoRetrievalTimeout,
    Function(String) verificationFailed,
    String phoneNumber,
    int timeout = 30000,
  }) {
    this.phoneNumber = phoneNumber;
    FirebaseAuth.FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber.trim(),
      timeout: Duration(milliseconds: timeout),
      verificationCompleted: (credentials) async {
        this.credentials = credentials;
        try {
          if (credentials != null) {
            phoneAuthBloc.add(PhoneAuthState.authenticated);
            onVerificationCompleted(null);
          } else {
            onVerificationCompleted('error');
            print('Verification Error!');
          }
        } catch (err) {
          print(err);
        }
      },
      verificationFailed: (authException) {
        phoneAuthBloc.add(PhoneAuthState.authenticationFailed);
        print(authException.toString());
        verificationFailed(authException.message);
      },
      codeSent: (verificationId, [number]) {
        phoneAuthBloc.add(PhoneAuthState.codeSent);
        this.verificationId = verificationId;
        globals.waitingTimeBloc.add(StopWatchEvents.start);
        onCodeSent();
      },
      codeAutoRetrievalTimeout: (verificationId) {
        this.verificationId = verificationId;
        codeAutoRetrievalTimeout();
      },
    );
  }

  /*
   * returns Error [String] if there is an error
   * returns null if no error
   */
  Future<String> logout() async {
    if (globals.connectivityBloc.state == ConnectivityResult.none) {
      return "No Internet Connection";
    }
    String error = await FirebaseAuth.FirebaseAuth.instance.signOut().then((_) {
      return null;
    }).catchError((err) {
      print(err);
      return "An Error Occurred";
    });

    return error;
  }

  Future updateCurrentUserCredentials() async {
    try {
      bool result =
          await (await FirebaseAuth.FirebaseAuth.instance.currentUser())
              .updatePhoneNumberCredential(this.credentials)
              .then((value) => true)
              .catchError((error) {
        print('$error');
        return false;
      });
      return result;
    } catch (ex) {
      print(ex);
      return false;
    }
  }

  Future<bool> verify(String smscode) async {
    FirebaseAuth.AuthCredential credentials;
    try {
      credentials = FirebaseAuth.PhoneAuthProvider.getCredential(
        verificationId: verificationId,
        smsCode: smscode,
      );
      this.credentials = credentials;
      FirebaseAuth.AuthResult result = await FirebaseAuth.FirebaseAuth.instance
          .signInWithCredential(credentials);

      if (result != null && result.user != null)
        return true;
      else
        return false;
    } catch (trace) {
      print(trace);
      throw trace;
    }
  }

  Future<bool> signIn() async {
    FirebaseAuth.AuthResult result = await FirebaseAuth.FirebaseAuth.instance
        .signInWithCredential(globals.phoneAuthProvider.credentials)
        .catchError((error) => null);
    if (result?.user != null) {
      bool exists = await Firestore.instance
          .collection('users')
          .document(result.user.uid)
          .get(source: Source.server)
          .then(
        (value) {
          if (value.exists) {
            if (globals.user == null) {
              globals.user = User();
            }
            User.copySnapshotToUser(
              globals.user,
              value,
            );
            return true;
          } else {
            return false;
          }
        },
      );
      if (exists) {
        return true;
      } else {
        return false;
      }
    } else {
      return null;
    }
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
