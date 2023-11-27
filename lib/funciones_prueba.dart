import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

int sumar(int a, int b) {
  return a + b;
}

class Cu {
  getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }
  //userid:FirebaseAuth.instance.currentUser!.uid;
}
