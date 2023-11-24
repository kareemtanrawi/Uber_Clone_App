import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uber_app/auth/login.dart';
import 'package:uber_app/pages/home_page.dart';
import 'package:uber_app/widgets/loading_dialoge.dart';

import '../methods/common_methods.dart';
import '../res/assets_res.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController userPhoneTextEditingController =
      TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passTextEditingController = TextEditingController();

  checkIfNetworkAvailable() {
    signUpFormValidation();
  }

  signUpFormValidation() {
    if (userNameTextEditingController.text.trim().length < 3) {
      CommonMethods.displaySnackBar(
          "your name must be at least 4 or more character.", context);
    } else if (userPhoneTextEditingController.text.trim().length < 7) {
      CommonMethods.displaySnackBar(
          "your phone number must be at least 11 or more character.", context);
    } else if (!emailTextEditingController.text.contains("@")) {
      CommonMethods.displaySnackBar("please write a valid email. ", context);
    } else if (passTextEditingController.text.trim().length < 5) {
      CommonMethods.displaySnackBar(
          "your password must be at least 6 or more character.", context);
    } else {}
    registerNewUser();
  }

  registerNewUser() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          LoadingDialog(messageText: "Registering your account.."),
    );
    final User? userFirebase = (await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
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

    DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child("users").child(userFirebase!.uid);
    Map userDataMap = {
      "name": userNameTextEditingController.text.trim(),
      "email": emailTextEditingController.text.trim(),
      "phone": userPhoneTextEditingController.text.trim(),
      "id": userFirebase.uid,
      "blockStatus": "no",
    };
    userRef.set(userDataMap);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(),
      ),
    );
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
                "Create a user\'s Account",
                style: GoogleFonts.aBeeZee(fontSize: 26),
              ),
              Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  children: [
                    TextField(
                      controller: userNameTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'User Name',
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
                      controller: userPhoneTextEditingController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'User Phone',
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
                        'Sign Up',
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
                      return const LoginScreen();
                    }));
                  },
                  child: Text(
                    'Already have an Account? Login Here',
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
