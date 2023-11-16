import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pa_mobile/utils/shared_preference.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');
  Future<String> signUp(String email, String password, String name) async {
    try {
      if (email != "") {
        if (name.length > 5 &&
            double.tryParse(name) == null &&
            password != "") {
          await _auth.createUserWithEmailAndPassword(
              email: email.toString(), password: password.toString());
          await _userCollection
              .doc(email.toString())
              .set({'username': name.toString(), 'status': 'user'});
          return "";
        }
        return "Usernama & Password must contain at least 6 characters";
      }
      return "Fill all of the fields";
    } catch (e) {
      if (e is FirebaseAuthException) {
        return e.toString().toUpperCase().split("]")[1];
      }
      return "Error Is Found";
    }
  }

  Future<String> login(String email, String password) async {
    try {
      if (email != "") {
        if (password != "") {
          await _auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          preference().set('email', email);
          preference().set('password', password);
          return "";
        }
        return "Password must contain at least 6 characters";
      }
      return "Fill all of the fields";
    } catch (e) {
      if (e is FirebaseAuthException) {
        return e.toString().toUpperCase().split("]")[1];
      }
      return "Error Is Found";
    }
  }

  Future changepass(email, currentpass, newpass) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: currentpass.toString(),
      );
      final user = userCredential.user;
      if (newpass.length > 5 && newpass != currentpass) {
        try {
          await user!.updatePassword(newpass);
          await preference().set('password', newpass);
        } catch (e) {
          return e.toString().toUpperCase().split("]")[1];
        }
      }
      return "Password contains at least 6 characters\nAnd different from old password ";
    } catch (e) {
      return "Wrong Old Password";
    }
  }
}
