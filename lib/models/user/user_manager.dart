import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:domgaleto/helpers/firebase_errors.dart';
import 'package:domgaleto/models/user/user.dart' as userModel;

class UserManager extends ChangeNotifier {
  UserManager() {
    _loadCurrentUser();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  userModel.User? user;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  bool _loadingFace = false;
  bool get loadingFace => _loadingFace;
  set loadingFace(bool value) {
    _loadingFace = value;
    notifyListeners();
  }

  bool get isLoggedIn => user != null;

  bool adminEnabled() => user != null && user!.admin;

  Future<void> signIn(
      {userModel.User? user, Function? onFail, Function? onSuccess}) async {
    loading = true;
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: user!.email!, password: user.password!);
      await _loadCurrentUser(firebaseUser: userCredential.user);
      onSuccess!();
    } on PlatformException catch (e) {
      onFail!(getErrorString(e.code));
    }
    loading = false;
  }

  Future<void> signUp(
      {userModel.User? user, Function? onFail, Function? onSuccess}) async {
    loading = true;
    try {
      final UserCredential userCredential =
          await auth.createUserWithEmailAndPassword(
              email: user!.email!, password: user.password!);

      user.id = userCredential.user!.uid;
      this.user = user;

      await user.saveData();

      user.saveToken();

      onSuccess!();
    } on PlatformException catch (e) {
      onFail!(getErrorString(e.code));
    }
    loading = false;
  }

  void signOut() async {
    auth.signOut();
    user = null;
    notifyListeners();
  }

  Future<void> _loadCurrentUser({User? firebaseUser}) async {
    final User? currentUser = firebaseUser ?? auth.currentUser;
    final DocumentSnapshot documentSnapshot =
        await firestore.collection('users').doc(currentUser?.uid).get();
    user = userModel.User.fromDocument(documentSnapshot);
    user?.saveToken();
    final docAdmin = await firestore.collection('admins').doc(user?.id).get();
    if (docAdmin.exists) {
      user?.admin = true;
    }
    notifyListeners();
  }
}
