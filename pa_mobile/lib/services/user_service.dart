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

  Future addfavorite(String productId, kategori) async {
    String email = (await uservalue()).id;
    DocumentReference docRef = await _userCollection.doc(email);
    await docRef.update({
      'Favorite': FieldValue.arrayUnion([
        {productId: kategori}
      ])
    });
  }

  Future favoriteContent() async {
    String email = (await uservalue()).id;
    var dcs =
        (await _userCollection.doc(email).get()).data() as Map<String, dynamic>;
    if (dcs.containsKey("Favorite") && dcs["Favorite"] != null) {
      return dcs["Favorite"];
    }
    return null;
  }

  Future deletefavorite(String productId, String kategori) async {
    String email = (await uservalue()).id;
    var dcs =
        (await _userCollection.doc(email).get()).data() as Map<String, dynamic>;
    DocumentReference docRef = await _userCollection.doc(email);
    if (dcs.containsKey("Favorite")) {
      docRef.update({
        'Favorite': FieldValue.arrayRemove([
          {productId: kategori}
        ])
      });
    }
  }
}
