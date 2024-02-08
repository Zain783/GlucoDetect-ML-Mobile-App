import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glucoma_app_fyp/repository/auth_methords.dart';

import '../../Login.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool islogout = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white70,
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      backgroundColor: Colors.green,
                      child: SvgPicture.asset('assets/images/settingboy2.svg'),
                      radius: 125,
                    ),
                  ),
                  Column(
                    children: [
                      // Change Name button coding start here
                      Container(
                        decoration: BoxDecoration(
                            //   color: Colors.grey,   //******************Button color is here*********************
                            borderRadius: BorderRadius.circular(20)),
                        width: 380,
                        height: 70,
                        margin: const EdgeInsets.only(top: 70, right: 2),
                        child: Container(

                            // padding: EdgeInsets.only(top: 10,right: 10),
                            child: Row(
                          children: [
                            Container(
                                padding: const EdgeInsets.only(left: 20),
                                child: const CircleAvatar(
                                    backgroundColor: Colors.white70,
                                    child: Icon(Icons.edit))),
                            Container(
                                padding: const EdgeInsets.only(left: 10),
                                child: const Text(
                                  "Change Name",
                                  style: TextStyle(fontSize: 25),
                                  textAlign: TextAlign.center,
                                )),
                          ],
                        )),
                      ),
                      //Change Name button coding Ends here

                      //***********************************************************************************//

                      Container(
                        decoration: BoxDecoration(
                            // color: Colors.grey,
                            borderRadius: BorderRadius.circular(20)),
                        width: 380,
                        height: 70,
                        margin: const EdgeInsets.only(top: 15, right: 2),
                        child: Container(

                            // padding: EdgeInsets.only(top: 10,right: 10),
                            child: Row(
                          children: [
                            Container(
                                padding: const EdgeInsets.only(left: 20),
                                child: const CircleAvatar(
                                    backgroundColor: Colors.white70,
                                    child: Icon(Icons.contact_mail))),
                            Container(
                                padding: const EdgeInsets.only(left: 10),
                                child: const Text(
                                  "Contact Us",
                                  style: TextStyle(fontSize: 25),
                                  textAlign: TextAlign.center,
                                )),
                          ],
                        )),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            // color: Colors.grey,
                            borderRadius: BorderRadius.circular(20)),
                        width: 380,
                        height: 70,
                        margin: const EdgeInsets.only(top: 15, right: 2),
                        child: Container(

                            // padding: EdgeInsets.only(top: 10,right: 10),
                            child: Row(
                          children: [
                            Container(
                                padding: const EdgeInsets.only(left: 20),
                                child: const CircleAvatar(
                                    backgroundColor: Colors.white70,
                                    child: Icon(Icons.ios_share))),
                            Container(
                                padding: const EdgeInsets.only(left: 10),
                                child: const Text(
                                  "invite  Friend",
                                  style: TextStyle(fontSize: 25),
                                  textAlign: TextAlign.center,
                                )),
                          ],
                        )),
                      ),

                      InkWell(
                        onTap: () async {
                          setState(() {
                            islogout = true;
                          });
                          await AuthMethods().signOut(context);

                          setState(() {
                            islogout = false;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              //  color: Colors.grey,
                              borderRadius: BorderRadius.circular(20)),
                          width: 380,
                          height: 70,
                          margin: const EdgeInsets.only(top: 15, right: 2),
                          child: Container(
                              child: Row(
                            children: [
                              Container(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: CircleAvatar(
                                      backgroundColor: Colors.white70,
                                      child: islogout
                                          ? const SizedBox(
                                              height: 30,
                                              width: 30,
                                              child: CircularProgressIndicator(
                                                color: Colors.blue,
                                              ),
                                            )
                                          : const Icon(Icons.logout))),
                              Container(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: const Text(
                                    "Logout",
                                    style: TextStyle(fontSize: 25),
                                    textAlign: TextAlign.center,
                                  )),
                            ],
                          )),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
