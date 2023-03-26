import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  RxBool isPasswordHidden = true.obs;
  RxBool isLoginPasswordHidden = true.obs;
  static LoginController instance = Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  User? _user;
  Rx<User?> get currentUser => _user.obs;
  RxBool isLoginLoading = false.obs;
  RxBool isSignUpLoading = false.obs;
  Future<String?> signInWithEmailPassword(
      {String? email, String? password, String? name, String? mobile}) async {
    isLoginLoading(true);
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email ?? "",
        password: password ?? "",
      );
      _user = credential.user;
      if (_user != null) {
        print(_user?.uid);
      } else {
        print(credential.additionalUserInfo);
        return "Error";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user');
      } else {
        print(e.code);
      }
      return e.message ?? "Error";
    } catch (e) {
      print(e);
      return e.toString();
    } finally {
      isLoginLoading(false);
    }
    return null;
  }

  Future<bool> signUpWithPassword(
      {String? email, String? password, String? mobile, String? name}) async {
    isSignUpLoading(true);
    bool result = false;
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email ?? "",
        password: password ?? "",
      );

      _user = credential.user;
      if (_user != null) {
        print(_user?.email);
        await _db.collection("Users").doc(_user?.uid).set({
          'uid': _user?.uid,
          'name': name,
          'email': email,
          'mobile': mobile,
        });
        result = true;
      } else {
        print(credential.additionalUserInfo);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    isSignUpLoading(false);
    return result;
  }
}
