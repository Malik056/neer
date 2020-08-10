import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:neer/globals/constants.dart' as globals;
import 'package:neer/models/user.dart';

Future<bool> getUserFromFirebase(String uid) async {
  try {
    bool error = await Firestore.instance
        .collection('users')
        .document(uid)
        .get()
        .then((value) {
      if (!value.exists) {
        return false;
      } else {
        User.copySnapshotToUser(globals.user, value);
        return true;
      }
    }).catchError((error) {
      print("methods#getUserFromFirebase ERROR: $error");
      return null;
    });
    return error;
  } catch (ex) {
    print(ex);
    return null;
  }
}

showInSnackbar(String text, BuildContext context,
    {Color color = Colors.black}) {
  Scaffold.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text,
        style: Theme.of(context).textTheme.subtitle2.copyWith(
              color:
                  color.computeLuminance() == 0 ? Colors.white : Colors.black,
            ),
      ),
      backgroundColor: color,
    ),
  );
}
