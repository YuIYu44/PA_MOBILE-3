import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pa_mobile/services/auth.dart';

class userservice {
  static final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');
  Future uservalue() async {
    User userFuture = await Auth().getcurrent();
    String? email = userFuture.email;
    if (email == null) {
      return null;
    }
    return await _userCollection.doc(email).get();
  }
}
