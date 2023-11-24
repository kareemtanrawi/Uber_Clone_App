import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uber_app/auth/sign_up.dart';
import 'package:uber_app/global/global_var.dart';
import 'package:uber_app/pages/home_page.dart';

import '../methods/common_methods.dart';
import '../res/assets_res.dart';
import '../widgets/loading_dialoge.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passTextEditingController = TextEditingController();

  checkIfNetworkAvailable() {
    signInFormValidation();
  }

  signInFormValidation() {
    if (!emailTextEditingController.text.contains("@")) {
      CommonMethods.displaySnackBar("please write a valid email. ", context);
    } else if (passTextEditingController.text.trim().length < 5) {
      CommonMethods.displaySnackBar(
          "your password must be at least 6 or more character.", context);
    } else {}
    signInUser();
  }

  signInUser() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          LoadingDialog(messageText: "Allowing you to Login.."),
    );
    final User? userFirebase = (await FirebaseAuth.instance
            .signInWithEmailAndPassword(
      email: emailTextEditingController.text.trim(),
      password: passTextEditingController.text.trim(),
    )
            .catchError((errorMsg) {
      Navigator.pop(context);
      CommonMethods.displaySnackBar(
        errorMsg.toString(),
        context,
      );
    }))
        .user;
    if (!context.mounted) return;
    Navigator.pop(context);

    if (userFirebase != null) {
      DatabaseReference userRef = FirebaseDatabase.instance
          .ref()
          .child("users")
          .child(userFirebase.uid);
      userRef.once().then((snap) {
        if (snap.snapshot.value != null) {
          if ((snap.snapshot.value as Map)["blockStatus"] == "no") {
            userName = (snap.snapshot.value as Map)["name"];
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ));
          } else {
            FirebaseAuth.instance.signOut();
            CommonMethods.displaySnackBar(
                'your are blocked. Contact admin: kareem01229526319@gmail.com',
                context);
          }
        } else {
          FirebaseAuth.instance.signOut();
          CommonMethods.displaySnackBar(
              'your record not exist as a user', context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Center(
                  child: Image.asset(
                AssetsRes.ECOM,
                height: 240,
              )),
              const SizedBox(
                height: 30,
              ),
              Text(
                "Login as a User",
                style: GoogleFonts.aBeeZee(fontSize: 26),
              ),
              Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  children: [
                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'User Email',
                        labelStyle: GoogleFonts.aBeeZee(
                          fontSize: 16,
                        ),
                      ),
                      style: GoogleFonts.aBeeZee(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    TextField(
                      controller: passTextEditingController,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: GoogleFonts.aBeeZee(
                          fontSize: 16,
                        ),
                      ),
                      style: GoogleFonts.aBeeZee(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        checkIfNetworkAvailable();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 80, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Login',
                        style: GoogleFonts.aBeeZee(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              //text Button
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const SignUpScreen();
                    }));
                  },
                  child: Text(
                    "Don't have an Account? Register Here",
                    style: GoogleFonts.aBeeZee(
                      color: Colors.grey,
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
