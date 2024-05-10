import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hellostay/repository/apiBasehelper.dart';
import 'package:hellostay/repository/apiConstants.dart';
import 'package:hellostay/screens/Hotel/homeView.dart';
import 'package:hellostay/utils/sharedPreference.dart';
import 'package:hellostay/widgets/custom_nav_bar.dart';

import '../../constants/colors.dart';
import '../../utils/traver_tile.dart';
import '../Hotel/booking_screen.dart';
import '../userProfile/userprofile.dart';


class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentIndex = 0;
  Widget callPage(int current) {
    switch (current) {
      case 0:
        return  HotelHomePage();
        break;
      // case 1:
      //  // Common.checkLogin(context);
      //   return const Center(child: Text('Message'),);
      //   break;

      // case 1:
      //  // Common.checkLogin(context);
      //   return const Center(child: Text('Trip Screen'),);
      //   break;

      case 1:
       // Common.checkLogin(context);
        return const BookingScreen();
        break;

      case 2:
       // Common.checkLogin(context);
        return MyprofileScr();/*const ProfileScreen(
            *//*userID: widget.userID,*//*
            );*/
        break;
      default:
        return const Center(child: Text('Home'),);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getProfile();
  }

  ApiBaseHelper apiBaseHelper = ApiBaseHelper();
  getProfile() async {
    await App.init();
    Map response =
        await apiBaseHelper.getAPICall(Uri.parse("${baseUrl}me"));

    if (response['data'] != null) {
     // name = response['data']['name'] ?? "";
    //  firstName = response['data']['first_name'] ?? "";
     // lastName = response['data']['last_name'] ?? "";
     // email = response['data']['email'] ?? "";
     // profile = response['data']['avatar_url'] ?? "";
    //  password = App.localStorage.getString("password") ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {



    return



      WillPopScope(
        onWillPop: () async {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Confirm Exit"),
                  content: const Text("Are you sure you want to exit?"),
                  actions: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                      child: const Text("YES", style: TextStyle(color: AppColors.whiteTemp),),
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                      child: const Text("NO",style: TextStyle(color: AppColors.whiteTemp)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              });
          return true;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: callPage(currentIndex),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,

            onTap: (int index) {

              setState(() {
                currentIndex = index;
              });
            },
            items: [
            
            BottomNavigationBarItem(


              backgroundColor: AppColors.primary,
              label: "Home",
                icon: Icon(Icons.home,color: AppColors.primary,)

            ),

            BottomNavigationBarItem(
                label: "Bookings",
                icon: Icon(Icons.book_online,color: AppColors.primary,)
            ),

            BottomNavigationBarItem(
                label: "Profile",
                icon: Icon(Icons.person,color: AppColors.primary,)),

          ],
            // selectedLabelStyle: TextStyle(color: AppColors.primary),
            selectedItemColor: AppColors.primary,

          ),



          // bottomNavigationBar: BottomNavigationDotBar(
          //     color: Colors.black26,
          //
          //     items: <BottomNavigationDotBarItem>[
          //       BottomNavigationDotBarItem(
          //           icon: const IconData(0xe900, fontFamily: 'home'),
          //           onTap: () {
          //             setState(() {
          //               currentIndex = 0;
          //             });
          //           }),
          //       // BottomNavigationDotBarItem(
          //       //     icon: const IconData(0xe900, fontFamily: 'message'),
          //       //     onTap: () {
          //       //       setState(() {
          //       //         currentIndex = 1;
          //       //       });
          //       //     }),
          //       /*BottomNavigationDotBarItem(
          //           icon: const IconData(
          //             0xe900,
          //             fontFamily: 'trip',
          //           ),
          //           onTap: () {
          //             setState(() {
          //               currentIndex = 1;
          //             });
          //           }),*/
          //       BottomNavigationDotBarItem(
          //           icon: const IconData(
          //             0xe900,
          //             fontFamily: 'hearth',
          //           ),
          //           onTap: () {
          //             setState(() {
          //               currentIndex = 2;
          //             });
          //           }),
          //       BottomNavigationDotBarItem(
          //           icon: const IconData(0xe900, fontFamily: 'profile'),
          //           onTap: () {
          //             setState(() {
          //               currentIndex = 3;
          //             });
          //           }),
          //     ])
               ),
      );
  }
}
