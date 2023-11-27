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

  Future addfavorite(String user, String productId) async {
    var dcs =
        (await _userCollection.doc(user).get()).data() as Map<String, dynamic>;
    DocumentReference docRef = await _userCollection.doc(user);
    await docRef.update({
      'Favorite': FieldValue.arrayUnion([productId])
    });
  }

  Future favoriteContent(String user) async {
    var dcs =
        (await _userCollection.doc(user).get()).data() as Map<String, dynamic>;
    if (dcs.containsKey("Favorite") && dcs["Favorite"] != null) {
      return dcs;
    }
    return {
      "Favorite": [""]
    };
  }

  Future deletefavorite(String user) async {
    var dcs = await _userCollection.doc(user).get() as Map<String, dynamic>;
    if (dcs.containsKey("Favorite")) {}
  }
}
