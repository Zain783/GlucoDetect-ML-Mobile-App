import 'package:flutter/material.dart';
import 'package:glucoma_app_fyp/repository/auth_methords.dart';
import 'package:glucoma_app_fyp/utils/app_size.dart';
import 'package:glucoma_app_fyp/utils/utils.dart';
import 'package:glucoma_app_fyp/widgets/rounded_btn.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  var emailtext = TextEditingController();

  bool? is_checked = false;

  bool isLoading = false;
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
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
                      width: context.screenWidth * 0.7,
                      child: const Text(
                        "Enter Email to forget Password",
                        textAlign: TextAlign.center,
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
                    20.h,
                    Container(
                      height: 0,
                    ),
                    CustomButton(
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            await AuthMethods()
                                .resetPassword(emailtext.text, context);
                            setState(() {
                              isLoading = false;
                            });
                          } else {
                            Utils.snackBar(
                                "Plese fill all the fields", context);
                          }
                        },
                        text: "Send Email",
                        isLoading: isLoading),
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
