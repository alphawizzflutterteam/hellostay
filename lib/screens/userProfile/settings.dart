import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/colors.dart';
import '../loginScreen.dart';
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
    token=  prefs.getString('userToken');
    print("===my technic==token =====${token}===============");
    setState(() {

    });
    if(token==null)
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.whiteTemp,

        title:  Text('Settings',

          style: TextStyle(
              fontFamily: "rubic",
              fontSize: 20.0,
              color: AppColors.white),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Row(
              children: [
                Container(
                  height: 30,
                  width: 30,
                  alignment: Alignment.center,
                  child: Icon(Icons.delete
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade200,
                  ),
                ),
                SizedBox(width: 20,),
                Container(
                    width:200,
                    child: Text("Delete Account",style: TextStyle(fontSize:16,fontFamily: 'rubic'),)),
                SizedBox(width: 40,),
                //   SizedBox(width: MediaQuery.sizeOf(context).width * .5,),
                Icon(Icons.arrow_forward_ios)


              ],
            ),
          ),

        ],
      ),


    );
  }
}
