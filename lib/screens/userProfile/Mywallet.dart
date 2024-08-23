
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hellostay/constants/colors.dart';
import 'package:hellostay/model/wallet_model.dart';
import 'package:hellostay/repository/apiConstants.dart';
import 'package:hellostay/utils/globle.dart';
import 'package:hellostay/utils/sharedPreference.dart';

import 'package:http/http.dart'as http;
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../loginScreen.dart';
import 'AddBankDetails.dart';

class MyWallet extends StatefulWidget {
  const MyWallet({Key? key}) : super(key: key);

  @override
  State<MyWallet> createState() => _MyWalletState();
}

class _MyWalletState extends State<MyWallet> {

  late Razorpay _razorpay;
  TextEditingController amountController = TextEditingController();
  bool paymentSucess=false;


  WalletModel? walletModel;

  getWalletHistory() async {
    var headers = {
      'Authorization': 'Bearer $authToken'
    };
    var request = http.Request('GET', Uri.parse('${baseUrl1}auth/wallet-transaction'));
    print('authtoekn------${authToken}');

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      var finalResult = jsonDecode(finalResponse);
      setState(() {
         walletModel = WalletModel.fromJson(finalResult);
      });

    }
    else {
    print(response.reasonPhrase);
    }

  }

  @override
  void initState() {
    // TODO: implement initState

    checkLogin();
    getWalletHistory();
    _razorpay=Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    super.initState();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    log('Success Response:  $response');
    Fluttertoast.showToast(msg: "SUCCESS: ${response.paymentId}", toastLength: Toast.LENGTH_SHORT);
    paymentSucess=true;

    setState(() {

    });
    addAmountApi();
   // bookingApi();

  }

  void _handlePaymentError(PaymentFailureResponse response) {
    log('Error Response: ${response.code} - ${response.message}');
    paymentSucess=false;
    Fluttertoast.showToast(
      msg: "ERROR: ${response.code} - ${response.message}",
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    log('External SDK Response:  $response');
    Fluttertoast.showToast(msg: "EXTERNAL_WALLET: ${response.walletName}", toastLength: Toast.LENGTH_SHORT);
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



  Future<void> openRazorpay()async {
    var options={
      'key':'rzp_test_1DP5mmOlF5G5ag',
      'amount': double.parse(addAmountCtr.text ?? '0.0').toInt() * 100 ,
      'description':'Hotel..',
      //'send_sms_hash':true,
      'prefill':{'contact':'8888888888','email':'test@razorpay.com'},
      // 'external':['payment']
    };
    try
    {
      _razorpay.open(options);
    }
    catch(e){
      debugPrint('Error--------: ${e}');
    }
  }

 addAmountApi()
 async {
print("addddddddddddddd");
   var headers = {
     'Authorization': 'Bearer ${token}'
   };
   var request = http.MultipartRequest('POST', Uri.parse('https://hellostay.com/api/auth/add-wallet-amount'));
   request.fields.addAll({
     'amount': addAmountCtr.text
   });

   request.headers.addAll(headers);

   http.StreamedResponse response = await request.send();

   if (response.statusCode == 200) {
     // print(await response.stream.bytesToString());
     var finalResult=jsonDecode(await response.stream.bytesToString());
     print("successfull amount add");
     if(finalResult['status'].toString()=='1')
       {
         getWalletHistory();
       }
 }
 else {
     print(" amount not  add");
 print(response.reasonPhrase);
 }

 }



  final addAmountCtr = TextEditingController();

  void _showCustomDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String inputText = '';

        return AlertDialog(
          title: const Text(
            'Add Amount',
            style: TextStyle(fontFamily: "rubic"),
          ),
          content: TextFormField(
            keyboardType: TextInputType.number,

            controller: addAmountCtr,
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,),

            onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('Cancel',style: TextStyle(color: AppColors.white,fontFamily: "rubic"),),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,),
        onPressed: () async {
            await  openRazorpay();
        // Do something with the inputText
        // print('Input Text: $inputText');

        Navigator.of(context).pop();
        },
        child: Text('Add',style: TextStyle(color: AppColors.white,fontFamily: "rubic"),),

            )
]
            ),
          ],
        );
      },
    );
  }
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.whiteTemp,

        title:  const Text('My Wallet',

          style: TextStyle(
            fontFamily: "rubic",
            fontSize: 20.0,
            color: AppColors.white),
        ),
        // actions: [
        //   Padding(
        //     padding:  const EdgeInsets.only(right: 10),
        //     child: InkWell(
        //         onTap: (){
        //          // Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationScreen()));
        //         },
        //         child: const Icon(Icons.notifications,color: AppColors.whiteTemp,)),
        //   ),
        // ],
      ),
      body:
      SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Center(child: Text("Available Balance",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,fontFamily: 'rubic'),)),

             Text( ' ${walletModel?.walletAmount ?? ""}',style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: AppColors.secondary,fontFamily: 'rubic'),),
             const SizedBox(height: 20,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                InkWell(
                  onTap: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AddBankDetails()));

                    // if (_formKey.currentState!.validate()) {
                    //   //walletHistroy();
                    //  // Get.to(AddAmount(walletBalance: walletHistorymodel?.wallet??'--',))?.then((value) => walletHistroy() );
                    // }
                    // addMoney();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.secondary,
                    ),
                    height: 40,
                  //  width: MediaQuery.of(context).size.width/1.5,
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Request for Withdrawal",
                          style: TextStyle(color: AppColors.whiteTemp,fontSize: 15,fontFamily: 'rubic'),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10,),

                InkWell(
                  onTap: (){
                    addAmountCtr.clear();
                    setState(() {

                    });
                    _showCustomDialog();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.secondary,
                    ),
                    height: 40,
                   // width: MediaQuery.of(context).size.width/3,
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Add Amount",
                          style: TextStyle(color: AppColors.whiteTemp,fontSize: 15,fontFamily: 'rubic'),
                        ),
                      ),
                    ),
                  ),
                ),
              ],),

              const SizedBox(height: 20,),
               const Align(
                alignment: Alignment.topLeft,
                  child: Row(children: [
                    Icon(Icons.account_balance_wallet, color:AppColors.primary,),
                    SizedBox(width: 10,),
                    Text("Wallet History",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,fontFamily: 'rubic'),),
                  ],),),


      walletModel == null ? Center(child: CircularProgressIndicator(color: Colors.red,),) : walletModel?.data?.isEmpty ?? true ?
          
      const Text("Not Available",):
      ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: walletModel?.data?.length,
        itemBuilder: (context, index) {
          // List<dynamic> reverseDataList = walletModel!.data!.reversed;
        var item = walletModel?.data?[index];
        return Card(
          elevation: 2.0,
          margin: const EdgeInsets.symmetric(
              horizontal: 16.0, vertical: 8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   'Amount: ${walletModel?.walletAmount ?? ""}',
                //   style: const TextStyle(
                //       fontSize: 14.0, fontWeight: FontWeight.bold),
                // ),
                // const SizedBox(height: 5.0),
                Text(
                  'REQUEST DATE:  ${DateFormat("dd/MM/yyyy").format(DateTime.parse(walletModel!.data?[index].createdAt ?? ""))}',
                  // 'REQUEST DATE: ${walletModel!.data?[index].createdAt}',
                  style: const TextStyle(fontSize: 15.0,fontFamily: 'rubic'),
                ),  Text(
                  'Title: ${walletModel!.data?[index].title}',
                  style: const TextStyle(fontSize: 15.0,fontFamily: 'rubic'),
                ),
                //const SizedBox(height: 5.0),
                Text(
                  '${walletModel?.data?[index].description.toString().replaceAll(', ', '\n').replaceAll(',','\n')}',
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                      fontSize: 15.0,fontFamily: 'rubic'),
                ),
                Text(
                  'Credit Amount : ${walletModel?.data?[index].credit}',
                  style: const TextStyle(
                      fontSize: 15.0, fontWeight: FontWeight.bold,color: Colors.green,fontFamily: 'rubic'),
                ),  Text(
                  'Debit Amount : ${walletModel?.data?[index].debit}',
                  style: const TextStyle(
                      fontSize: 15.0, fontWeight: FontWeight.bold,color: Colors.red,fontFamily: 'rubic'),
                ),
              ],
            ),
          ),
        );
      },)

      //         // walletHistorymodel?.data == null ? Center(child: CircularProgressIndicator(color: Colors.red,),) : walletHistorymodel?.data?.isEmpty ?? true ?
      //         // const Text("Not Available",): ListView.builder(
      //         //   shrinkWrap: true,
      //         //   physics: const NeverScrollableScrollPhysics(),
      //         //   itemCount: walletHistorymodel?.data?.length,
      //         //   itemBuilder: (context, index) {
      //         //   var item = walletHistorymodel?.data?[index];
      //         //   return Card(
      //         //     elevation: 2.0,
      //         //     margin: const EdgeInsets.symmetric(
      //         //         horizontal: 16.0, vertical: 8.0),
      //         //     child: Padding(
      //         //       padding: const EdgeInsets.all(16.0),
      //         //       child: Column(
      //         //         crossAxisAlignment: CrossAxisAlignment.start,
      //         //         children: [
      //         //           Text(
      //         //             'Amount: ${item?.amount}',
      //         //             style: const TextStyle(
      //         //                 fontSize: 14.0, fontWeight: FontWeight.bold),
      //         //           ),
      //         //           const SizedBox(height: 5.0),
      //         //           Text(
      //         //             'Payment Type: ${item?.paymentType}',
      //         //             style: const TextStyle(fontSize: 14.0),
      //         //           ),
      //         //           const SizedBox(height: 5.0),
      //         //           Text(
      //         //             'Status: ${item?.status}',
      //         //             style: const TextStyle(
      //         //                 fontSize: 14.0, fontWeight: FontWeight.bold),
      //         //           ),
      //         //           Row(
      //         //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         //             children: [
      //         //               Text(
      //         //                 'Date : ${item?.createDt}',
      //         //                 style: const TextStyle(
      //         //                     fontSize: 14.0, fontWeight: FontWeight.bold),
      //         //               ),
      //         //             ],
      //         //           ),
      //         //         ],
      //         //       ),
      //         //     ),
      //         //   );
      //         // },)
      //       ],
      //     ),
      //   ),
      // ),]
    ]
    ))) );
  }
}
