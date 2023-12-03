import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glucoma_app_fyp/forget_password.dart';
import 'package:glucoma_app_fyp/main.dart';
import 'package:glucoma_app_fyp/signup_screen.dart';
import 'package:glucoma_app_fyp/utils/global_variables.dart';
import 'package:glucoma_app_fyp/utils/utils.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'repository/auth_methords.dart';
import 'widgets/rounded_btn.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  googleLogin() async {
    print("Goole login method called");
    GoogleSignIn _googleSignIn = GoogleSignIn();
    try {
      var reslut = await _googleSignIn.signIn();
      if (reslut == null) {
        return;
      }

      final userData = await reslut.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: userData.accessToken, idToken: userData.idToken);
      var finalResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      print("Result $reslut");
      print(reslut.displayName);
      print(reslut.email);
      print(reslut.photoUrl);
    } catch (error) {
      print(error);
    }
  }

  Future<void> logout() async {
    await GoogleSignIn().disconnect();
    FirebaseAuth.instance.signOut();
  }

  var emailtext = TextEditingController();
  var passwordtext = TextEditingController();
  bool? is_checked = false;

  bool isLoading = false;
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF73AEF5),
                  Color(0xFF61A4F1),
                  Color(0xFF478DE0),
                  Color(0xFF398AE5),
                ],
                stops: [0.1, 0.4, 0.7, 0.9],
              )),
            ),
            SingleChildScrollView(
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    Container(
                      height: 200,
                    ),
                    Container(
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                            color: Colors.white70),
                      ),
                    ),
                    Container(
                      height: 50,
                    ),

                    Container(
                      width: 350,
                      height: 60,
                      //email textfield code is here
                      child: Card(
                        elevation: 6,
                        shadowColor: Colors.blue,
                        child: TextField(
                          controller: emailtext,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              hintText: "Email",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11),
                              ),
                              prefixIcon: const Icon(
                                Icons.email,
                                color: Colors.blue,
                              )),
                        ),
                      ),
                    ),
                    Container(
                      height: 11,
                    ),
                    //password field code is
                    Container(
                      width: 350,
                      height: 60,
                      child: Card(
                        shadowColor: Colors.blue,
                        elevation: 6,
                        child: TextField(
                          controller: passwordtext,
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                              hintText: "Password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11),
                              ),
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Colors.blue,
                              )),
                        ),
                      ),
                    ),
                    // Rember me checkbox code is here
                    // Row(
                    //   children: [
                    //     Container(
                    //       margin: const EdgeInsets.only(left: 17),
                    //       child: Checkbox(
                    //         value: is_checked,
                    //         activeColor: Colors.blue,
                    //         onChanged: (newBool) {
                    //           setState(() {
                    //             is_checked = newBool;
                    //           });
                    //         },
                    //       ),
                    //     ),
                    //     Container(
                    //         margin: const EdgeInsets.only(top: 1),
                    //         child: const Text(
                    //           "Remember Me",
                    //           style: TextStyle(color: Colors.white),
                    //         ))
                    //   ],
                    // ),
                    20.h,

                    Container(
                      height: 0,
                    ), // for spacing
                    CustomButton(
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            await AuthMethods().signInWithEmailAndPassword(
                                emailtext.text.trim(),
                                passwordtext.text,
                                context);
                            setState(() {
                              isLoading = false;
                            });
                          } else {
                            Utils.snackBar(
                                "Plese fill all the fields", context);
                          }
                        },
                        text: "Login",
                        isLoading: isLoading),
                    Container(height: 9),
                    //Forgooten password code is here

                    // Container(
                    //   height: 15,
                    // ),
                    // Container(
                    //   child: ElevatedButton(
                    //     onPressed: () {
                    //       Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //             builder: (context) =>
                    //                 const MyHomePage(title: "Dashborad"),
                    //           ));
                    //     },
                    //     child: const Text("As a Guest"),
                    //   ),
                    // ),
                    11.h,
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpScreen()));
                      },
                      child: RichText(
                        text: const TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                          children: [
                            TextSpan(
                              text: "SignUp",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),

                    10.h,
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ForgetPassword()));
                      },
                      child: Container(
                        child: const Text(
                          "Forgotten Password?",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),

                    // Container(
                    //   height: 11,
                    // ),
                    // Container(
                    //   width: 70,
                    //   height: 70,
                    //   child: InkWell(
                    //       onTap: googleLogin,
                    //       child: SvgPicture.asset('assets/images/googlesvg.svg')),
                    // ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
