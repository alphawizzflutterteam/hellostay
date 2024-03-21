import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hellostay/constants/colors.dart';
import 'package:hellostay/repository/apiConstants.dart';
import 'package:hellostay/repository/apiStrings.dart';
import 'package:hellostay/screens/verifyOtp.dart';
import 'package:hellostay/utils/customeTost.dart';
import 'package:hellostay/widgets/custom_app_button.dart';
import 'package:hellostay/widgets/custumScreen.dart';
import 'package:hellostay/widgets/loadingwidget.dart';

class forgotPassword extends StatefulWidget {
  const forgotPassword({super.key});

  @override
  State<forgotPassword> createState() => _forgotPasswordState();
}

class _forgotPasswordState extends State<forgotPassword> {
  final emailC = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          customAuthDegineforForget(
            context,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Enter mobile number associated',
                          style: TextStyle(
                              fontSize: 20,
                              color: AppColors.blackTemp,
                              fontWeight: FontWeight.w400)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('with your account',
                          style: TextStyle(
                              fontSize: 20,
                              color: AppColors.blackTemp,
                              fontWeight: FontWeight.w400)),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Form(
                      key: _formKey,
                      child: TextFormField(
                        maxLength: 10,
                        controller: mobilecontroller,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          counterText: "",
                          prefixIcon: const Icon(
                            Icons.call,
                            color: AppColors.tabtextColor,
                          ),
                          hintText: 'Mobile Number',
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
                            return 'Please Enter Mobile Number';
                          } else if (value.length != 10) {
                            return 'Please Enter Valid Mobile Number';
                          }
                          return null; // Return null if the input is valid
                        },
                      )),
                  SizedBox(
                    height: 40,
                  ),
                  InkWell(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
// Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyOtp(),));
                          loginmobileApi();
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

  var otp;
  bool isLoading = false;


  TextEditingController mobilecontroller = TextEditingController();

  void loginmobileApi() {
    setState(() {
      isLoading = true;
    });

    var param = {
      'mobile': mobilecontroller.text.toString(),
    };

    apiBaseHelper.postAPICall(getSendOtp, param).then((getData) async {
      int error = getData['status'];
      String msg = getData['message'].toString();

      print("mobile");
      if (error == 1) {
        // var otp = getData['data'].toString();
        customSnackbar(context, msg.toString());
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerifyOtp(
                isLogin: false,
                mobile: mobilecontroller.text,
                // otp: otp.toString(),
              ),
            ));
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
  // void sendOtp() {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   var param = {
  //     "user_phone": emailC.text.toString(),
  //   };
  //   apiBaseHelper.postAPICall(loginApi, param).then((getData) {
  //     print("forget----------${getData}");
  //     String msg = getData['message'];
  //     bool error = getData['status'];
  //
  //     if (error == true) {
  //       setState(() {
  //         otp = getData['data'];
  //       });
  //       customSnackbar(context, msg.toString());
  //       Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => VerifyOtp(
  //                 otp: otp.toString(), mobile: emailC.text.toString()),
  //           ));
  //       setState(() {
  //         isLoading = false;
  //       });
  //     } else {
  //       customSnackbar(context, msg.toString());
  //
  //       setState(() {
  //         isLoading = false;
  //       });
  //     }
  //   });
  // }
}
