import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:novashop/models/user_model.dart';
import 'package:novashop/pages/home.dart';
import 'package:novashop/widgets/constants.dart';

final productsRef = Firestore.instance.collection('products');
final likedRef = Firestore.instance.collection('liked');
final cartRef = Firestore.instance.collection('cart');
UserModel currentUser;

void main() => runApp(MaterialApp(
    theme: ThemeData(
        fontFamily: 'GoogleSans',
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(color: Colors.black),
            color:  Colors.transparent,
            centerTitle: true,
            elevation: 0,
            brightness: Brightness.light)),
    debugShowCheckedModeBanner: false,
    home: LoginPageWidget()));

class LoginPageWidget extends StatefulWidget {
  @override
  LoginPageWidgetState createState() => LoginPageWidgetState();
}

class LoginPageWidgetState extends State<LoginPageWidget> {
  GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseAuth _auth;

  bool isUserSignedIn = false;

  @override
  void initState() {
    super.initState();
    initApp();
  }

  void initApp() async {
    FirebaseApp defaultApp = await Firebase.initializeApp();
    _auth = FirebaseAuth.instanceFor(app: defaultApp);
    checkIfUserIsSignedIn();
  }

  void checkIfUserIsSignedIn() async {
    var userSignedIn = await _googleSignIn.isSignedIn();

    setState(() {
      isUserSignedIn = userSignedIn;
    });
    if (isUserSignedIn) {
      User user = FirebaseAuth.instance.currentUser;
      setState(() {
        currentUser = UserModel.fromDocument(user);
        print(user.uid);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return !isUserSignedIn
        ? Scaffold(
            body: Container(
                padding: EdgeInsets.all(50),
                child: Align(
                    alignment: Alignment.center,
                    child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        onPressed: () {
                          onGoogleSignIn(context);
                        },
                        color:
                            isUserSignedIn ? Colors.green : Colors.blueAccent,
                        child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.account_circle, color: Colors.white),
                                SizedBox(width: 10),
                                Text(
                                    isUserSignedIn
                                        ? 'You\'re logged in with Google'
                                        : 'Login with Google',
                                    style: TextStyle(color: Colors.white))
                              ],
                            ))))))
        : HomePage(currentUser: currentUser);
  }

  Future<User> _handleSignIn() async {
    User user;
    bool userSignedIn = await _googleSignIn.isSignedIn();

    setState(() {
      isUserSignedIn = userSignedIn;
    });

    if (isUserSignedIn) {
      user = _auth.currentUser;
    } else {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      user = (await _auth.signInWithCredential(credential)).user;
      userSignedIn = await _googleSignIn.isSignedIn();
      setState(() {
        isUserSignedIn = userSignedIn;
      });
    }

    return user;
  }

  void onGoogleSignIn(BuildContext context) async {
    User user = await _handleSignIn();
    setState(() {
      currentUser = UserModel.fromDocument(user);
    });
  }
}
