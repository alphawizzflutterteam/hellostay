import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hellostay/constants/colors.dart';
import 'package:hellostay/model/PrivacyModel.dart';
import 'package:hellostay/repository/apiConstants.dart';
import 'package:http/http.dart' as http;

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {

   String? privacy;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getApi();
  }
  PrivacyModel? privacyModel;

  getApi() async {
    var request = http.MultipartRequest('GET', Uri.parse('${baseUrl1}page/privacy-policy'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var finaResult = jsonDecode(result);
    //  print(await response.stream.bytesToString());
      setState(() {
        privacy=finaResult['data']['row']['content'].toString();
        print(privacy);
      });

      
    }
    else {
    print(response.reasonPhrase);
    print("api not run");
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

        title:  Text('Privacy Policy',

          style: TextStyle(
              fontFamily: "rubic",
              fontSize: 20.0,
              color: AppColors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            privacy==null||privacy==""?Center(child: CircularProgressIndicator(color: AppColors.blackTemp),):
                Html(data: "${privacy}",style: {
                  "body": Style(
                      fontSize: FontSize(16.0),
                    fontFamily: "rubic",
                    color: Colors.black54
                    //fontWeight: FontWeight.bold,
                  ),"h2": Style(
                      fontSize: FontSize(16.0),
                    fontFamily: "rubic",
                   color: Colors.black,

                    //fontWeight: FontWeight.bold,
                  ),
                  "h1": Style(
                      fontSize: FontSize(16.0),
                    fontFamily: "rubic",
                   color: Colors.black,

                    //fontWeight: FontWeight.bold,
                  ),
                } ,)
          ],
        ),
      ),
    );
  }
}
