import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hellostay/constants/colors.dart';
import 'package:hellostay/screens/bottom_nav/bottom_Nav_bar.dart';
import 'package:hellostay/utils/sharedPreference.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? uid;
  String? type;
  bool? isSeen;

  // void checkingLogin() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     uid = prefs.getString('USERID');
  //     type = prefs.getString('Role');
  //   });
  // }

  // checkFirstSeen() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool _seen = (prefs.getBool('seen') ?? false);
  //
  //   if (_seen) {
  //     print("this is working here");
  //     if(uid == "" || uid == null ){
  //       // return SeekerDrawerScreen();
  //       Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
  //     }
  //     else{
  //       print("hello user here  ${uid} and ${type}");
  //       if(type == "seeker") {
  //         print("working this here");
  //         Navigator.push(context,
  //             MaterialPageRoute(builder: (context) => Dashboard()));
  //       }
  //       else{
  //         print("working now here ");
  //         Navigator.push(context,
  //             MaterialPageRoute(builder: (context) => RecruiterDashboard()));
  //         /// jsut for ddummy data RecruiterDashboard data is use
  //       }
  //       // Navigator.push(context,
  //       //     MaterialPageRoute(builder: (context) => RecruiterDashboard()));
  //     }
  //
  //     // Navigator.of(context).pushReplacement(
  //     //     new MaterialPageRoute(builder: (context) => new LoginScreen()));
  //   } else {
  //     await prefs.setBool('seen', true);
  //     Navigator.of(context).pushReplacement(
  //         new MaterialPageRoute(builder: (context) => new IntroSlider()));
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    // Future.delayed(Duration(milliseconds: 500),(){
    //   return ch eckingLogin();
    // });

    // Timer(Duration(seconds: 3), () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> IntroSlider()));});
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    await App.init();
   /* if (App.localStorage.getString("token") != null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => BottomNavBar()));
    } else {
      Future.delayed(Duration(seconds: 3), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Introslider()));
      });
    }*/
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const BottomNavBar()));
    });
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            decoration:  const BoxDecoration(
              color: AppColors.white,
            ),
            child: Center(
              child: Image.asset(
                'assets/images/appLogo.png',
                scale: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
