import 'dart:convert';
import 'dart:math';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hellostay/constants/colors.dart';
import 'package:hellostay/model/coupon_model.dart';
import 'package:hellostay/model/hotel_detail_response.dart';
import 'package:hellostay/repository/apiConstants.dart';
import 'package:hellostay/screens/Hotel/homeView.dart';
import 'package:hellostay/screens/Hotel/trveller_information.dart';
import 'package:hellostay/utils/globle.dart';
import 'package:hellostay/utils/traver_tile.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

import '../../model/checkout_model.dart';
import '../../widgets/custom_image.dart';

// import 'Traveller.dart';

class BookNowDetails extends StatefulWidget {
  String? title;
  String? imageUrl;
  String? bookingId;
  Room? rooms;

  BookNowDetails(
      {Key? key, this.title, this.imageUrl, this.bookingId, this.rooms})
      : super(key: key);

  @override
  State<BookNowDetails> createState() => _BookNowDetailsState();
}

class _BookNowDetailsState extends State<BookNowDetails> {
  bool isExpanded = false;
  String selectedOption = '';
  String selectedOptionCurrent = '';
  String formattedCheckInDate = '';
  String formattedCheckOutDate = '';
  CouponModel? couponModel;
  String coupanStatus = '0';
  String couponNotApply = '';
  String couponMessage = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCheckOutApi();
    print(widget.rooms.toString());
    print("room---------");
    formattedCheckInDate =
        DateFormat("dd MMM''yy").format(DateTime.parse(checkInDate));
    formattedCheckOutDate =
        DateFormat("dd MMM''yy").format(DateTime.parse(checkOutDate));
    getCouponApi();
  }

  CheckoutModel? checkoutModel;
bool isLoading=false;
  Future<void> getCheckOutApi() async {
    isLoading=true;
    setState(() {

    });
    var request = http.Request(
        'GET',
        Uri.parse(
            '${baseUrl1}booking/${widget.bookingId}/checkout?token=${authToken}'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      // print("checkout api-----");
      var finaResult = jsonDecode(result);
      // print("cccc-----");
      //  print(await response.stream.bytesToString());
      checkoutModel = CheckoutModel.fromJson(finaResult);
      print("--------cccccccccc---------");
      isLoading=false;
      setState(() {

      });
      print(request.url);
    } else {
      print(response.reasonPhrase);
      isLoading=false;
      setState(() {

      });
    }
  }

  getCouponApi() async {
    var request = http.Request('GET', Uri.parse('${baseUrl1}coupons'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      print("kkk");
      var finaResult = jsonDecode(result);
      print("cccc");
      //  print(await response.stream.bytesToString());
      setState(() {
        couponModel = CouponModel.fromJson(finaResult);

        print("--------pppp---------");
        //   print(homeBannerModel?.data?.length);
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  couponApply() async {
    print('booking id---${widget.bookingId}');
    var request = http.MultipartRequest(
        'POST', Uri.parse('${baseUrl1}${widget.bookingId}/apply-coupon'));
    request.fields.addAll({'coupon_code': selectedOption ?? ""});

    http.StreamedResponse response = await request.send();
    print(request.url);
    print('coupon_code${selectedOption}');

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var finalReslut = jsonDecode(result);
      String applyCoupon = finalReslut['status'].toString();
      couponNotApply = applyCoupon;
      couponMessage = finalReslut['message'].toString();
      setState(() {});
      print("coupon--------");
      print(couponNotApply);
      print(couponMessage);

      print(applyCoupon);
      if (applyCoupon == '1') {
        print("coupon-apply-api------------");
        coupanStatus = applyCoupon;
        // selectedOption=selectedOption;
        setState(
          () {},
        );
        await getCheckOutApi().then((value) {
          _showCouponAppliedDialog();
        });

        //
        // setState(
        //   () {},
        // );
      }
      // setState(() {
      //
      // });

      // print(await response.stream.bytesToString());

      // print(response);
    } else {
      Fluttertoast.showToast(msg: couponMessage);
      print("not apply coupan");
      print(response.reasonPhrase);
    }
  }

  Future<void> couponRemove() async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('${baseUrl1}${widget.bookingId}/remove-coupon'));
    request.fields.addAll({'coupon_code': selectedOption ?? ""});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var finalReslut = jsonDecode(result);
      String couponRemove = finalReslut['status'].toString();

      print('__________________tanmay');
      if (couponRemove == '1') {
        selectedOption = "";
        coupanStatus = '0';
        // print(await response.stream.bytesToString());
        print("coupon-remove-api------------");
        setState(() {
          getCheckOutApi().then((value) {
            couponApply();
          });
        });
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  void _showCouponAppliedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              content: Lottie.asset(
                'assets/animation/bb.json',
                height: 100, // Adjust the height of the animation
                width: 100, // Adjust the width of the animation
                fit: BoxFit.contain,
              ),
              actions: [
                Center(
                  child: Column(
                    children: [
                      const Text(
                        'Coupon applied successfully.',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'You Saved ${checkoutModel?.booking?.couponAmount ?? ""}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
              elevation: 5,
            );
          },
        );
      },
    );
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
            'Hotel Booking',
            style: TextStyle(
                fontFamily: "rubic",
                fontSize: 20.0,
                color: AppColors.blackTemp),
          ),
        ),
      ),
      body: isLoading ?  Center(child: CircularProgressIndicator()) :  Container(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomImage(
                          widget.rooms?.image ?? "",
                          // width: double.infinity,
                          isNetwork: true,
                          height: 200,
                          width: double.infinity,
                          radius: 10,
                        ),
                        // Image.network(
                        //   'https://cdn.britannica.com/96/115096-050-5AFDAF5D/Bellagio-Hotel-Casino-Las-Vegas.jpg',
                        //   height: 200,
                        //   width: double.infinity,
                        //   fit: BoxFit.cover,
                        // ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            checkoutModel?.service?.title ?? "",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: "rubic",
                            ),
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: Text(
                        //     'MMA Rd, Friends Colony West, New Friends Colony....',
                        //   ),
                        // ),

                        //  SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              child: TextButton(
                                onPressed: () {},
                                child: Column(
                                  children: [
                                    const Text(
                                      'Check-In ',
                                      style: TextStyle(
                                          fontSize: 13, fontFamily: "rubic"),
                                    ),
                                    Text(
                                      formattedCheckInDate,
                                      style: const TextStyle(
                                          fontSize: 16, fontFamily: "rubic"),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Column(
                              children: [
                                Icon(Icons.nights_stay_sharp),
                                SizedBox(height: 5),
                                // Text(
                                //   'Remaining nights:',
                                //   style: TextStyle(fontSize: 10),
                                // ),
                                // Text('')
                              ],
                            ),
                            Container(
                              child: TextButton(
                                onPressed: () {},
                                child: Column(
                                  children: [
                                    const Text(
                                      'check-out',
                                      style: TextStyle(
                                          fontSize: 13, fontFamily: "rubic"),
                                    ),
                                    Text(
                                      formattedCheckOutDate,
                                      style: const TextStyle(
                                          fontSize: 16, fontFamily: "rubic"),
                                    ),
                                    // Text(
                                    //   '12:00 PM',
                                    //   style: TextStyle(fontSize: 13),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Divider(color: AppColors.blackTemp),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            widget.rooms?.title ?? "",
                            style: const TextStyle(
                                fontSize: 16,
                                fontFamily: "rubic",
                                color: Colors.black54),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                '${room.toString()} room   ',
                                style: const TextStyle(
                                    fontFamily: "rubic", fontSize: 16
                                    //color: Colors.black54
                                    ),
                              ),
                              Text(
                                '${childrenCount1 + adultCount1} guest',
                                style: const TextStyle(
                                    fontFamily: "rubic", fontSize: 16
                                    //color: Colors.black54
                                    ),
                              )

                              //  Text('1 room, 3 Guests'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Promo Code',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                fontFamily: "rubic"),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: AppColors.blackTemp)),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      labelText: '  Code: ${selectedOption}',

                                      labelStyle: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: 16,
                                          fontFamily: "rubic"),
                                      // border: OutlineInputBorder(
                                      //   borderRadius: BorderRadius.circular(15),
                                      // ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                if (coupanStatus == '0')
                                  TextButton(
                                    onPressed: () {
                                      couponApply();
                                      // Add onPressed logic for applying promo code
                                    },
                                    child: const Text(
                                      'APPLY',
                                      style: TextStyle(
                                          color: Colors.lightBlue,
                                          fontSize: 16,
                                          fontFamily: "rubic",
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                if (coupanStatus == '1')
                                  TextButton(
                                    onPressed: () {
                                      couponRemove();
                                      // couponApply();
                                      // Add onPressed logic for applying promo code
                                    },
                                    child: const Text(
                                      'Remove',
                                      style: TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 16,
                                          fontFamily: "rubic",
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                        if (coupanStatus == '1')
                          const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              "Coupon Apply Successfully.",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontFamily: "rubic",
                                  fontSize: 16),
                            ),
                          ),
                        if (couponNotApply == '0')
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              "${couponMessage}",
                              style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "rubic"),
                            ),
                          ),
                        const SizedBox(height: 15),
                        const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            '     Choose from below offers',
                            style: TextStyle(
                                color: Colors.black54,
                                fontFamily: "rubic",
                                fontSize: 16),
                          ),
                        ),
// Assuming this part is within your widget build method
                        Column(
                          children: [
                            Column(
                              children: List.generate(
                                // Only show the first two items initially, and then all items when expanded
                                isExpanded
                                    ? couponModel?.data?.length ?? 0
                                    : min(2, couponModel?.data?.length ?? 0),
                                (index) => RadioListTile(
                                  activeColor: Colors.blue,
                                  // selectedTileColor: Colors.blue,
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Assuming you want to show coupon details
                                      Row(
                                        children: [
                                          DottedBorder(
                                            child: Text(
                                              ' ${couponModel?.data?[index].code ?? "0"}',
                                              style: const TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 14,
                                                  fontFamily: "rubic"),
                                            ),
                                            color: Colors.blue,
                                          ),
                                          const SizedBox(width: 10),
                                          const Text(
                                            'Save',
                                            style: TextStyle(
                                                color: Colors.amber,
                                                fontFamily: "rubic"),
                                          ),
                                          // Icon(
                                          //   Icons.currency_rupee,
                                          //   color: Colors.amber,
                                          //   size: 15,
                                          // ),
                                          if (couponModel
                                                  ?.data?[index].discountType ==
                                              "fixed")
                                            Text(
                                              ' ₹ ${couponModel?.data?[index].amount ?? "0"}',
                                              style: const TextStyle(
                                                  color: Colors.amber,
                                                  fontFamily: "rubic",
                                                  fontSize: 16),
                                            ),
                                          if (couponModel
                                                  ?.data?[index].discountType ==
                                              "percent")
                                            Text(
                                              ' ${couponModel?.data?[index].amount ?? "0"}%',
                                              style: const TextStyle(
                                                  color: Colors.amber,
                                                  fontFamily: "rubic",
                                                  fontSize: 16),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  value:
                                      '${couponModel?.data?[index].code ?? "0"}',
                                  groupValue: selectedOption,
                                  onChanged: (value) async {
                                    if (coupanStatus == '1') {
                                      print("apply--123---");
                                      // selectedOptionCurrent=value.toString();
                                      await couponRemove();
                                      selectedOption = value.toString();
                                      setState(() {});
                                      couponApply();
                                      // setState(() {
                                      //
                                      // });
                                    } else {
                                      print("elase--------");
                                      //selectedOptionCurrent= value.toString();
                                      selectedOption = value.toString();
                                      setState(() {});
                                      couponApply();
                                    }
                                    setState(() {});
                                    // selectedOptionCurrent= selectedOption;
                                    // selectedOption = value.toString();
                                    // setState(() {
                                    //
                                    // });
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 200),
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    isExpanded = !isExpanded;
                                  });
                                },
                                child: Text(
                                  isExpanded ? 'View Less' : 'View More ',
                                  style: const TextStyle(color: Colors.blue),
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // const SizedBox(
                            //   height: 5,
                            // ),
                            Text(
                              "Tariff Details",
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontFamily: "rubic",
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Hotel Charges :",
                                  style: const TextStyle(
                                      fontSize: 16, fontFamily: "rubic"),
                                ),
                                Text(
                                  "₹${checkoutModel?.booking?.totalBeforeDiscount ?? ""}",
                                  style: const TextStyle(
                                      fontSize: 16, fontFamily: "rubic"),
                                ),
                              ],
                            ),
                            // const SizedBox(
                            //   height: 5,
                            // ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Coupon Amount:",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: AppColors.blackTemp,
                                      fontFamily: "rubic"),
                                ),
                                Text(
                                  "-₹${checkoutModel?.booking?.couponAmount ?? ""}",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: AppColors.blackTemp,
                                      fontFamily: "rubic"),
                                ),
                              ],
                            ),
                            Divider(),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Sub Total:",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: AppColors.blackTemp,
                                      fontFamily: "rubic"),
                                ),
                                Text(
                                  "₹${checkoutModel?.booking?.totalBeforeFees ?? ""}",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: AppColors.blackTemp,
                                      fontFamily: "rubic"),
                                ),
                              ],
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Convenience Fees & Taxes :",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: AppColors.blackTemp,
                                    fontFamily: "rubic",
                                  ),
                                ),
                                Text(
                                  "₹${(double.parse(checkoutModel?.booking?.total ?? "0.0") - double.parse(checkoutModel?.booking?.totalBeforeFees ?? "0.0")).toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: AppColors.blackTemp,
                                    fontFamily: "rubic",
                                  ),
                                ),
                              ],
                            ),
                            Divider(),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "You Pay :",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontFamily: "rubic",
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "₹${checkoutModel?.booking?.total ?? ""}",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontFamily: "rubic",
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )

                      // Column(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     Padding(
                      //       padding: const EdgeInsets.all(8.0),
                      //       child: Text('Tariff Details',style: TextStyle(fontSize: 20),),
                      //     ),
                      //     SizedBox(height: 10),
                      //     Padding(
                      //       padding: const EdgeInsets.all(8.0),
                      //       child: Divider(color: Colors.black26,),
                      //     ),
                      //     Row(
                      //       children: [
                      //         Padding(
                      //           padding: const EdgeInsets.all(8.0),
                      //           child: Text('Hotel Charges'),
                      //         ),
                      //         SizedBox(width: MediaQuery.of(context).size.width * 0.25),
                      //
                      //         Padding(
                      //           padding: const EdgeInsets.only(left: 40),
                      //           child: Row(
                      //             children: [
                      //               Icon(Icons.currency_rupee,size: 15),
                      //               Text('1,38,332')
                      //             ],
                      //           ),
                      //         )
                      //
                      //       ],
                      //     ),
                      //     SizedBox(height: 20,),
                      //     Row(
                      //       children: [
                      //         Padding(
                      //           padding: const EdgeInsets.all(8.0),
                      //           child: Text('Discounts'),
                      //         ),
                      //         SizedBox(width: MediaQuery.of(context).size.width * 0.38),
                      //
                      //         Padding(
                      //           padding: const EdgeInsets.only(left: 24),
                      //           child: Row(
                      //             children: [
                      //               Icon(Icons.currency_rupee,size: 15),
                      //               Text('1,38,332')
                      //             ],
                      //           ),
                      //         )
                      //
                      //       ],
                      //     ),
                      //     SizedBox(height: 10),
                      //     Padding(
                      //       padding: const EdgeInsets.all(8.0),
                      //       child: Divider(color: Colors.black26),
                      //     ),
                      //     SizedBox(height: 15),
                      //     Row(
                      //       children: [
                      //         Padding(
                      //           padding: const EdgeInsets.all(8.0),
                      //           child: Text('Hotel Charges'),
                      //         ),
                      //         SizedBox(width: MediaQuery.of(context).size.width * 0.25),
                      //
                      //         Padding(
                      //           padding: const EdgeInsets.only(left: 40),
                      //           child: Row(
                      //             children: [
                      //               Icon(Icons.currency_rupee,size: 15),
                      //               Text('1,38,332')
                      //             ],
                      //           ),
                      //         )
                      //       ],
                      //     ),
                      //     Row(
                      //       children: [
                      //         Padding(
                      //           padding: const EdgeInsets.all(8.0),
                      //           child: Text('Discounts'),
                      //         ),
                      //         SizedBox(width: MediaQuery.of(context).size.width * 0.38),
                      //         Padding(
                      //           padding: const EdgeInsets.only(left: 25),
                      //           child: Row(
                      //             children: [
                      //               Icon(Icons.currency_rupee,size: 15),
                      //               Text('1,38,332')
                      //             ],
                      //           ),
                      //         )
                      //       ],
                      //     ),
                      //     Row(
                      //       children: [
                      //         Padding(
                      //           padding: const EdgeInsets.all(8.0),
                      //           child: Text('Convenience Fees & Taxes'),
                      //         ),
                      //         SizedBox(width: MediaQuery.of(context).size.width * 0.18),
                      //         Padding(
                      //           padding: const EdgeInsets.only(),
                      //           child: Row(
                      //             children: [
                      //               Icon(Icons.currency_rupee,size: 15),
                      //               Text('1000')
                      //             ],
                      //           ),
                      //         )
                      //       ],
                      //     ),
                      //     SizedBox(height: 10),
                      //     Padding(
                      //       padding: const EdgeInsets.all(8.0),
                      //       child: Divider(color: Colors.black26),
                      //     ),
                      //     Row(
                      //       children: [
                      //         Padding(
                      //           padding: const EdgeInsets.all(8.0),
                      //           child: Text('You Pay'),
                      //         ),
                      //         SizedBox(width: MediaQuery.of(context).size.width * 0.33),
                      //         Padding(
                      //           padding: const EdgeInsets.only(left: 55),
                      //           child: Row(
                      //             children: [
                      //               Icon(Icons.currency_rupee,size: 15),
                      //               Text('1,38,332')
                      //             ],
                      //           ),
                      //         )
                      //       ],
                      //     ),
                      //     Padding(
                      //       padding: const EdgeInsets.all(8.0),
                      //       child: Divider(color: Colors.black26),
                      //     ),
                      //     Row(
                      //       children: [
                      //         Padding(
                      //           padding: const EdgeInsets.all(8.0),
                      //           child: Text('You earn'),
                      //         ),
                      //         SizedBox(width: MediaQuery.of(context).size.width * 0.34),
                      //         Padding(
                      //           padding: const EdgeInsets.only(left: 50),
                      //           child: Row(
                      //             children: [
                      //               Icon(Icons.currency_rupee,size: 15),
                      //               Text('1500'),
                      //
                      //             ],
                      //           ),
                      //         )
                      //
                      //       ],
                      //     ),
                      //   ],
                      // ),
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar:isLoading ?  SizedBox() :  Container(
        height: 80,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: Colors.black),
        child: BottomAppBar(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.blackTemp,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // SizedBox(width: 2,),
                Text(
                  '  Total Amount : ',
                  style: TextStyle(
                      color: AppColors.whiteTemp.withOpacity(.6),
                      fontWeight: FontWeight.bold,
                      fontFamily: "rubic",
                      fontSize: 16),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Text(
                    checkoutModel?.booking?.total ?? "",
                    style: const TextStyle(
                        color: AppColors.whiteTemp,
                        fontFamily: "rubic",
                        fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 70,
                    //width: 80,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10)),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TravellerInformation(
                                  totalAmount:
                                      checkoutModel?.booking?.total ?? "0",
                                  bookingId: widget.bookingId,
                                  couponCode: selectedOption),
                            ));
                      },
                      child: const Center(
                          child: Text(
                        '  Proceed  ',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
