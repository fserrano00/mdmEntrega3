import 'package:firebase_auth/firebase_auth.dart';

int sumar(int a, int b) {
  return a + b;
}

class Cu {
  getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }
}
