import 'package:firebase_auth/firebase_auth.dart';

class ControllerProfile {
  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
