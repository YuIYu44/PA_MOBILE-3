import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pa_mobile/utils/shared_preference.dart';

class userservice {
  static final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');
  Future uservalue() async {
    String? email = await preference().get("email");
    if (email == null) {
      return null;
    }
    return await _userCollection.doc(email).get();
  }
}
