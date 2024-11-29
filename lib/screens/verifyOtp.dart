import 'package:flutter/material.dart';
import 'package:hellostay/constants/colors.dart';
import 'package:hellostay/repository/apiConstants.dart';
import 'package:hellostay/repository/apiStrings.dart';
import 'package:hellostay/screens/userProfile/updatePassword.dart';
import 'package:hellostay/utils/customeTost.dart';
import 'package:hellostay/utils/globle.dart';
import 'package:hellostay/widgets/custom_app_button.dart';
import 'package:hellostay/widgets/custumScreen.dart';
import 'package:hellostay/widgets/loadingwidget.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bottom_nav/bottom_Nav_bar.dart';



class VerifyOtp extends StatefulWidget {
  bool? isLogin;
  String? otp;
  String? mobile;
  VerifyOtp({super.key, this.otp, this.mobile, this.isLogin});
  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          customAuthDegineforverifie(
            context,
          ),
          Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.30),
            height: MediaQuery.of(context).size.height * 0.71,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: const BoxDecoration(
              color: Color(0xffF6F6F6),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Text('Code has sent to',
                      style: TextStyle(
                          fontSize: 17,
                          color: AppColors.blackTemp,
                          fontWeight: FontWeight.w400)),
                  const SizedBox(
                    height: 2,
                  ),
                  Text('+91 ${widget.mobile.toString()}',
                      style: const TextStyle(
                          fontSize: 20,
                          color: AppColors.blackTemp,
                          fontWeight: FontWeight.w400)),
                  // Text('OTP: ${otp.toString()}',
                  //     style: const TextStyle(
                  //         fontSize: 20,
                  //         color: AppColors.blackTemp,
                  //         fontWeight: FontWeight.w400)),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: PinCodeTextField(
                      keyboardType: TextInputType.phone,

                      onChanged: (value) {
                        textotp = value.toString();
                      },

                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(15),
                        activeColor: AppColors.secondary,
                        inactiveColor: AppColors.primary,
                        selectedColor: AppColors.secondary,
                        fieldHeight: 70,
                        fieldWidth: 70,

                      ),
                      //pinBoxRadius:20,
                      appContext: context,
                      length: 4,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const Text("Haven't received the verification code?",
                      style: TextStyle(
                          fontSize: 17,
                          color: AppColors.blackTemp,
                          fontWeight: FontWeight.w400)),
                  const SizedBox(
                    height: 5,
                  ),
                  !isLoading
                      ? InkWell(
                          onTap: () {
                            sendOtp();
                          },
                          child: const Text("Resend",
                              style: TextStyle(
                                  fontSize: 17,
                                  color: AppColors.blackTemp,
                                  fontWeight: FontWeight.bold)))
                      : LoadingWidget(context),
                  const SizedBox(
                    height: 70,
                  ),
                  InkWell(
                      onTap: () {
                        verifie();
                        // if (textotp == null) {
                        //   customSnackbar(context, "Please Fill OTP Fields");
                        // } else if (otp != textotp) {
                        //   customSnackbar(context, "Please Fill Correct OTP");
                        // } else {
                        //   if(widget.isLogin==true){
                        //     verifie();
                        //
                        //   }
                        //   else{
                        //
                        //
                        //     /*Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //           builder: (context) => ChangePassword(
                        //               Mobile: widget.Mobile.toString()),
                        //         ));*/
                        //
                        //
                        //   }
                        //
                        //
                        //
                        // }
                      },
                      child: CustomButton(
                        textt: "Submit",
                      ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFCM();
    otp = widget.otp.toString();

  }

  bool isLoading = false;
  var otp;
  var textotp;



  void sendOtp() {
    setState(() {
      isLoading = true;
    });
    var param = {
      "mobile": widget.mobile.toString(),
    };
    apiBaseHelper.postAPICall(getSendOtp, param).then((getData) {
      String msg = getData['message'].toString();
      int error = getData['status'];

      if (error == 1) {
        setState(() {
          // otp = getData['data'].toString();
        });
        customSnackbar(context,'Opt Send Successfully');
        setState(() {
          isLoading = false;
        });
      } else {
        customSnackbar(context, msg.toString());

        setState(() {
          isLoading = false;
        });
      }
    });
  }


  String? fcmToken;
  getFCM() async {
    /*final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    try {
      fcmToken = await _firebaseMessaging.getToken() ?? "";
    } on FirebaseException {}*/
  }
  void verifie() {
    setState(() {
      isLoading = true;
    });
    var param = {
      'mobile': widget.mobile.toString(),
      'otp': textotp.toString(),
      'device_name': 'Android'
    };
    apiBaseHelper.postAPICall(getVerifyOtp, param).then((getData) async {
      // String msg = getData['message'];
      int error = getData['status'];

      if (error == 1) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
         prefs.setString('userToken', '${getData['access_token']}');
         authToken = getData['access_token'] ;
        if(mounted){
        customSnackbar(context, "Verify Successful"); }
        if(widget.isLogin==true)
          {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => BottomNavBar(),));
          }
        else{
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) =>UpdatePassword(mobile: widget.mobile ?? "",)));
        }


        setState(() {
          isLoading = false;
        });
      } else {
        customSnackbar(context, "Verify Not Successful");

        setState(() {
          isLoading = false;
        });
      }
    });
  }


}
