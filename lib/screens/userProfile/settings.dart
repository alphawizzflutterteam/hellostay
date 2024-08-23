import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/colors.dart';
import '../../utils/globle.dart';
import '../bottom_nav/bottom_Nav_bar.dart';
import '../loginScreen.dart';
import 'package:http/http.dart' as http;

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin();
  }

  var token;
  Future<void> checkLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('userToken');
    print("===my technic==token =====${token}===============");
    setState(() {});
    if (token == null)
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.whiteTemp,
        title: Text(
          'Settings',
          style: TextStyle(
              fontFamily: "rubic", fontSize: 20.0, color: AppColors.white),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text(
                          "Confirm Delete",
                          style: TextStyle(
                              color: AppColors.blackTemp,
                              fontFamily: 'rubic',
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        content: const Text(
                          "Are you sure to you want to delete your account?",
                          style: TextStyle(fontSize: 16, fontFamily: 'rubic'),
                        ),
                        actions: <Widget>[
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary),
                            child: const Text(
                              "YES",
                              style: TextStyle(
                                  color: AppColors.white, fontFamily: 'rubic'),
                            ),
                            onPressed: () async {
                              setState(() {
                                sessionremove();
                              });
                              Navigator.pop(context);
                              deleteAccount();
                              // SystemNavigator.pop();
                              // Navigator.pushReplacement(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (context) => const BottomNavBar(),
                              //     ));
                            },
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary),
                            child: const Text(
                              "NO",
                              style: TextStyle(
                                  color: AppColors.white, fontFamily: 'rubic'),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      );
                    });
              },
              child: Row(
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    alignment: Alignment.center,
                    child: Icon(Icons.delete),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade200,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                      width: 200,
                      child: Text(
                        "Delete Account",
                        style: TextStyle(fontSize: 16, fontFamily: 'rubic'),
                      )),
                  SizedBox(
                    width: 40,
                  ),
                  //   SizedBox(width: MediaQuery.sizeOf(context).width * .5,),
                  Icon(Icons.arrow_forward_ios)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool isLoading = false;
  Future<void> sessionremove() async {
    setState(() {
      isLoading = true;
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userToken');
    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteAccount() async {
    var headers = {'Authorization': 'Bearer $authToken'};
    var request = http.Request(
        'POST', Uri.parse('https://hellostay.com/api/user/permanently_delete'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print("aaa");
      var result = await response.stream.bytesToString();
      // print("kkk");
      var finaResult = jsonDecode(result);
      print(finaResult);
      Fluttertoast.showToast(msg: finaResult['message']);
      if (finaResult['status'] == 0) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ));
      } else {
        Navigator.pop(context);
      }
    } else {
      print(response.reasonPhrase);
    }
  }
}
