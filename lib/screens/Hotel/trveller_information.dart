import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hellostay/repository/apiConstants.dart';
import 'package:hellostay/screens/Hotel/payment_success_screen.dart';
// import 'package:hellostay/screens/Hotel/razorpay_screen.dart';
import 'package:hellostay/utils/globle.dart';
import 'package:hellostay/utils/sharedPreference.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../constants/colors.dart';
import '../../model/wallet_model.dart';
import '../../repository/apiStrings.dart';
import '../../utils/traver_tile.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';

import '../bottom_nav/bottom_Nav_bar.dart';

class TravellerInformation extends StatefulWidget {
  String? bookingId;
  String? totalAmount;
  String? couponCode;
  TravellerInformation(
      {Key? key, this.totalAmount, this.bookingId, this.couponCode})
      : super(key: key);

  @override
  State<TravellerInformation> createState() => _TravellerInformationState();
}

class _TravellerInformationState extends State<TravellerInformation> {
  late Razorpay _razorpay;
  String paymentType = "offline_payment";
  bool paymentSucess = false;
  bool payByWallet = false;
  bool payAtHotel = false;
  bool _isChecked1 = false;
  bool _isChecked = false;
  int remaningAmount = 0;

  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  String selectedTitle = 'Mr';
  double? totalHeight;

  List<String> selectedTitles = List.generate(adultCount1, (index) => 'Mr.');
  List<String> firstNames = List.generate(adultCount1, (index) => '');
  List<String> lastNames = List.generate(adultCount1, (index) => '');

  List<String> selectedTitles2 =
      List.generate(childrenCount1, (index) => 'Mr.');
  List<String> firstNames2 = List.generate(childrenCount1, (index) => '');
  List<String> lastNames2 = List.generate(childrenCount1, (index) => '');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getWalletHistory();

    totalHeight = double.parse((childrenCount1 + adultCount1).toString());
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  WalletModel? walletModel;
  String? walletAmount;

  getWalletHistory() async {
    var headers = {'Authorization': 'Bearer $authToken'};
    var request =
        http.Request('GET', Uri.parse('${baseUrl1}auth/wallet-transaction'));
    print('authtoekn------${authToken}');

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      var finalResult = jsonDecode(finalResponse);
      setState(() {
        walletModel = WalletModel.fromJson(finalResult);
        walletAmount = walletModel?.walletAmount ?? "";
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    log('Success Response:  $response');
    Fluttertoast.showToast(
        msg: "SUCCESS: ${response.paymentId}", toastLength: Toast.LENGTH_SHORT);
    paymentSucess = true;

    bookingApi(response.paymentId ?? "");
  }

  //
  // void _handlePaymentError(PaymentFailureResponse response) {
  //   log('Error Response:  $response');
  //   Fluttertoast.showToast(msg: "ERROR: ${response.code}", toastLength: Toast.LENGTH_SHORT);
  // }
  void _handlePaymentError(PaymentFailureResponse response) {
    log('Error Response: ${response.code} - ${response.message}');
    Fluttertoast.showToast(
      msg: "ERROR: ${response.code} - ${response.message}",
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    log('External SDK Response:  $response');
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: ${response.walletName}",
        toastLength: Toast.LENGTH_SHORT);
  }

  Future<void> openCheckout(double amount) async {
    var options = {
      'key': 'rzp_live_MmLFC6z5L7yGRk',
      'amount': amount.toInt() * 100,
      // 'amount': double.parse(widget.totalAmount ?? '0.0').toInt() * 100 ,
      'description': 'Hotel..',
      //'send_sms_hash':true,
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      // 'external':['payment']
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error--------: ${e}');
    }
  }
bool isLoading=false;
  bookingApi(String paymentId) async {

// print(_isChecked==true ? (double.parse(walletAmount ?? "0")  <= double.parse(widget.totalAmount ?? "0" ) ) ? walletAmount.toString() ?? "0" : widget.totalAmount.toString() ?? "0" : "0");
// print("booking is ${widget.bookingId }");
// print('token ---${authToken}');
// print(_isChecked1);
    var param = {
      'code': widget.bookingId ?? "",
      'first_name': firstNames[0].toString(),
      'last_name': lastNames[0].toString(),
      'email': emailController.text,
      'phone': mobileController.text,
      // 'payment_gateway': "offline_payment",

      'payment_gateway':
          paymentSucess == false ? "offline_payment" : "razorpay",
      'payment_id': paymentId,
      // 'payment_gateway': paymentSucess==true ? "online_payment" : "offline_payment",
      'coupon_code': widget.couponCode ?? "",
      'term_conditions': 'on',
      'gst_in': gstController.text,
      'company_name': companyNameController.text,
      // 'credit': payByWallet==true ? widget.totalAmount.toString(): "0"
      'credit': _isChecked == true
          ? (double.parse(walletAmount ?? "0.00") <=
                  double.parse(widget.totalAmount ?? "0.00"))
              ? walletAmount ?? "0"
              : widget.totalAmount ?? "0"
          : "0"
    };

    List<Map<String, String>> guestsList = [];
    for (int i = 0; i < adultCount1; i++) {
      Map<String, String> guestData = {
        'passengers[$i][title]': selectedTitles[i].toString(),
        'passengers[$i][first_name]': firstNames[i].toString(),
        'passengers[$i][last_name]': lastNames[i].toString(),
        'passengers[$i][type]': 'Adult',
      };
      guestsList.add(guestData);
    }
    int k = 0;
    for (int i = adultCount1; i < (adultCount1 + childrenCount1); i++) {
      Map<String, String> guestData = {
        'passengers[$i][title]': selectedTitles2[k].toString(),
        'passengers[$i][first_name]': firstNames2[k].toString(),
        'passengers[$i][last_name]': lastNames2[k].toString(),
        'passengers[$i][type]': 'Children',
      };
      guestsList.add(guestData);
      k++;
    }

    var data = addMapListToData(param, guestsList);

    apiBaseHelper.postAPICall(checkoutApi, data).then((value) {
      print('kkkkk----data');
      print(data);

      var status = value['status'];
      print(status);

      //  adultCountList = [];
      //   childrenCountList = [];
      // adultCount1 = 0;
      //  childrenCount1 = 0;
      //   room = 0;
      //   childrenCountListOfList = [];
      isLoading=true;
      // setState(() {
      //
      // });
      setState(() {});

      if (status.toString() == '1') {
        print("-----booking success----");
        if (payAtHotel == true) {
          Fluttertoast.showToast(msg: "Booking Successful");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BottomNavBar()),
          );
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => PaymentSuccessfulScreen()));
        }
      } else {
        Fluttertoast.showToast(msg: value['message']);
        print("booking not sucees");
      }
      print(value);
    });
  }

  Map<String, String> addMapListToData(
      Map<String, String> data, List<Map<String, dynamic>> mapList) {
    for (var map in mapList) {
      map.forEach((key, value) {
        data[key] = value;
      });
    }
    return data;
  }

  Future<void> _openBottomSheet1(BuildContext context) async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          _isChecked = false;
          _isChecked1 = _isChecked;
          double remaningAmount = double.parse(widget.totalAmount ?? "0");
          // setState(() {
          //
          // });// Local variable for checkbox state

          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                height: 250.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Payment Options.",
                        style: TextStyle(
                            fontFamily: "rubic",
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Checkbox(
                            activeColor: AppColors.secondary,
                            checkColor: AppColors.whiteTemp,
                            visualDensity:
                                VisualDensity(horizontal: 2, vertical: 2),
                            value: _isChecked,
                            onChanged: (bool? newValue) {
                              setState(() {
                                _isChecked = newValue ?? false;
                                _isChecked1 =
                                    _isChecked; // If newValue is null, default to false
                                if (_isChecked == true)
                                  remaningAmount =
                                      (double.parse(widget.totalAmount ?? "0") -
                                          double.parse(walletAmount ?? "0"));
                                // remaningAmount=(int.parse(walletAmount ?? "0") - int.parse(widget.totalAmount ?? "0"));
                                else {
                                  remaningAmount =
                                      double.parse(widget.totalAmount ?? "0");
                                }
                              });
                            },
                          ),
                          InkWell(
                            onTap: () {
                              // payByWallet=true;
                              // payAtHotel=false;
                              // paymentSucess=false;
                              setState(() {
                                // bookingApi();
                              });
                            },
                            child: Container(
                              width: MediaQuery.sizeOf(context).width / 1.4,
                              // width: 200,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppColors.secondary),
                              child: Center(
                                  child: Text(
                                " Wallet",
                                style: TextStyle(
                                    color: AppColors.whiteTemp,
                                    fontFamily: "rubic"),
                              )),
                            ),
                          ),
                        ],
                      ),
                      if (_isChecked == false)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Available Balance: ",
                                style: TextStyle(
                                  fontFamily: "rubic",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AppColors.blackTemp,
                                ),
                              ),
                              Text(
                                "₹ ${walletAmount}",
                                style: TextStyle(
                                  fontFamily: "rubic",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AppColors.secondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (_isChecked == true)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Available Balance: ",
                                style: TextStyle(
                                  fontFamily: "rubic",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AppColors.blackTemp,
                                ),
                              ),
                              Text(
                                "₹ ${(double.parse(walletAmount ?? "0") - double.parse(widget.totalAmount ?? "0")) > 0 ? (double.parse(walletAmount ?? "0") - double.parse(widget.totalAmount ?? "0")) : "0.00"}",
                                style: TextStyle(
                                  fontFamily: "rubic",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AppColors.secondary,
                                ),
                              ),
                            ],
                          ),
                        ),

                      SizedBox(height: 40),
                      if (remaningAmount > 0)
                        isLoading == true  ?  Center(child: CircularProgressIndicator())  :   Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: () {
                                paymentSucess = false;
                                payByWallet = false;
                                payAtHotel = true;
                                isLoading=true;
                                setState(() {

                                });
                                bookingApi('');
                              },
                              child: Container(
                                // width: 100,
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppColors.primary),
                                child: Center(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Pay At Hotel   ₹ ${remaningAmount < 0 ? 0 : remaningAmount.toStringAsFixed(2)}",
                                    style: TextStyle(
                                        color: AppColors.whiteTemp,
                                        fontFamily: "rubic",
                                        fontSize: 12),
                                  ),
                                )),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                payByWallet = false;
                                payAtHotel = false;
                                setState(() {});

                                openCheckout(remaningAmount).then((value){
                                  isLoading=true;
                                  setState(() {

                                  });
                                });
                              },
                              child: Container(
                                // width: 100,
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppColors.primary),
                                child: Center(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Pay Online  ₹ ${remaningAmount < 0 ? 0 : remaningAmount.toStringAsFixed(2)}",
                                    style: TextStyle(
                                        color: AppColors.whiteTemp,
                                        fontFamily: "rubic",
                                        fontSize: 12),
                                  ),
                                )),
                              ),
                            ),
                          ],
                        ),

                      // InkWell(
                      //   onTap: (){
                      //     paymentSucess=false;
                      //     payByWallet=false;
                      //     payAtHotel=true;
                      //     setState(() {
                      //       bookingApi();
                      //     });
                      //
                      //   },
                      //   child: Container(
                      //     // width: 100,
                      //     height: 40,
                      //     decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(10),
                      //         color: AppColors.primary
                      //     ),
                      //     child: Center(child: Text("Pay At Hotel  (${remaningAmount < 0 ? 0 : remaningAmount})",style: TextStyle(color: AppColors.whiteTemp,fontFamily: "rubic"),)),
                      //   ),
                      // ),
                      // SizedBox(height: 20),

                      // Container(
                      //     height: 50,
                      //     child: Text( ' ${walletModel?.walletAmount ?? ""}',style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: AppColors.secondary,fontFamily: 'rubic'),)),

                      // SizedBox(height: 20),
                      // if(remaningAmount >= 0 )
                      // InkWell(
                      //   onTap: (){
                      //     payByWallet=false;
                      //     payAtHotel=false;
                      //     setState(() {
                      //
                      //     });
                      //
                      //     openCheckout();
                      //   },
                      //   child: Container(
                      //     // width: 100,
                      //     height: 40,
                      //     decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(10),
                      //         color: AppColors.primary

                      // ),
                      if (remaningAmount <= 0)
                        InkWell(
                          onTap: () {
                            isLoading=true;
                            setState(() {

                            });
                            bookingApi('');
                          },
                          child: isLoading == true  ?  Center(child: CircularProgressIndicator())  : Container(
                            // width: 100,
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.primary),
                            child: Center(
                                child:  Text(
                              "Book Now    ₹ 0.0",
                              style: TextStyle(
                                  color: AppColors.whiteTemp,
                                  fontFamily: "rubic"),
                            )),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        centerTitle: true,
        elevation: 0.0,
        title: const Padding(
          padding: EdgeInsets.only(top: 20.0, left: 5.0),
          child: Text(
            'Guest Information'
            '',
            style: TextStyle(
                fontFamily: "rubic",
                fontSize: 20.0,
                color: AppColors.blackTemp),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 10),
                  child: Text(
                    "Enter Adult Details : ",
                    style: TextStyle(fontSize: 16, fontFamily: "rubic"),
                  ),
                ),
                ListView.builder(
                  itemCount:
                      adultCount1, // Assuming a fixed count of 3 for the ListView
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Adult : ${index + 1}",
                                  style: TextStyle(
                                      fontSize: 16, fontFamily: "rubic")),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: DropdownButton<String>(
                                          elevation: 0,
                                          underline: SizedBox(),
                                          value: selectedTitles[index],
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedTitles[index] = newValue!;
                                              print(
                                                  '---${newValue}'); // Update selected title list
                                            });
                                          },
                                          //Mr., Mrs., Miss, and Ms.
                                          items: <String>[
                                            'Mr.',
                                            'Miss.',
                                            'Ms.',
                                            'Mrs.'
                                          ].map<DropdownMenuItem<String>>(
                                            (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                // height: 60,
                                                child:
                                                    Center(child: Text(value)),
                                              );
                                            },
                                          ).toList(),
                                        ),
                                      ),
                                      height: 55,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: AppColors.supportColor)),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Container(
                                      height: 55,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColors.supportColor),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return '   Enter First Name';
                                          }

                                          return null;
                                        },
                                        onChanged: (value) {
                                          firstNames[index] = value;
                                          print(
                                              'first name ${index + 1} ${value}'); // Update first name list
                                        },
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(
                                              left: 10, bottom: 3),

                                          // isDense: true,
                                          border: InputBorder.none,
                                          hintText: '  Enter First Name',
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Container(
                                  //   child: DropdownButton<String>(
                                  //     value: selectedTitles[index],
                                  //     onChanged: (String? newValue) {
                                  //       setState(() {
                                  //         selectedTitles[index] = newValue!;
                                  //         print('---${newValue}');// Update selected title list
                                  //       });
                                  //     },
                                  //     items: <String>['Mr', 'Miss', 'Mister'].map<DropdownMenuItem<String>>(
                                  //           (String value) {
                                  //         return DropdownMenuItem<String>(
                                  //           value: value,
                                  //           child: Container(
                                  //             height: 60,
                                  //             child: Center(child: Text(value)),
                                  //           ),
                                  //         );
                                  //       },
                                  //     ).toList(),
                                  //   ),
                                  // ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: AppColors.supportColor),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return '   Enter Last Name';
                                    }

                                    return null;
                                  },
                                  onChanged: (value) {
                                    lastNames[index] = value;
                                    print(
                                        'last name ${index} ${value}'); // Update last name list
                                  },
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.only(left: 10, bottom: 3),
                                    //  isDense: true,
                                    border: InputBorder.none,
                                    hintText: '  Enter Last Name',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                if (childrenCount1 > 1)
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 20),
                    child: Text(
                      "Enter Child Details : ",
                      style: TextStyle(fontSize: 16, fontFamily: "rubic"),
                    ),
                  ),
                ListView.builder(
                  itemCount:
                      childrenCount1, // Assuming a fixed count of 3 for the ListView
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        // shadowColor: Color(1),
                        shadowColor: AppColors.blackTemp.withOpacity(1),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Child : ${index + 1}",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: DropdownButton<String>(
                                          elevation: 0,
                                          underline: SizedBox(),
                                          value: selectedTitles2[index],
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedTitles2[index] =
                                                  newValue!;
                                              print(
                                                  '---${newValue}'); // Update selected title list
                                            });
                                          },
                                          items: <String>[
                                            'Mr.',
                                            'Miss.',
                                            'Ms.',
                                            'Mrs.'
                                          ].map<DropdownMenuItem<String>>(
                                            (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child:
                                                    Center(child: Text(value)),
                                              );
                                            },
                                          ).toList(),
                                        ),
                                      ),
                                      height: 55,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: AppColors.supportColor)),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Container(
                                      height: 55,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColors.supportColor),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return '   Enter First Name';
                                          }

                                          return null;
                                        },
                                        onChanged: (value) {
                                          firstNames2[index] = value;
                                          print(
                                              'first name ${index + 1} ${value}'); // Update first name list
                                        },
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(
                                              left: 10, bottom: 3),
                                          // isDense: true,
                                          border: InputBorder.none,
                                          hintText: 'Enter First Name',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Container(
                                height: 55,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: AppColors.supportColor),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return '   Enter Last Name';
                                    }

                                    return null;
                                  },
                                  onChanged: (value) {
                                    lastNames2[index] = value;
                                    print(
                                        'last name ${index} ${value}'); // Update last name list
                                  },
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.only(left: 10, bottom: 3),
                                    // isDense: true,
                                    border: InputBorder.none,
                                    hintText: 'Enter Last Name',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: AppColors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Contact Details :',
                            style: TextStyle(fontSize: 16, fontFamily: "rubic"),
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: 55,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: AppColors.supportColor),
                                borderRadius: BorderRadius.circular(10)),
                            child: TextFormField(
                              controller: emailController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return '    Please Enter Email';
                                } else if (!value.contains('@') ||
                                    !value.contains(".com")) {
                                  return '    Please Enter Valid Email';
                                }
                                return null; // Return null if the input is valid
                              },
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(left: 10, bottom: 3),
                                // isDense: true,
                                border: InputBorder.none,
                                hintText: '  Email',

                                // label: Text("  Email")
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: 55,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: AppColors.supportColor),
                                borderRadius: BorderRadius.circular(10)),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: mobileController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '     Enter Mobile Number';
                                } else if (value.length < 10 ||
                                    value.length > 10) {
                                  return '     Enter Valid Mobile Number';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.only(left: 10, bottom: 3),
                                  // isDense: true,
                                  border: InputBorder.none,
                                  hintText: '  Number'
                                  // label: Text('   Number'),
                                  // border: OutlineInputBorder(
                                  //   borderRadius: BorderRadius.circular(15),
                                  // ),
                                  ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text('Your tickets will be shared here'),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      _showGstDetailsBottomSheet(context);
                    },
                    child: Container(
                      height: 45,
                      child: Card(
                        elevation: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('ADD Gst Details (optional)'),
                              ),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  _showGstDetailsBottomSheet(context);
                                },
                              ),
                            ],
                          ),
                          // if()
                        ),
                      ),
                    ),
                  ),
                ),
                if (gstController.text.length > 0 ||
                    companyNameController.text.length > 0)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 5,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        width: double.infinity,
                        // height: 80,

                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "GST IN : ${gstController.text} ",
                                style: TextStyle(
                                    fontSize: 16, fontFamily: "rubic"),
                              ),
                              Text(
                                "Company Name : ${companyNameController.text} ",
                                style: TextStyle(
                                    fontSize: 16, fontFamily: "rubic"),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.black,
        ),
        child: BottomAppBar(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.blackTemp,
            ),
            // color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '  Total Amount:',
                  style: TextStyle(
                      color: Colors.white54, fontSize: 16, fontFamily: "rubic"),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Text(
                    widget.totalAmount ?? "0",
                    style: TextStyle(
                        color: Colors.white, fontSize: 16, fontFamily: "rubic"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 70,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: InkWell(
                      onTap: () {
                        //
                        if (_formKey.currentState!.validate()) {
                          _openBottomSheet1(context).then((value){
                            isLoading=false;
                            setState(() {

                            });
                          });
                        }
                      },
                      child: Center(
                        child: Text(
                          'Proceed',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontFamily: "rubic"),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool submit = false;
  TextEditingController gstController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();

  void _showGstDetailsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                // height: 350,
                child: Form(
                  key: _formKey1,
                  child: Column(
                    //  mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Please fill the details as per your GST registration ',
                        style: TextStyle(fontSize: 16, fontFamily: "rubic"),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: gstController,
                        validator: (value) {
                          if (value?.length != 15) {
                            // GST number should be exactly 15 characters long
                            return "Enter Valid GST Number";
                          }

                          // Check if the GST number contains both alphabetic and numeric characters
                          bool hasAlphabetic =
                              RegExp(r'[a-zA-Z]').hasMatch(value!);
                          bool hasDigits = RegExp(r'[0-9]').hasMatch(value!);

                          if (!hasAlphabetic || !hasDigits) {
                            return "Enter Valid GST Number";
                          }

                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'GST IN', // Changed label to labelText
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: companyNameController,
                        validator: (value) {
                          if (value!.length < 1) {
                            return "Please Enter Company Name";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Company Name',
                          // Changed label to labelText

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 50,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.red,
                              ),
                              child: Center(
                                  child: Text(
                                "Cancel",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "rubic",
                                    fontSize: 16),
                              )),
                            ),
                          ),
                          Container(
                            height: 50,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.red,
                            ),
                            child: InkWell(
                              onTap: () {
                                submit = true;
                                setState(() {});

                                if (_formKey1.currentState!.validate()) {
                                  Navigator.pop(context);
                                }
                              },
                              child: Center(
                                child: Center(
                                  child: Text(
                                    'Submit',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "rubic",
                                        fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
