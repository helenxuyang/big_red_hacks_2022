import 'package:big_red_hacks_2022/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class CurrentUserInfo with ChangeNotifier {
  late String? id;
  late User? user;

  void setID(String? id) {
    this.id = id;
    notifyListeners();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> _handleSignIn() async {
    bool isSignedIn = await _googleSignIn.isSignedIn();

    if (isSignedIn) {
      user = _auth.currentUser;
    } else {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final AuthCredential cred = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      user = (await _auth.signInWithCredential(cred)).user;
    }
    return user;
  }

  Future<void> signIn(BuildContext context) async {
    User? user = await _handleSignIn();
    setID(user?.uid);
  }

  Future<void> signOut() async {
    await _auth.signOut().then((_) {
      _googleSignIn.signOut();
    });
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Thirsty 🥵", style: TextStyle(fontSize: 32)),
            SizedBox(height: 16),
            SignInButton(),
            // SignOutButton()
          ],
        ),
      ),
    );
  }
}

class SignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CurrentUserInfo userInfo = Provider.of<CurrentUserInfo>(context);
    return Center(
      child: OutlinedButton(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Image.asset('assets/google_logo.png', width: 20),
            SizedBox(width: 20),
            Text('Sign in with Google', style: TextStyle(fontSize: 16))
          ]),
        ),
        onPressed: () async {
          await userInfo.signIn(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MyHomePage(title: 'Thirsty')));
        },
      ),
    );
  }
}

class SignOutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CurrentUserInfo userInfo = Provider.of<CurrentUserInfo>(context);
    return ElevatedButton(
      child: Text('Sign out'),
      onPressed: () {
        userInfo.signOut();
      },
    );
  }
}
