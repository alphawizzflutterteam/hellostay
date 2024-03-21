import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hellostay/model/booking_details_model.dart';
import 'package:hellostay/model/booking_screen_model.dart';
// import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
//
import '../../constants/colors.dart';
import '../../repository/apiConstants.dart';

class BookingDetails extends StatefulWidget {
  final String booking_code;
  const BookingDetails({Key? key, required this.booking_code})
      : super(key: key);

  @override
  State<BookingDetails> createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<BookingDetails>
    with TickerProviderStateMixin {
  TabController? tabController;

  bool loading = false;

  BookingDetailsmodel? bookingDetailsmodel;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getHotelDetails();
    tabController = TabController(length: 4, vsync: this);
  }
  late DateTime startDate;
  getHotelDetails() async {
    setState(() {
      loading = true;
    });
    apiBaseHelper
        .getAPICall(Uri.parse('${baseUrl1}booking/${widget.booking_code}'))
        .then((getData) {
      setState(() {
        bookingDetailsmodel = BookingDetailsmodel.fromJson(getData);
        loading = false;

        print('CCCCCCCCCCCCCCCCCC${isCheckInValid()}');

        startDate =DateTime.parse(bookingDetailsmodel?.booking?.startDate ?? '');
      });
    });
  }

  bool isCheckInValid() {
    // Current date and time
    DateTime now = DateTime.now();

    // Check-in date
    DateTime checkInDate = DateTime.parse(bookingDetailsmodel?.booking?.startDate ?? '');

    // Check-in time
    String? checkInTimeString = "12:00PM";

    // Parse check-in time string
    List<String> timeParts = (checkInTimeString ?? '').split(':');
    int hour = int.tryParse(timeParts[0]) ?? 0;
    int minute = int.tryParse(timeParts[1]) ?? 0;
    TimeOfDay checkInTime = TimeOfDay(hour: hour, minute: minute);

    // Combine check-in date and time
    DateTime combinedCheckInDateTime = DateTime(checkInDate.year, checkInDate.month, checkInDate.day, checkInTime.hour, checkInTime.minute);

    // Calculate the difference in hours
    Duration difference = combinedCheckInDateTime.difference(now);
    int differenceInHours = difference.inHours;

    // If the difference is less than 72 hours, return false
    if (differenceInHours < 72) {
      return false;
    }

    // If the check-in date and time are 72 hours or more in the future, return true
    return true;
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
            'Booking Details',
            style: TextStyle(
                fontFamily: "rubic",
                fontSize: 20.0,
                color: AppColors.blackTemp),
          ),
        ),
      ),

      //body: hotelCard(),
      body: !loading
          ? Padding(padding: const EdgeInsets.all(8.0), child: bookingDetails())
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  bookingDetails() {
    return bookingDetailsmodel != null
        ? Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: Colors.grey.withOpacity(0.5),
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "B.ID-${bookingDetailsmodel?.booking?.id ?? ""}",
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: "rubic",
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: bookingDetailsmodel?.booking?.status ==
                                      "processing"
                                  ? Colors.orange
                                  : bookingDetailsmodel?.booking?.status ==
                                          "SUCCESS"
                                      ? Colors.green
                                      : AppColors.primary,
                            ),
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              "${bookingDetailsmodel?.booking?.status}",
                              style: TextStyle(
                                  color: AppColors.whiteTemp,
                                  fontFamily: "rubic"),
                            )),
                      ],
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${bookingDetailsmodel?.booking?.service?.title}",
                          style: Theme.of(context)
                              .primaryTextTheme
                              .titleLarge!
                              .copyWith(
                                  color: AppColors.blackTemp,
                                  fontSize: 16,
                                  fontFamily: "rubic",
                                  fontWeight: FontWeight.bold),
                        ),
                        IgnorePointer(
                          ignoring: true,
                          child: RatingBar.builder(
                            initialRating: bookingDetailsmodel
                                    ?.booking!.service?.starRate
                                    ?.toDouble() ??
                                0.0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemSize: 12.0,
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate:
                                (_) {}, // Provide an empty function to disable editing
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                                "${bookingDetailsmodel?.service?.address}",
                                style: TextStyle(
                                    fontSize: 11,
                                    fontFamily: "rubic",
                                    color: Colors.black54))),
                        IconButton(
                            onPressed: () async {
                              String mapLat = bookingDetailsmodel
                                      ?.booking?.service?.mapLat ??
                                  "";
                              String mapLng = bookingDetailsmodel
                                      ?.booking?.service?.mapLng ??
                                  "";

                              String googleUrl =
                                  'https://www.google.com/maps/search/?api=1&query=$mapLat,$mapLng';

                              //  String googleUrl = 'https://www.google.com/maps/search/?api=1&query=${}';
                              if (await canLaunch(googleUrl)) {
                                await launch(googleUrl);
                              } else {
                                throw 'Could not open the map.';
                              }
                            },
                            icon: const Icon(
                              Icons.location_on_outlined,
                              color: AppColors.primary,
                            )),
                      ],
                    ),
                    // const SizedBox(
                    //   height: 5,
                    // ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Check In",
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: AppColors.secondary,
                                        fontFamily: "rubic"),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: AppColors.faqanswerColor,
                                  ),
                                  child: Text(
                                    " ${DateFormat("dd MMM yyyy ").format(DateTime.parse(bookingDetailsmodel?.booking?.startDate ?? ''))} ",
                                    style: const TextStyle(
                                        color: AppColors.whiteTemp,
                                        fontFamily: "rubic"),
                                  )

                                  // Text(
                                  //   " ${bookingDetailsmodel?.booking?.startDate?.substring(0,11)} ",
                                  //   style: Theme
                                  //       .of(context)
                                  //       .primaryTextTheme
                                  //       .bodyLarge!
                                  //       .copyWith(color: AppColors.whiteTemp,fontSize: 15),
                                  // ),
                                  ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Check Out",
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: AppColors.secondary,
                                        fontFamily: "rubic"),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: AppColors.faqanswerColor,
                                  ),
                                  child: Text(
                                    " ${DateFormat("dd MMM yyyy ").format(DateTime.parse(bookingDetailsmodel?.booking?.endDate ?? ''))} ",
                                    style: const TextStyle(
                                        color: AppColors.whiteTemp,
                                        fontFamily: "rubic"),
                                  )

                                  // Text(
                                  //   " ${bookingDetailsmodel?.booking?.endDate?.substring(0,11)} ",
                                  //   style: Theme
                                  //       .of(context)
                                  //       .primaryTextTheme
                                  //       .bodyLarge!
                                  //       .copyWith(color: AppColors.whiteTemp,fontSize: 15),
                                  // ),
                                  ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Expanded(
                    //       flex: 1,
                    //       child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           Text(
                    //             "Check In Time",
                    //             style: Theme.of(context)
                    //                 .primaryTextTheme
                    //                 .bodyMedium!
                    //                 .copyWith(
                    //                     color: AppColors.secondary,
                    //                     fontFamily: "rubic"),
                    //           ),
                    //           const SizedBox(
                    //             height: 5,
                    //           ),
                    //           Container(
                    //             decoration: BoxDecoration(
                    //               borderRadius: BorderRadius.circular(5),
                    //               color: AppColors.faqanswerColor,
                    //             ),
                    //             child: Text(
                    //               " ${bookingDetailsmodel?.booking?.service?.checkInTime} ",
                    //               style: Theme.of(context)
                    //                   .primaryTextTheme
                    //                   .bodyLarge!
                    //                   .copyWith(
                    //                       color: AppColors.whiteTemp,
                    //                       fontSize: 15,
                    //                       fontFamily: "rubic"),
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //     Expanded(
                    //       flex: 1,
                    //       child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.end,
                    //         children: [
                    //           Text(
                    //             "Check Out Time",
                    //             style: Theme.of(context)
                    //                 .primaryTextTheme
                    //                 .bodyMedium!
                    //                 .copyWith(
                    //                     color: AppColors.secondary,
                    //                     fontFamily: "rubic"),
                    //           ),
                    //           const SizedBox(
                    //             height: 5,
                    //           ),
                    //           Container(
                    //             decoration: BoxDecoration(
                    //               borderRadius: BorderRadius.circular(5),
                    //               color: AppColors.faqanswerColor,
                    //             ),
                    //             child: Text(
                    //               " ${bookingDetailsmodel?.booking?.service?.checkOutTime} ",
                    //               style: Theme.of(context)
                    //                   .primaryTextTheme
                    //                   .bodyLarge!
                    //                   .copyWith(
                    //                       color: AppColors.whiteTemp,
                    //                       fontSize: 15,
                    //                       fontFamily: "rubic"),
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // const SizedBox(
                    //   height: 15,
                    // ),
                    Text(
                      "Room Info.",
                      style: Theme.of(context)
                          .primaryTextTheme
                          .titleLarge!
                          .copyWith(
                        fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: "rubic"),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Total Guests : ${bookingDetailsmodel?.booking?.totalGuests}",
                        style: Theme.of(context)
                            .primaryTextTheme
                            .bodyLarge!
                            .copyWith(
                              color: Colors.black54,
                              fontFamily: "rubic",
                              fontSize: 16,
                            ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Customer Details",
                      style: Theme.of(context)
                          .primaryTextTheme
                          .titleLarge!
                          .copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: "rubic"),
                    ),

                    Card(
                      color: AppColors.halfWhite,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Name  : ",
                                  style: TextStyle(
                                      color: AppColors.blackTemp,
                                      fontFamily: "rubic",
                                      fontSize: 16),
                                ),
                                Text(
                                    "${bookingDetailsmodel?.booking?.firstName} ${bookingDetailsmodel?.booking?.lastName}",
                                    style: TextStyle(
                                        color: AppColors.blackTemp,
                                        fontFamily: "rubic",
                                        fontSize: 16)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Mobile No.  : ",
                                    style:TextStyle(
                                        color: AppColors.blackTemp,
                                        fontFamily: "rubic",
                                        fontSize: 16)),
                                Text(
                                  "${bookingDetailsmodel?.booking?.phone}",
                                  style:TextStyle(
                                      color: AppColors.blackTemp,
                                      fontFamily: "rubic",
                                      fontSize: 16),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Email : ",
                                    style:TextStyle(
                                        color: AppColors.blackTemp,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                                Text(
                                  "${bookingDetailsmodel?.booking?.email}",
                                  style:TextStyle(
                                      color: AppColors.blackTemp,
                                      fontFamily: "rubic",
                                      fontSize: 16),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Address : ",
                                    style: TextStyle(
                                        color: AppColors.blackTemp,
                                        fontFamily: "rubic",
                                        fontSize: 16)),
                                Text(
                                  "${bookingDetailsmodel?.booking?.address},${bookingDetailsmodel?.booking?.city},${bookingDetailsmodel?.booking?.state},${bookingDetailsmodel?.booking?.country}",
                                  style:TextStyle(
                                      color: AppColors.blackTemp,
                                      fontFamily: "rubic",
                                      fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // const SizedBox(
                    //   height: 10,
                    // ),
                    // Text(
                    //   "Extra Service",
                    //   style:TextStyle(
                    //       color: AppColors.blackTemp,
                    //       fontFamily: "rubic",
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: 16),
                    // ),
                    //
                    // ListView.builder(
                    //   physics: NeverScrollableScrollPhysics(),
                    //   shrinkWrap: true,
                    //   itemCount: bookingDetailsmodel
                    //       ?.booking?.service?.extraPrice?.length,
                    //   itemBuilder: (context, index) {
                    //     return Card(
                    //       color: AppColors.halfWhite,
                    //       child: Padding(
                    //         padding: const EdgeInsets.all(8.0),
                    //         child: Column(
                    //           //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: [
                    //             Row(
                    //               children: [
                    //                 Text("Service Name : ",
                    //                     style: TextStyle(
                    //                         color: AppColors.blackTemp,
                    //                         fontFamily: "rubic",
                    //                         fontSize: 16)),
                    //                 Text(
                    //                   "${bookingDetailsmodel?.booking?.service!.extraPrice?[index].name}",
                    //                   style: TextStyle(
                    //                       color: AppColors.blackTemp,
                    //                       fontFamily: "rubic",
                    //                       fontSize: 16),
                    //                 ),
                    //               ],
                    //             ),
                    //             Row(
                    //               children: [
                    //                 Text("Price : ",
                    //                     style: TextStyle(
                    //                         color: AppColors.blackTemp,
                    //                         fontFamily: "rubic",
                    //                         fontSize: 16)),
                    //                 Text(
                    //                   "${bookingDetailsmodel?.booking?.service!.extraPrice?[index].price}",
                    //                   style: TextStyle(
                    //                       color: AppColors.blackTemp,
                    //                       fontFamily: "rubic",
                    //                       fontSize: 16),
                    //                 ),
                    //               ],
                    //             ),
                    //             Row(
                    //               children: [
                    //                 Text("Type: ",
                    //                     style: TextStyle(
                    //                         color: AppColors.blackTemp,
                    //                         fontFamily: "rubic",
                    //                         fontSize: 16)),
                    //                 Text(
                    //                   "${bookingDetailsmodel?.booking?.service!.extraPrice?[index].type}",
                    //                   style:TextStyle(
                    //                       color: AppColors.blackTemp,
                    //                       fontFamily: "rubic",
                    //                       fontSize: 16),
                    //                 ),
                    //               ],
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     );
                    //   },
                    // ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Payment Type : ",
                            style: TextStyle(
                                fontFamily: "rubic",
                                color: AppColors.blackTemp,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                        Text(
                          "${bookingDetailsmodel?.gateway?.name}",
                          style: TextStyle(
                              fontFamily: "rubic",
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ],
                    ),

                    const Divider(),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Amount :",
                          style: const TextStyle(
                            color: AppColors.blackTemp,
                            fontFamily: "rubic",
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                          ),
                        ),
                        Text(
                          "₹ ${bookingDetailsmodel?.booking?.total}",
                          style: TextStyle(
                              color: Colors.green,
                              fontFamily: "rubic",
                              fontWeight: FontWeight.bold,
                              fontSize: 16)
                        ),
                      ],
                    ),     Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Advance Payment :",
                          style: const TextStyle(
                            color: AppColors.blackTemp,
                            fontFamily: "rubic",
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                          ),
                        ),
                        Text(
                          "-₹ ${bookingDetailsmodel?.booking?.paid ?? "0.00"}",
                          style: TextStyle(
                              color: Colors.green,
                              fontFamily: "rubic",
                              fontWeight: FontWeight.bold,
                              fontSize: 16)
                        ),
                      ],
                    ),
                    const Divider(),
                     Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Pay At Hotel :",
                          style: const TextStyle(
                            color: AppColors.blackTemp,
                            fontFamily: "rubic",
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                          ),
                        ),
                        Text(
                          "₹ ${double.parse(bookingDetailsmodel?.booking?.total ?? "0.00")- double.parse(bookingDetailsmodel?.booking?.paid ?? "0.00")}",
                          style:TextStyle(color: Colors.red,fontFamily: "rubic",
                              fontWeight: FontWeight.bold,
                              fontSize: 16)

                        ),
                      ],
                    ),
                    const Divider(),

                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: Colors.blue.withOpacity(0.6),
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${DateFormat("dd MMM yyyy hh:mm a").format(DateTime.parse(bookingDetailsmodel?.booking?.createdAt ?? ''))}",
                          style: const TextStyle(
                            color: AppColors.whiteTemp,
                          ),
                        )),
                    const Divider(),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Policy : ",
                        style: TextStyle(
                            fontFamily: "rubic",
                            color: AppColors.blackTemp,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),

                    Container(
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: bookingDetailsmodel
                            ?.booking?.service?.policy?.length,
                        itemBuilder: (context, index) {
                          return Card(
                            color: AppColors.halfWhite,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      "${bookingDetailsmodel?.booking?.service!.policy?[index].title} ",
                                      style: TextStyle(
                                          fontFamily: "rubic",
                                          color: AppColors.blackTemp,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  Text(
                                    "${bookingDetailsmodel?.booking?.service!.policy?[index].content}",
                                    style:TextStyle(
                                        color: AppColors.faqanswerColor,
                                        fontFamily: "rubic",
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    bookingDetailsmodel?.booking?.status == 'cancelled' || DateTime.now().isAfter(startDate) || DateTime.now().isAtSameMomentAs(startDate)
                        ? const SizedBox()
                        : Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0,
                                right: 15.0,
                                bottom: 10.0,
                                top: 20.0),
                            child: InkWell(
                              onTap: () async {
                                /*for (int i = 0;
                      i <
                          int.parse(reviewRoomResponse
                                  ?.hInfo?.ops?.first.ris?.first.adt
                                  .toString() ??
                              '0');
                      i++) {
                    passenger.add(HotelPassengerModel(
                      type: "ADULT ${i + 1}",

                    ));
                  }*/


                                    if(isCheckInValid())
                                    {
                                      _showCustomDialog();
                                    }
                                    else{
                                      _cancelPolicy(context);

                                    }

                                // _showCustomDialog();
                              },
                              child: Container(
                                height: 55.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    color: AppColors.primary
                                    // gradient: LinearGradient(
                                    //     colors:  [
                                    //       Color(0xFF09314F),
                                    //       Color(0xFF09314F),
                                    //     ],
                                    //     begin: FractionalOffset(0.0, 0.0),
                                    //     end: FractionalOffset(1.0, 0.0),
                                    //     stops: [0.0, 1.0],
                                    //     tileMode: TileMode.clamp)
                                    ),
                                child: const Center(
                                  child: Text(
                                    'Cancel Booking',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        fontFamily: "rubic",
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                          ),
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: InkWell(
                    //         onTap: () {
                    //           setState(() {
                    //             downloadLoading = true;
                    //           });
                    //           downloadAndOpenFile(hotelList[i].code);
                    //         },
                    //         child: Container(
                    //           width: double.infinity,
                    //           decoration: BoxDecoration(
                    //             color: Colors.deepOrange,
                    //             borderRadius: BorderRadius.circular(5.0),
                    //           ),
                    //           padding: const EdgeInsets.all(15),
                    //           child: Center(
                    //             child: !downloadLoading ? const Text(
                    //               "Invoice",
                    //               style: TextStyle(
                    //                 fontWeight: FontWeight.w500,
                    //                 fontSize: 15.0,
                    //                 color: Colors.white,
                    //               ),
                    //             ) : const CircularProgressIndicator(),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     const SizedBox(width: 8,),
                    //     Expanded(
                    //       child: InkWell(
                    //         onTap: () {
                    //           // cancelDialog(hotelList[i].id.toString());
                    //         },
                    //         child: Container(
                    //           width: double.infinity,
                    //           decoration: BoxDecoration(
                    //             color: Colors.deepOrange,
                    //             borderRadius: BorderRadius.circular(5.0),
                    //           ),
                    //           padding: const EdgeInsets.all(15),
                    //           child: const Center(
                    //             child: Text(
                    //               "Cancel Booking",
                    //               style: TextStyle(
                    //                 fontWeight: FontWeight.w500,
                    //                 fontSize: 15.0,
                    //                 color: Colors.white,
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
          )
        : const Center(
            child: Text("No Hotel Booking Available"),
          );
  }

  final cancelReason = TextEditingController();

  void _showCustomDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String inputText = '';

        return AlertDialog(
          title: const Text(
            'Do you want to cancel this booking ?',
            style: TextStyle(fontFamily: "rubic"),
          ),
          content: TextFormField(
            controller: cancelReason,
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
                  child: const Text('No',style: TextStyle(color: AppColors.white,fontFamily: "rubic"),),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,),
                  onPressed: () {
                    // Do something with the inputText
                    // print('Input Text: $inputText');
                    cancelHotel('');
                    Navigator.of(context).pop();
                  },
                  child: Text('Yes',style: TextStyle(color: AppColors.white,fontFamily: "rubic"),),
                ),
              ],
            ),

          ],
        );
      },
    );
  }



  void _cancelPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String inputText = '';

        return AlertDialog(
          title: const Text(
            'Cancellation Policy',
            style: TextStyle(fontFamily: "rubic",fontSize: 18),
          ),
          content: Container(
            height: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               // Text("hotelbooking.alphawizzserver.com says",style: TextStyle(fontFamily: "rubic",fontSize: 14),),
                Text("Your booking amount is non-refundabale as per the cancellation Policy",style: TextStyle(fontFamily: "rubic",fontSize: 14,color: Colors.grey),),
                SizedBox(height: 5,),

              ],
            ),
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
                  onPressed: () {
                    _showCustomDialog();
                    // Do something with the inputText
                    // print('Input Text: $inputText');
                    // cancelHotel('');
                    // Navigator.of(context).pop();
                  },
                  child: Text('OK',style: TextStyle(color: AppColors.white,fontFamily: "rubic"),),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  final String fileUrl =
      'https://example.com/yourfile.pdf'; // Replace with your file URL
  bool downloadLoading = false;

  Future<void> downloadAndOpenFile(code) async {
    final Directory? tempDir = await getExternalStorageDirectory();
    String fileName = '$code.pdf'; // Replace with your desired file name
    String filePath = '${tempDir!.path}/$fileName';
    print(filePath);

    File file = File(filePath);
    if (false /*file.existsSync()*/) {
      setState(() {
        downloadLoading = false;
      });
      //  OpenFile.open(filePath);
    } else {
      final response = await http.get(
        Uri.parse("${baseUrl}booking/$code/invoice"),
      );
      print(Uri.parse("${baseUrl}booking/$code/invoice"));
      print(response.statusCode);
      //print(response.body);
      Map data = jsonDecode(response.body);
      String? fileUrl = data['invoice_url'];

      print("========get api ${fileUrl}");
      if (fileUrl == "" || fileUrl == null) {
        fileUrl = "https://www.africau.edu/images/default/sample.pdf";
      }
      if (fileUrl != "") {
        print("==not null imageurl=====${fileUrl}");
        final response = await http.get(Uri.parse(fileUrl));
        print(response.statusCode);
        //print(response.body);
        if (response.statusCode == 200) {
          // Save the file locally
          final Uint8List bytes = response.bodyBytes;
          print(filePath);

          File file = await File(filePath).writeAsBytes(bytes);
          if (file.existsSync()) {
            setState(() {
              downloadLoading = false;
            });
          }
          // Open the file
          // OpenFile.open(filePath).then((value) {
          //
          // }).onError((error, stackTrace){
          //   print(error);
          // });
        } else {
          setState(() {
            downloadLoading = false;
          });
          //  Common().toast("Failed to download file");
          throw Exception('Failed to download file');
        }
        {
          print("==null imageurl=====${fileUrl}");

          setState(() {
            downloadLoading = false;
          });
          //  Common().toast("Failed to download file");
        }
      }
    }
    getDays(int? duration) {
      if (duration != null) {
        int days = duration ~/ 24;
        int hour = duration % 24;
        return "${days}d ${hour}h";
      }
      return "Not Available";
    }

    showCancelBottom(dynamic model) {
      showModalBottomSheet(
          context: context,
          builder: (context) => Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Cancel Booking Details",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          fontSize: 14.0),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: model.bookinDeatils!.itinerary!.cancelPolicy!
                          .map((e) {
                        int index = model
                            .bookinDeatils!.itinerary!.cancelPolicy!
                            .indexWhere((element) =>
                                element.cancellationCharge ==
                                e.cancellationCharge);

                        return ListTile(
                          leading: Text(
                            "₹${e.cancellationCharge}",
                            style: const TextStyle(
                              fontFamily: 'open-sans',
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.0,
                            ),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 4),
                          horizontalTitleGap: 1,
                          title: Text(
                            "${e.fromDate}-${e.toDate}",
                            style: const TextStyle(
                              fontFamily: 'open-sans',
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.0,
                            ),
                          ),
                          subtitle: Text(
                            "${e.policyString}",
                            style: const TextStyle(
                              fontFamily: 'open-sans',
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.0,
                            ),
                          ),
                          trailing: Text(
                            "₹${e.cancellationCharge}",
                            style: const TextStyle(
                              fontFamily: 'open-sans',
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.0,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.deepOrange,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            padding: const EdgeInsets.all(15),
                            child: const Center(
                              child: Text(
                                "Back",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        )),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            // cancelDialog(model.id.toString());
                          },
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.deepOrange,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            padding: const EdgeInsets.all(15),
                            child: const Center(
                              child: Text(
                                "Continue",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        )),
                      ],
                    ),
                  ],
                ),
              ));
    }

    cancelDialog(String id) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Cancel Booking"),
              content: const Text("do you want to proceed?"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("No")),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // cancelBooking(id);
                    },
                    child: const Text("Yes")),
              ],
            );
          });
    }

    //AllBookingListModel? allBookingListModel;
    List<dynamic> hotelList = [];

    bool loading = false;
    cancelBooking(String id) async {
      // setState(() {
      //   loading = true;
      // });
      // var headers = {
      //   'Authorization': 'Bearer ${App.localStorage.getString("token")}'
      // };
      // debugPrint("${baseUrl1}user/cancel-booking/$id");
      // var response = await http.get(Uri.parse("${baseUrl}user/cancel-booking/$id"),headers: headers);
      // debugPrint(response.body);
      // Map data = jsonDecode(response.body);
      // if(data['status']){
      //   Fluttertoast.showToast(msg: data['message'].toString());
      // }
      // getBookingList();
    }
    getBookingList() async {
      // SharedPreferences preferences = await SharedPreferences.getInstance();
      // String? userId = preferences.getString('userId');
      // print("getEventUserId--------------->${userId}");
      // setState(() {
      //   loading = true;
      // });
      // var headers = {
      //   'Authorization': 'Bearer ${App.localStorage.getString("token")}'
      // };
      // var request = http.MultipartRequest('POST', Uri.parse('${baseUrl}booking/get-bookings'));
      // request.fields.addAll({
      //   'user_id': '${App.localStorage.getString("userId")}'
      // });
      // //print('__________${}_________');
      // request.headers.addAll(headers);
      // http.StreamedResponse response = await request.send();
      // setState(() {
      //   loading = false;
      //   hotelList.clear();
      //   tourList.clear();
      //   busList.clear();
      //   flightList.clear();
      // });
      // if (response.statusCode == 200) {
      //   var result =  await response.stream.bytesToString();
      //   Map data = json.decode(result);
      //   setState(() {
      //     if(data['bookings']!=null){
      //       print('______ssss____${result}_________');
      //       if(data['bookings']['hotel']!=null){
      //         for(var v in data['bookings']['hotel']){
      //           hotelList.add(HotelBookModel.fromJson(v));
      //         }
      //       }
      //       if(data['bookings']['tour']!=null){
      //         for(var v in data['bookings']['tour']){
      //           tourList.add(TourBookModel.fromJson(v));
      //         }
      //       }
      //       if(data['bookings']['car']!=null){
      //         for(var v in data['bookings']['car']){
      //           busList.add(BusBookModel.fromJson(v));
      //         }
      //       }
      //       if(data['bookings']['flight']!=null){
      //         for(var v in data['bookings']['flight']){
      //           flightList.add(FlightBookModel.fromJson(v));
      //         }
      //       }
      //
      //     }else{
      //       Common().toast("No Booking Available");
      //     }
      //   });
      //
      //  }
      // else {
      //   print(response.reasonPhrase);
      // }
    }
  }

  cancelHotel(String code) async {
    var parms = {'cancel_reason': cancelReason.text};

    apiBaseHelper
        .postAPICall(
            Uri.parse('${baseUrl1}booking/${widget.booking_code}/cancel'),
            parms)
        .then((getData) {
      var status = getData['status'];
      var msg = getData['message'];
      if (status.toString() == '1') {
        Fluttertoast.showToast(msg: msg);
        Navigator.pop(context, true);
      }
    });
  }
}
