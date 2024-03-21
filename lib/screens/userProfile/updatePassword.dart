import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hellostay/screens/loginScreen.dart';
import 'package:hellostay/utils/globle.dart';
import 'package:http/http.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import '../../constants/colors.dart';
import '../../utils/customeTost.dart';
import '../../widgets/custom_app_button.dart';
import '../../widgets/custumScreen.dart';
import '../../widgets/loadingwidget.dart';
class UpdatePassword extends StatefulWidget {
  String mobile;
  UpdatePassword({Key? key,required this.mobile}) : super(key: key);

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  bool isLoading = false;
  bool _obscureText = true;
  bool _obscureText1 = true;
  final _formKey = GlobalKey<FormState>();
  final updatePasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          customAuthDegineforUpdatePassword(
            context,widget.mobile
          ),
          Container(
            margin:
            EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.29),
            height: MediaQuery.of(context).size.height * 0.71,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Color(0xffF6F6F6),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 70,
                  ),

                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            obscureText: _obscureText,
                            controller: updatePasswordController,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: AppColors.primary,
                                  size: 16,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                              counterText: "",
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: AppColors.tabtextColor,
                              ),
                              hintText: 'New Password',
                              hintStyle: TextStyle(fontSize: 13),
                              contentPadding:
                              const EdgeInsets.symmetric(vertical: 5),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide(
                                      color: AppColors.whiteTemp, width: 2)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: const BorderSide(
                                      color: AppColors.whiteTemp, width: 2)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide(
                                      color: AppColors.whiteTemp, width: 2)),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: AppColors.whiteTemp),
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter New Password';
                              } else if (value.length < 8) {
                                return 'Atlest 8 Character is required';
                              }
                              return null; // Return null if the input is valid
                            },
                          ),
                          SizedBox(height: 20,),
                          TextFormField(
                            obscureText: _obscureText1,

                            controller: confirmPasswordController,
                           // keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText1
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: AppColors.primary,
                                  size: 16,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText1 = !_obscureText1;
                                  });
                                },
                              ),
                              counterText: "",
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: AppColors.tabtextColor,
                              ),
                              hintText: 'Confirm Password',
                              hintStyle: TextStyle(fontSize: 13),
                              contentPadding:
                              const EdgeInsets.symmetric(vertical: 5),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide(
                                      color: AppColors.whiteTemp, width: 2)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: const BorderSide(
                                      color: AppColors.whiteTemp, width: 2)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide(
                                      color: AppColors.whiteTemp, width: 2)),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: AppColors.whiteTemp),
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            validator: (value) {
                              if (updatePasswordController.text != confirmPasswordController.text) {
                                return 'Password Not Match';
                              }
                              return null; // Return null if the input is valid
                            },
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 40,
                  ),
                  InkWell(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          updatePassword();
                        }
                      },
                      child: !isLoading
                          ? CustomButton(
                        textt: "Submit",
                      )
                          : LoadingWidget(context))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  updatePassword() async {
    print(authToken);
    var headers = {
      'Authorization': 'Bearer $authToken'
    };
    var request = http.MultipartRequest('POST', Uri.parse('https://hotelbooking.alphawizzserver.com/api/auth/update-password'));
    request.fields.addAll({
      'new_password': updatePasswordController.text
    });
    print("kkkkkk");

    request.headers.addAll(headers);
    print(request);
    print(request.fields);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {

      var result=await response.stream.bytesToString();
      var finaResult=jsonDecode(result);

      print('final-------${finaResult}');
      customSnackbar(context, finaResult['message']);
      if(finaResult['status']==1)
        {
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>LoginPage()));
        }
      //print(await response.stream.bytesToString());
    }
    else {
    print(response.reasonPhrase);
    }

  }
}


