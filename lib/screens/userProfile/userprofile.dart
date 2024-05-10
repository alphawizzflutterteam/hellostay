import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:hellostay/repository/apiConstants.dart';
import 'package:hellostay/screens/userProfile/Mywallet.dart';
import 'package:hellostay/screens/userProfile/ReferAndEran.dart';
import 'package:hellostay/screens/userProfile/privacy_screen.dart';
import 'package:hellostay/screens/userProfile/settings.dart';
import 'package:hellostay/screens/userProfile/terms_condition.dart';
import 'package:hellostay/screens/userProfile/updateProfiles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/colors.dart';
import 'package:http/http.dart'as http;

import '../../model/getProfineModel.dart';
import '../../utils/sharedPreference.dart';
import '../bottom_nav/bottom_Nav_bar.dart';
import '../loginScreen.dart';



class MyprofileScr extends StatefulWidget {
  const MyprofileScr({super.key});

  @override
  State<MyprofileScr> createState() => _MyprofileScrState();
}

class _MyprofileScrState extends State<MyprofileScr> {


  @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
// setState(() {
//   App.localStorage.getString("token") != null?islogin=true:islogin=false;
//
//
// });
//     /* if (App.localStorage.getString("token") != null) {
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (context) => BottomNavBar()));
//     } else {
//       Future.delayed(Duration(seconds: 3), () {
//         Navigator.pushReplacement(
//             context, MaterialPageRoute(builder: (context) => Introslider()));
//       });
//     }*/
//
//   }
  bool islogin=false;

  @override
  void initState() {
    // TODO: implement initState
    gettoken();
    super.initState();
  }
  var token;
  Future<void> gettoken() async {
    setState(() {
      isLoading = true;
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token=  prefs.getString('userToken');
    print("===my technic==token =====${token}===============");
    setState(() {

    });
    if(token==null){

      setState(() {
        isLoading=false;
      });
    }else {
      getUserDataaa();
      setState(() {
        islogin=true;


      });
    }
  }

  Future<void> share({String? referCode})  async {
    FlutterShare.share(
        title: 'HELLOSTAY',
        text: "HELLOSTAY",
        linkUrl: 'https://g.co/kgs/urtYWPz',
        chooserTitle: 'Example Chooser Title'
    );
  }

  GetUserData?getUserData;
  Future<void> getUserDataaa() async {


    var headers = {
      'Authorization': 'Bearer $token'
    };
    print(token);
    var request = http.MultipartRequest('GET', Uri.parse('${baseUrl}me'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    print("===my technic=======${request.url}===============");
    print("===my technic=======${request.fields}===============");
    if (response.statusCode == 200) {
      var result =await response.stream.bytesToString();
      print("===my technic=======${result}===============");
      var finalresult=jsonDecode(result);

      if(finalresult['status']==1){
        setState(() {
          getUserData=GetUserData.fromJson(finalresult);

          isLoading = false;
        });

      }
    }
    else {
      print(response.reasonPhrase);
    }

  }

  bool isLoading=false;
  Future<void> sessionremove() async {

    setState(() {
      isLoading=true;
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userToken');
    setState(() {
      isLoading=false;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 50,),
          islogin==true?
          Container(
            height: 80,
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 8),
            margin: EdgeInsets.symmetric(horizontal: 15),
            alignment: Alignment.center,
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),

                CircleAvatar(
                  radius: 28,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage('${getUserData?.data.avatarUrl??""}'),
                    child: Center(child: Icon(Icons.person_outline_outlined,size: 30,),),
                    radius: 25,),
                ),
                // Container(
                //   height: 55,
                //   width: 55,
                //   alignment: Alignment.center,
                //   child: Text(
                //     "y",
                //   //  getData.read("UserLogin")["name"][0],
                //     style: TextStyle(
                //    //   fontFamily: FontFamily.gilroyBold,
                //       fontSize: 22,
                //       color: Colors.orange
                //     ),
                //   ),
                //   decoration: BoxDecoration(
                //     shape: BoxShape.circle,
                //     color: Colors.grey.shade200,
                //   ),
                // ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${getUserData?.data.firstName??"  " } ${getUserData?.data.lastName??""}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: AppColors.blackTemp,fontFamily: 'rubic'),),
                      // Text("${getUserData?.data.firstName??""} ${getUserData?.data.lastName??""}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: AppColors.blackTemp),),


                      // Text(
                      //   "Gopal Bankey",
                      // //  getData.read("UserLogin")["name"],
                      //   style: TextStyle(
                      //    // fontFamily: FontFamily.gilroyBold,
                      //     fontSize:20,
                      //     color: Colors.black,
                      //   ),
                      // ),


                      // SizedBox(
                      //   height: 8,
                      // ),
                      Row(
                        children: [
                          Icon(Icons.email),
                          // Image.asset(
                          //   "assets/phone-call.png",
                          //   height: 15,
                          //   width: 15,
                          // ),
                          SizedBox(
                            width: 5,
                          ),

                          Expanded(child: Text("${getUserData?.data.email??""}",style: TextStyle(fontSize: 12,color: AppColors.blackTemp,fontFamily: 'rubic'),)),

                          // Text(
                          //   "+91 9926202390",
                          //  // "${getData.read("UserLogin")["ccode"]} ${getData.read("UserLogin")["mobile"]}",
                          //  //  style: TextStyle(
                          //  //    fontFamily: FontFamily.gilroyMedium,
                          //  //  ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>EditProfileScreen()));
                    //editProfileBottomSheet();
                  },
                  child: Container(
                      height: 30,
                      width: 30,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(5),
                      child:Icon(Icons.edit)

                    // Image.asset(
                    //   "assets/edit.png",
                    // ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),

              ],
            ),


            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(15),
            ),
          )
              :  Container(
            height: 70,
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 8),
            margin: EdgeInsets.symmetric(horizontal: 15),
            alignment: Alignment.center,
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Container(
                  height: 55,
                  width: 55,
                  alignment: Alignment.center,
                  child: Text(
                    "Hi",
                    //  getData.read("UserLogin")["name"][0],
                    style: TextStyle(
                      //   fontFamily: FontFamily.gilroyBold,
                        fontSize: 22,
                        color: AppColors.primary
                    ),
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade200,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Hello Guest",
                        //  getData.read("UserLogin")["name"],
                        style: TextStyle(
                          fontSize:20,
                          color: Colors.black,fontFamily: 'rubic'
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
                        },
                        child: Text(
                          "Login/Register",style: TextStyle(color: Colors.blueAccent),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  width: 10,
                ),

              ],
            ),


            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          // SizedBox(
          //   height: 15,
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 15),
          //   child: Row(
          //
          //     children: [
          //       Container(
          //         height: 30,
          //         width: 30,
          //         alignment: Alignment.center,
          //         child: Icon(Icons.wallet_outlined),
          //         decoration: BoxDecoration(
          //           shape: BoxShape.circle,
          //           color: Colors.grey.shade200,
          //         ),
          //       ),
          //       SizedBox(width: 20,),
          //       Container(
          //           width:200,
          //           child: Text("My Wallet",style: TextStyle(fontSize: 20),)),
          //    SizedBox(width: 40,),
          //    //   SizedBox(width: MediaQuery.sizeOf(context).width * .5,),
          //       Icon(Icons.arrow_forward_ios)
          //
          //
          //     ],
          //   ),
          // ),


          SizedBox(
            height: 15,
          ),
          if( islogin==true)
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>MyWallet()));
              },
              child: Row(

                children: [
                  Container(
                    height: 30,
                    width: 30,
                    alignment: Alignment.center,
                    child: Icon(Icons.wallet),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade200,
                    ),
                  ),
                  SizedBox(width: 20,),

                  Container(
                      width:200,
                      child: Text("My Wallet",style: TextStyle(fontSize: 16,fontFamily: 'rubic'),)),
                  SizedBox(width: 40,),
                  //   SizedBox(width: MediaQuery.sizeOf(context).width * .5,),
                  Icon(Icons.arrow_forward_ios)


                ],
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>TermsCondition()));
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Row(

                children: [
                  Container(
                    height: 30,
                    width: 30,
                    alignment: Alignment.center,
                    child: Icon(Icons.terminal),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade200,
                    ),
                  ),
                  SizedBox(width: 20,),
                  Container(
                      width:200,
                      child: Text("Terms & Conditions",style: TextStyle(fontSize: 16,fontFamily: 'rubic'),)),
                  SizedBox(width: 40,),
                  //   SizedBox(width: MediaQuery.sizeOf(context).width * .5,),
                  Icon(Icons.arrow_forward_ios)


                ],
              ),
            ),
          ),

          SizedBox(
            height: 15,
          ),
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>PrivacyScreen()));
            },
            child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Row(

                    children: [
                      Container(
                        height: 30,
                        width: 30,
                        alignment: Alignment.center,
                        child: Icon(Icons.policy_outlined),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade200,
                        ),
                      ),
                      SizedBox(width: 20,),
                      Container(
                          width:200,
                          child: Text("Privacy Policy",style: TextStyle(fontSize:16,fontFamily: 'rubic'),)),
                      SizedBox(width: 40,),
                      //   SizedBox(width: MediaQuery.sizeOf(context).width * .5,),
                      Icon(Icons.arrow_forward_ios),

                    ]
                )),
          ),
          // SizedBox(
          //   height: 15,
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 15),
          //   child: Row(
          //
          //     children: [
          //       Container(
          //         height: 30,
          //         width: 30,
          //         alignment: Alignment.center,
          //         child: Icon(Icons.question_mark),
          //         decoration: BoxDecoration(
          //           shape: BoxShape.circle,
          //           color: Colors.grey.shade200,
          //         ),
          //       ),
          //       SizedBox(width: 20,),
          //       Container(
          //           width:200,
          //           child: Text("FAQs",style: TextStyle(fontSize: 16,fontFamily: 'rubic'),)),
          //       SizedBox(width: 40,),
          //       //   SizedBox(width: MediaQuery.sizeOf(context).width * .5,),
          //       Icon(Icons.arrow_forward_ios)
          //
          //
          //     ],
          //   ),
          // ),
          SizedBox(
            height: 15,
          ),
          InkWell(
            onTap: (){
              share();
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Row(

                children: [
                  Container(
                    height: 30,
                    width: 30,
                    alignment: Alignment.center,
                    child: Icon(Icons.share),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade200,
                    ),
                  ),
                  SizedBox(width: 20,),
                  Container(
                      width:200,
                      child: Text("Share",style: TextStyle(fontSize:16,fontFamily: 'rubic'),)),
                  SizedBox(width: 40,),
                  //   SizedBox(width: MediaQuery.sizeOf(context).width * .5,),
                  Icon(Icons.arrow_forward_ios)


                ],
              ),
            ),
          ),


          SizedBox(
            height: 15,
          ),
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ReferAndEranScreen(referCode: getUserData?.data.referralCode, )));
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Row(

                children: [
                  Container(
                    height: 30,
                    width: 30,
                    alignment: Alignment.center,
                    child: Icon(Icons.outbond_rounded),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade200,
                    ),
                  ),
                  SizedBox(width: 20,),
                  Container(
                      width:200,
                      child: Text("Refer",style: TextStyle(fontSize:16,fontFamily: 'rubic'),)),
                  SizedBox(width: 40,),
                  //   SizedBox(width: MediaQuery.sizeOf(context).width * .5,),
                  Icon(Icons.arrow_forward_ios)


                ],
              ),
            ),
          ),
          // SizedBox(
          //   height: 15,
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 15),
          //   child: Row(
          //
          //     children: [
          //       Container(
          //         height: 30,
          //         width: 30,
          //         alignment: Alignment.center,
          //         child: Icon(Icons.contact_page_outlined),
          //         decoration: BoxDecoration(
          //           shape: BoxShape.circle,
          //           color: Colors.grey.shade200,
          //         ),
          //       ),
          //       SizedBox(width: 20,),
          //       Container(
          //           width:200,
          //           child: Text("Contacts",style: TextStyle(fontSize: 20),)),
          //       SizedBox(width: 40,),
          //       //   SizedBox(width: MediaQuery.sizeOf(context).width * .5,),
          //       Icon(Icons.arrow_forward_ios)
          //
          //
          //     ],
          //   ),
          // ),
          if( islogin==true)

          SizedBox(
            height: 15,
          ),
          if( islogin==true)
          InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Confirm Logout",style: TextStyle(color: AppColors.blackTemp,fontFamily: 'rubic',fontSize: 16,fontWeight: FontWeight.bold),),
                      content: const Text("Are you sure to Logout?",style: TextStyle(fontSize: 16,fontFamily: 'rubic'),),
                      actions: <Widget>[
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary),
                          child: const Text("YES",style: TextStyle(color: AppColors.white,fontFamily: 'rubic'),),
                          onPressed: () async {
                            setState(() {
                              sessionremove();
                            });
                            Navigator.pop(context);
                            // SystemNavigator.pop();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const BottomNavBar(),
                                ));
                          },
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary),
                          child: const Text("NO",style: TextStyle(color: AppColors.white,fontFamily: 'rubic'),),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    );
                  });

            },
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Row(

                children: [
                  Container(
                    height: 30,
                    width: 30,
                    alignment: Alignment.center,
                    child: Icon(Icons.logout),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade200,
                    ),
                  ),
                  SizedBox(width: 20,),

                  Container(
                      width:200,
                      child: Text("Logout",style: TextStyle(fontSize:16,fontFamily: 'rubic'),)),
                  // Container(
                  //     width:200,
                  //     child: Text("Logout",style: TextStyle(fontSize: 20),)),
                  SizedBox(width: 40,),
                  //   SizedBox(width: MediaQuery.sizeOf(context).width * .5,),
                  Icon(Icons.arrow_forward_ios)


                ],
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          //if( islogin==true)
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>SettingsScreen()));

              },
              child: Row(

                children: [
                  Container(
                    height: 30,
                    width: 30,
                    alignment: Alignment.center,
                    child: Icon(Icons.settings),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade200,
                    ),
                  ),
                  SizedBox(width: 20,),
                  Container(
                      width:200,
                      child: Text("Settings",style: TextStyle(fontSize:16,fontFamily: 'rubic'),)),
                  SizedBox(width: 40,),
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
}


//
// class MyprofileScr extends StatefulWidget {
//   const MyprofileScr({Key? key}) : super(key: key);
//
//   @override
//   State<MyprofileScr> createState() => _MyprofileScrState();
// }
//
// class _MyprofileScrState extends State<MyprofileScr> {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(child: Scaffold(appBar:
//    PreferredSize(preferredSize:Size.fromHeight(80),
//    child:  Container(
//      color: AppColors.primary,
//      height: 80,width: MediaQuery.of(context).size.width,
//    child: Padding(
//      padding: const EdgeInsets.all(5),
//      child: Row(children: [
//        SizedBox(width: 15,),
//        CircleAvatar(
//          radius: 28,
//          child: CircleAvatar(
//            backgroundImage: NetworkImage('${getUserData?.data.avatarUrl??""}'),
//            child: Center(child: Icon(Icons.person,size: 30,),),
//            radius: 25,),
//        ),
//
//       SizedBox(width: 20,),
//
//        token==null?
//        InkWell(
//            onTap: () {
//
//              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage(),));
//            },
//            child: Text("login/Sign up",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13,color: AppColors.white),)):
//
//
//        Column(
//          mainAxisAlignment: MainAxisAlignment.center,
//          crossAxisAlignment: CrossAxisAlignment.start,
//          children: [
//
//
//           Text("${getUserData?.data.firstName??""} ${getUserData?.data.lastName??""}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13,color: AppColors.white),),
//          Text("${getUserData?.data.email??""}",style: TextStyle(fontSize: 12,color: AppColors.white),),
//
//
//
//        ],),
// Spacer(),
//        token==null?SizedBox():
//        InkWell(
//          onTap: () {
//
//            Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen(),));
//          },
//            child: Icon(Icons.edit,color: AppColors.white,)),
//      ]),
//    ),
//    ),),
//     body:
//
//     isLoading?Container(height: MediaQuery.of(context).size.height,width: MediaQuery.of(context).size.width,
//     child: Center(child: CircularProgressIndicator(),),
//     ):
//     SingleChildScrollView(child: Padding(
//       padding: const EdgeInsets.only(top: 20,bottom: 20,left: 5,right: 5),
//       child: Column(children: [
//         tabProfile(context,"Notification"),
//         tabProfile(context,"Wallet"),
//         // tabProfile(context,"Privecy"),
//         // tabProfile(context,"Wallet"),
//         // tabProfile(context,"Wallet"),
//         // tabProfile(context,"Wallet"),
//         InkWell(
//             onTap: () {
//               showDialog(
//                   context: context,
//                   barrierDismissible: false,
//                   builder: (BuildContext context) {
//                     return AlertDialog(
//                       title: const Text("Confirm Logout"),
//                       content: const Text("Are you sure to Logout?"),
//                       actions: <Widget>[
//                         ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                               primary: AppColors.primary),
//                           child: const Text("YES"),
//                           onPressed: () async {
//                             setState(() {
//                               sessionremove();
//                             });
//                             Navigator.pop(context);
//                             // SystemNavigator.pop();
//                             Navigator.pushReplacement(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => const BottomNavBar(),
//                                 ));
//                           },
//                         ),
//                         ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                               primary: AppColors.primary),
//                           child: const Text("NO"),
//                           onPressed: () {
//                             Navigator.of(context).pop();
//                           },
//                         )
//                       ],
//                     );
//                   });
//
//             },
//             child: tabProfile(context,"Log out")
//
//         ),
//
//
//       ]),
//     ),),
//     ));
//   }
//
//   Widget tabProfile(BuildContext context,String tabName){
//
//
//     return
//       Padding(
//       padding: const EdgeInsets.only(bottom: 5),
//       child: Card(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(15.0),),
//         elevation: 2,
//         child:
//
//         Container (height: 50,decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
//
//
//           child:
//
//
//           Row(children: [
//
//             SizedBox(width: 15,),
//
//             Text("${tabName}",style: TextStyle(fontWeight: FontWeight.w500,color: AppColors.tabtextColor,fontSize: 15),),
//             Spacer(),
//             Icon(Icons.arrow_forward_ios,color: AppColors.blackTemp,size: 16,),
//             SizedBox(width: 5,),
//
//
//           ]),),
//
//       ),
//     );
//   }
//   @override
//   void initState() {
//     // TODO: implement initState
//     gettoken();
//     super.initState();
//   }
//   var token;
//   Future<void> gettoken() async {
//     setState(() {
//       isLoading = true;
//     });
//
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     token= await prefs.getString('userToken');
//     print("===my technic=======${token}===============");
//     setState(() {
//
//     });
//     if(token==null){
//
//       setState(() {
//         isLoading=false;
//       });
//     }else {
//       getUserDataaa();
//     }
//   }
//
//   GetUserData?getUserData;
//   Future<void> getUserDataaa() async {
//
//
//     var headers = {
//       'Authorization': 'Bearer $token'
//     };
//     var request = http.MultipartRequest('GET', Uri.parse('${baseUrl}me'));
//
//     request.headers.addAll(headers);
//
//     http.StreamedResponse response = await request.send();
//     print("===my technic=======${request.url}===============");
//     print("===my technic=======${request.fields}===============");
//     if (response.statusCode == 200) {
//       var result =await response.stream.bytesToString();
//       print("===my technic=======${result}===============");
//       var finalresult=jsonDecode(result);
//
//       if(finalresult['status']==1){
//         setState(() {
//         getUserData=GetUserData.fromJson(finalresult);
//
//           isLoading = false;
//         });
//
//       }
//     }
//     else {
//     print(response.reasonPhrase);
//     }
//
//   }
//
//   bool isLoading=false;
// Future<void> sessionremove() async {
//
//   setState(() {
//     isLoading=true;
//   });
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
// await prefs.remove('userToken');
//   setState(() {
//     isLoading=false;
//   });
// }
//
// }
