import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hellostay/repository/apiConstants.dart';
import 'package:hellostay/screens/loginScreen.dart';
import 'package:hellostay/utils/globle.dart';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';



import '../../constants/colors.dart';
import '../../model/notification_model.dart';
class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin();
    getNotificationApi();
  }
  NotificationModel? notificationModel;
  bool loading =false;

  var token;
  Future<void> checkLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token=  prefs.getString('userToken');
    print("===my technic==token =====${token}===============");
    setState(() {

    });
    if(token==null)
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
  }
  getNotificationApi() async {
    setState(() {
      loading=true;
    });
    var headers = {
      'Authorization': 'Bearer $authToken'
    };
    var request = http.Request('GET', Uri.parse('${baseUrl1}notifications'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    print(request.url);

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      print("kkk");
      var finaResult = jsonDecode(result);
      print("cccc");
      //  print(await response.stream.bytesToString());
      setState(() {
        notificationModel=NotificationModel.fromJson(finaResult);
        loading=false;

       // isLoading = false;
      });

    }
    else {
    print(response.reasonPhrase);
    loading=false;
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.whiteTemp,

          title:  Text('Notification',

            style: TextStyle(
                fontFamily: "rubic",
                fontSize: 20.0,
                color: AppColors.white),
          ),
        ),
      body:!loading ? notificationModel?.data?.rows?.data?.isNotEmpty ?? false ? ListView.builder(
        itemCount: notificationModel?.data?.rows?.data?.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
            child: Container(
             // height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.primary.withOpacity(.1)
              ),

              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppColors.primary.withOpacity(.3)
                      ),
                        child: Icon(Icons.notification_add_outlined,color: AppColors.primary,)),
                    SizedBox(width: 10,),
                    Expanded(child: Text(notificationModel?.data?.rows?.data?[index].data?.notification?.message ?? '')),
                  ],
                ),
              ),
            ),
          );

      },)
      :Center(child: Text("No Notification Found"))
          :Center(child: CircularProgressIndicator(color: AppColors.primary,))

    );
  }
}
