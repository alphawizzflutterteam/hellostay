import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hellostay/constants/colors.dart';
import 'package:hellostay/repository/apiBasehelper.dart';
import 'package:hellostay/repository/apiConstants.dart';
import 'package:hellostay/repository/apiStrings.dart';
import 'package:hellostay/screens/signUp.dart';
import 'package:hellostay/screens/verifyOtp.dart';
import 'package:hellostay/utils/customeTost.dart';
import 'package:hellostay/utils/globle.dart';
import 'package:hellostay/widgets/custom_app_button.dart';
import 'package:hellostay/widgets/custumScreen.dart';
import 'package:hellostay/widgets/loadingwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bottom_nav/bottom_Nav_bar.dart';
import 'forgetPassword.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            customAuthDegine(context, "assets/images/loginImage.png"),
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.36),
              height: MediaQuery.of(context).size.height * 0.69,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: const BoxDecoration(
                color: Color(0xffF6F6F6),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 13,
                    ),
                    const Row(
                      children: [
                        Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 13,
                    ),
                    Center(
                      child: const Text(
                        "Welcome to HELLOSTAY",
                        style: TextStyle(fontSize: 16, fontFamily: "rubic"),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      "Please Login/ Register using your Email/ Mobile to continue",
                      style: TextStyle(
                        fontSize: 14,
                        //fontFamily: "rubic"
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Radio(
                          value: 'Email',
                          groupValue: login,
                          onChanged: (value) {
                            updateLoginType(value ?? '');
                          },
                          activeColor: AppColors.primary,
                        ),
                        const Text(
                          "Email",
                          style: TextStyle(
                              color: AppColors.blackTemp, fontSize: 15),
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        Radio(
                          value: 'Mobile no.',
                          groupValue: login,
                          onChanged: (value) {
                            updateLoginType(value ?? '');
                          },
                          activeColor: AppColors.primary,
                        ),
                        const Text(
                          'Mobile No',
                          style: TextStyle(
                              color: AppColors.blackTemp, fontSize: 15),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    num == 1
                        ? TextFormField(
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
                              hintStyle: const TextStyle(fontSize: 13),
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 5),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: const BorderSide(
                                      color: AppColors.whiteTemp, width: 2)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: const BorderSide(
                                      color: AppColors.whiteTemp, width: 2)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: const BorderSide(
                                      color: AppColors.whiteTemp, width: 2)),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: AppColors.whiteTemp),
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter Mobile Number';
                              } else if (value.length < 10) {
                                return 'Please Enter Valid Mobile Number';
                              }
                              return null; // Return null if the input is valid
                            },
                          )
                        : TextFormField(
                            controller: emailC,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.email,
                                color: AppColors.tabtextColor,
                              ),
                              hintText: 'Email',
                              hintStyle: const TextStyle(fontSize: 13),
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 5),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: const BorderSide(
                                      color: AppColors.whiteTemp, width: 2)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: const BorderSide(
                                      color: AppColors.whiteTemp, width: 2)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: const BorderSide(
                                      color: AppColors.whiteTemp, width: 2)),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: AppColors.whiteTemp),
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter Email';
                              } else if (!value.contains('@') ||
                                  !value.contains(".com")) {
                                return 'Please Enter Valid Email';
                              }
                              return null; // Return null if the input is valid
                            },
                          ),
                    num == 1
                        ? const SizedBox.shrink()
                        : const SizedBox(
                            height: 20,
                          ),
                    num == 1
                        ? const SizedBox.shrink()
                        : TextFormField(
                            obscureText: _obscureText,
                            controller: passwordC,
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
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: AppColors.tabtextColor,
                              ),
                              hintText: 'Password',
                              hintStyle: const TextStyle(fontSize: 13),
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 5),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: const BorderSide(
                                      color: AppColors.whiteTemp, width: 2)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: const BorderSide(
                                      color: AppColors.whiteTemp, width: 2)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: const BorderSide(
                                      color: AppColors.whiteTemp, width: 2)),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: AppColors.whiteTemp),
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter Password';
                              }
                              return null; // Return null if the input is valid
                            },
                          ),
                    num == 1
                        ? const SizedBox.shrink()
                        : const SizedBox(
                            height: 8,
                          ),
                    num == 1
                        ? const SizedBox.shrink()
                        : InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const forgotPassword()),
                              );
                            },
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: const Text(
                                'Forgot Password ?',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary),
                              ),
                            ),
                          ),
                    const SizedBox(
                      height: 50,
                    ),
                    InkWell(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          if (num == 1) {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) => VerifyOtp(
                            //         isLogin: true,
                            //         mobile: mobilecontroller.text,
                            //         otp: '123456',
                            //       ),
                            //     ));
                            loginmobileApi();
                          } else {
                            loginemailApi();
                          }
                          //  Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard(),));
                        }
                      },
                      child: !isLoading
                          ? CustomButton(
                              textt: num == 1 ? "Send OTP" : "Login",
                            )
                          : LoadingWidget(context),
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpScr(),
                            ));
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            " Sign Up",
                            style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 100,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  var fcmToken;

  getFCM() async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    try {
      fcmToken = await _firebaseMessaging.getToken() ?? "";
    } on FirebaseException {}
  }

  void loginemailApi() {
    setState(() {
      isLoading = true;
    });

    var param = {
      'email': emailC.text.toString(),
      'password': passwordC.text.toString(),
      'fcm_id': '12345678',
      'device_name': '1'
    };

    apiBaseHelper.postAPICall(loginApi, param).then((getData) async {
      int error = getData['status'];
      String msg = getData['message'].toString();
      print("email");
      if (error == 1) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userToken', '${getData['access_token']}');
        authToken = getData['access_token'];

        /*customSnackbar(context, msg.toString());
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Dashboard(),
            ));*/
        Fluttertoast.showToast(msg: "Login Successful");
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNavBar(),
            ));
        setState(() {
          isLoading = false;
        });
      } else {
        Fluttertoast.showToast(msg: "Login Not Successful");
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getFCM();
  }

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
        print(msg);
        // var otp = getData['data'].toString();
        // customSnackbar(context, msg.toString());
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerifyOtp(
                isLogin: true,
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

  TextEditingController mobilecontroller = TextEditingController();
  bool isLoading = false;

  bool _obscureText = true;
  String login = 'Email';

  void updateLoginType(String value) {
    if (value == 'Email') {
      num = 0;
    } else {
      num = 1;
    }
    login = value;

    setState(() {});
  }

  int num = 0;

  final emailC = TextEditingController();
  final passwordC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
}
