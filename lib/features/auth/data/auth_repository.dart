import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:orders/features/auth/data/user_model.dart';



class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


Future<void> updateUser(AppUser user) async {
  await _firestore
      .collection('users')
      .doc(user.uid)
      .update(user.toMap());
}




  Stream<AppUser?> userStream() {
  return _auth.authStateChanges().asyncExpand((firebaseUser) {
    if (firebaseUser == null) {
      return Stream.value(null);
    }

    return _firestore
        .collection('users')
        .doc(firebaseUser.uid)
        .snapshots()
        .map((doc) {
      if (!doc.exists) return null;
      return AppUser.fromMap(doc.data()!);
    });
  });
}

  Future<void> login(String email, String password)async {
    try {
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  } on FirebaseAuthException catch (e) {
    throw e.message ?? "Login failed";
  }
  }

  Future<void> register(AppUser user, String password) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: user.email,
      password: password,
    );

    final uid = result.user!.uid;

    final userMap = {...user.toMap(), 'uid': uid};

    await _firestore
        .collection('users')
        .doc(uid)
        .set(userMap);
  }

  Future<void> logout() {
    return _auth.signOut();
  }
}


