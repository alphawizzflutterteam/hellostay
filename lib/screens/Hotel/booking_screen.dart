import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hellostay/model/booking_screen_model.dart';
import 'package:hellostay/repository/apiStrings.dart';
import 'package:hellostay/utils/globle.dart';

// import 'package:get/get.dart';
import 'package:intl/intl.dart';

// import 'package:open_file/open_file.dart';
// import 'package:parry_trip2/Library/rattings.dart';
import 'package:http/http.dart' as http;

// import 'package:parry_trip2/constants/common.dart';
// import 'package:parry_trip2/constants/constant.dart';
// import 'package:parry_trip2/model/bus_model/bus_book_model.dart';
// import 'package:parry_trip2/model/fare_rule_model.dart';
// import 'package:parry_trip2/model/hotel_book_model.dart';
// import 'package:parry_trip2/model/tour/flight_book_model.dart';
// import 'package:parry_trip2/model/tour/tour_book_model.dart';
// import 'package:parry_trip2/screens/BookingScreen/bus_booking_detail.dart';
// import 'package:parry_trip2/screens/BookingScreen/flight_booking_detail_.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

// import 'package:url_launcher/url_launcher.dart';
//
// import '../../constants/app_AppColors.dart';
import '../../constants/colors.dart';

// import '../../model/All_booking_list_model.dart';
import '../../repository/apiConstants.dart';
import '../loginScreen.dart';
import 'booking_details.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({Key? key}) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen>
    with TickerProviderStateMixin {
  TabController? tabController;

  bool loading = false;

  List<BookingData> hotelList = [];
  BookingScreenModel? bookingScreenModel;
  String formattedDate = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin();
    getBookingApi();
    tabController = TabController(length: 4, vsync: this);
    // getBookingList();
  }

  bool isCheckInLessThan72Hours(String checkInDateString) {
    // Current date and time
    DateTime currentDateTime = DateTime.now();

    // Parse the provided check-in date string into a DateTime object
    DateTime providedCheckInDate =
        DateFormat("dd MMM yyyy").parse(checkInDateString);

    // Set the time for the check-in date to 12:00 PM
    providedCheckInDate = DateTime(providedCheckInDate.year,
        providedCheckInDate.month, providedCheckInDate.day, 12, 0);

    // Calculate the time difference in hours
    Duration timeDifference = providedCheckInDate.difference(currentDateTime);
    double timeDifferenceInHours = timeDifference.inHours.toDouble();

    // Check if the time difference is less than 72 hours (3 days)
    return timeDifferenceInHours < 72;
  }

  int _currentIndex = 1;
  var token;
  Future<void> checkLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('userToken');
    print("===my technic==token =====${token}===============");
    setState(() {});
    if (token == null)
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  getBookingApi() async {
    setState(() {
      loading = true;
    });
    apiBaseHelper.getAPICall(getBookingApiUrl).then((value) {
      print('${getBookingApiUrl}');
      print(authToken);
      print("booking list-----------");
      var status = value['status'].toString();
      if (status == '1') {
        bookingScreenModel = BookingScreenModel.fromJson(value);
        hotelList = bookingScreenModel?.data ?? [];
        setState(() {
          loading = false;

          // print('date ----------${hotelList[0].startDate ?? ' '}');
          //print('date ----------${hotelList[0]. ?? ' '}');
        });
      } else {
        setState(() {});
      }
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
            'Booking List',
            style: TextStyle(
                fontFamily: "rubic",
                fontSize: 20.0,
                color: AppColors.blackTemp),
          ),
        ),
        // bottom: TabBar(
        //   controller: tabController,
        //   indicator: BoxDecoration(
        //       color: Colors.green[300],
        //       borderRadius: BorderRadius.circular(25.0)
        //   ),
        //   onTap: (index) {
        //     setState(() {
        //       tabController!.index = index;
        //     });
        //   },
        //   labelColor: AppColors.white,
        //   unselectedLabelColor: AppColors.blackTemp,
        //   tabs: const [
        //     Tab(text: 'Hotel',),
        //     Tab(text: 'Flight',),
        //     Tab(text: 'Bus',),
        //     Tab(text: 'Tour',)
        //   ],
        // ),
      ),

      // body: hotelCard(),
      body: !loading
          ? Padding(padding: const EdgeInsets.all(8.0), child: hotelCard()
              // tabController!.index == 0 ? hotelCard() : tabController!.index ==
              //     1 ? flightCard() : tabController!.index == 3
              //     ? tourCard()
              //     : busCard(),
              )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  dynamic rules;

  hotelCard() {
    return hotelList.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: hotelList.length,
            itemBuilder: (context, i) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BookingDetails(
                                  booking_code: hotelList[i].code ?? "")))
                      .then((value) {
                    if (value != null) {
                      getBookingApi();
                    }
                  });
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
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
                                    "B.ID-${hotelList[i].id}",
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "rubic"),
                                  )),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: hotelList[i].status == "PENDING"
                                      ? Colors.orange
                                      : hotelList[i].status == "SUCCESS"
                                          ? Colors.green
                                          : hotelList[i].status == "processing"
                                              ? Colors.orange
                                              : AppColors.primary,
                                ),
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  "${hotelList[i].status}",
                                  style: TextStyle(
                                      fontFamily: "rubic",
                                      color: AppColors.whiteTemp),
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
                              "${hotelList[i].service?.title}",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .titleLarge!
                                  .copyWith(
                                      color: AppColors.blackTemp,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "rubic"),
                            ),
                            InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => BookingDetails(
                                              booking_code: hotelList[i].code ??
                                                  ""))).then((value) {
                                    if (value != null) {
                                      getBookingApi();
                                    }
                                  });
                                },
                                child: const Text(
                                  "Details",
                                  style: TextStyle(
                                      color: AppColors.secondary,
                                      fontSize: 16,
                                      fontFamily: "rubic"),
                                ))
                          ],
                        ),
                        // const SizedBox(height: 4,),
                        // Row(
                        //   children: [
                        //     const Expanded(child: Text("Indore",style: TextStyle(fontSize: 18,fontFamily: "rubic"))),
                        //     IconButton(onPressed: () async {
                        //
                        //
                        //       String googleUrl = 'https://www.google.com/maps/search/?api=1&query=,}';
                        //       if (await canLaunch(googleUrl)) {
                        //         await launch(googleUrl);
                        //       } else {
                        //         throw 'Could not open the map.';
                        //       }
                        //     }, icon: const Icon(Icons.location_on_outlined,color: AppColors.primary,)),
                        //   ],
                        // ),
                        const SizedBox(
                          height: 8,
                        ),

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
                                        " ${DateFormat("dd MMM yyyy ").format(DateTime.parse(hotelList[i].startDate ?? ''))} ",
                                        style: const TextStyle(
                                            color: AppColors.whiteTemp,
                                            fontFamily: "rubic"),
                                      )

                                      // Text(
                                      //   " ${hotelList[i].startDate?.substring(0,11)} ",
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
                                        " ${DateFormat("dd MMM yyyy ").format(DateTime.parse(hotelList[i].endDate ?? ''))} ",
                                        style: const TextStyle(
                                            color: AppColors.whiteTemp,
                                            fontFamily: "rubic"),
                                      )

                                      // Text(
                                      //   " ${hotelList[i].endDate?.substring(0,11)} ",
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
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          "Room Info.",
                          style: Theme.of(context)
                              .primaryTextTheme
                              .titleLarge!
                              .copyWith(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: "rubic"),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Adults : ${hotelList[i].bookingMeta?.adults}",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .bodyLarge!
                                  .copyWith(
                                      color: Colors.black,
                                      fontFamily: "rubic",
                                      fontSize: 14),
                            ),
                            Text(
                              "Children : ${hotelList[i].bookingMeta?.children}",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .bodyLarge!
                                  .copyWith(
                                      color: Colors.black,
                                      fontFamily: "rubic",
                                      fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: Colors.blue.withOpacity(0.6),
                                ),
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  " ${DateFormat("dd MMM yyyy hh:mm a").format(DateTime.parse(hotelList[i].createdAt ?? ''))} ",
                                  style: const TextStyle(
                                      color: AppColors.whiteTemp,
                                      fontFamily: "rubic"),
                                )

                                // Text("${DateFormat("dd MMM yyyy ")
                                //     .format(DateTime.parse(
                                //     hotelList[i].createdAt ?? ''))}",
                                //   style: const TextStyle(color: Colors.black,
                                //       fontWeight: FontWeight.bold),)
                                ),
                            Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: Colors.green,
                                ),
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  "₹${hotelList[i].total}",
                                  style: TextStyle(
                                      fontFamily: "rubic",
                                      color: AppColors.whiteTemp),
                                )),
                          ],
                        ),
                        const Divider(),
                        // if( DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day, ) == DateTime.parse(
                        //     hotelList[i].startDate??''))
                        if (hotelList[i].status != "cancelled" &&
                            DateTime.now().isAfter(
                                DateTime.parse(hotelList[i].startDate ?? '')))
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.secondary),
                              onPressed: () async {
                                String url =
                                    'https://hellostay.com/api/user/${hotelList[i].code}/invoice?token=$authToken';
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not open the map.';
                                }
                              },
                              child: const Text(
                                'Download Invoice',
                                style: TextStyle(
                                    fontFamily: 'rubic',
                                    color: AppColors.whiteTemp),
                              ))
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
              );
            })
        : const Center(
            child: Text("No Hotel Booking Available"),
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
  }
}

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = AppColors.primary // Color of the line
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0; // Width of the line

    double dashWidth = 0; // Width of each dash
    double dashSpace = 5; // Space between each dash

    double startY = 0; // Starting point for the line
    double endY = size.height; // Ending point for the line

    double currentX = 0;

    while (currentX < size.width) {
      canvas.drawLine(
        Offset(currentX, startY),
        Offset(currentX + dashWidth, startY),
        paint,
      );

      currentX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class DottedLinePainter1 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = AppColors.secondary // Color of the line
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0; // Width of the line

    double dashWidth = 0; // Width of each dash
    double dashSpace = 5; // Space between each dash

    double startY = 0; // Starting point for the line
    double endY = size.height; // Ending point for the line

    double currentX = 0;

    while (currentX < size.width) {
      canvas.drawLine(
        Offset(currentX, startY),
        Offset(currentX + dashWidth, startY),
        paint,
      );

      currentX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class dataFirestore extends StatelessWidget {
  final String? userId;

  dataFirestore({this.list, this.userId});

  final List? list;
  var _txtStyleTitle = TextStyle(
    color: Colors.black87,
    fontFamily: "Gotik",
    fontSize: 17.0,
    fontWeight: FontWeight.w800,
  );

  var _txtStyleSub = TextStyle(
    color: Colors.black26,
    fontFamily: "Gotik",
    fontSize: 12.5,
    fontWeight: FontWeight.w600,
  );

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var imageOverlayGradient = DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: FractionalOffset.bottomCenter,
          end: FractionalOffset.topCenter,
          colors: [
            const Color(0xFF000000),
            const Color(0x00000000),
            Colors.black,
            Colors.black,
            Colors.black,
            Colors.black,
          ],
        ),
      ),
    );

    return SizedBox.fromSize(
        child: ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      primary: false,
      itemCount: 10,
      itemBuilder: (context, i) {
        //List<String> photo = List.from(list[i].data()['photo']);
        // List<String> service = List.from(list[i].data()['service']);
        // List<String> description = List.from(list[i].data()['description']);
        String title = 'title';
        //String type = 'type';
        double rating = 4.5;
        String image =
            'https://www.seleqtionshotels.com/content/dam/seleqtions/Connaugth/TCPD_PremiumBedroom4_1235.jpg/jcr:content/renditions/cq5dam.web.1280.1280.jpeg';
        String id = 'id';
        String checkIn = 'Check In';
        String checkOut = 'Check Out';
        String count = 'Count';
        String locationReservision = 'Location';
        String rooms = 'Rooms';
        String roomName = 'Room Name';
        String information = 'Information Room';

        num priceRoom = 250;
        num price = 150;
        // num latLang1 = list[i].data()['latLang1'];
        //num latLang2 = list[i].data()['latLang2'];

        //DocumentSnapshot _list = list[i];

        return InkWell(
          onTap: () {
            /*Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (_, __, ___) => new BookingDetail(
                      userId: userId,
                      titleD: title,
                      idD: id,
                      imageD: image,
                      information: information,
                      priceRoom: priceRoom,
                      roomName: roomName,
                      latLang1D: latLang1,
                      latLang2D: latLang2,
                      priceD: price,
                      listItem: _list,
                      descriptionD: description,
                      photoD: photo,
                      ratingD: rating,
                      serviceD: service,
                      typeD: type,
                      checkIn: checkIn,
                      checkOut: checkOut,
                      count: count,
                      locationReservision: locationReservision,
                      rooms: rooms,
                    ),
                    transitionDuration: Duration(milliseconds: 1000),
                    transitionsBuilder:
                        (_, Animation<double> animation, __, Widget child) {
                      return Opacity(
                        opacity: animation.value,
                        child: child,
                      );
                    }));*/
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
            child: Container(
              height: 280.0,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12.withOpacity(0.1),
                        blurRadius: 3.0,
                        spreadRadius: 1.0)
                  ]),
              child: Column(children: [
                Container(
                  height: 165.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10.0),
                        topLeft: Radius.circular(10.0)),
                    image: DecorationImage(
                        image: NetworkImage(image), fit: BoxFit.cover),
                  ),
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0, right: 10.0),
                    child: CircleAvatar(
                        radius: 20.0,
                        backgroundColor: Colors.black54,
                        child: InkWell(
                          onTap: () {
                            /*showDialog(
                                    context: context,
                                    builder: (_) => NetworkGiffyDialog(
                                      image: Image.network(
                                        image,
                                        fit: BoxFit.cover,
                                      ),
                                      title: Text(
                                          'CANCEL_BOOKING'.tr,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: "Gotik",
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.w600)),
                                      description: Text(
                                       'ARE_YOU_WANT'.tr +
                                            title,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: "Popins",
                                            fontWeight: FontWeight.w300,
                                            color: Colors.black26),
                                      ),
                                      onOkButtonPressed: () {
                                        Navigator.pop(context);

                                        FirebaseFirestore.instance
                                            .runTransaction(
                                                (transaction) async {
                                              DocumentSnapshot snapshot =
                                              await transaction
                                                  .get(list[i].reference);
                                              await transaction
                                                  .delete(snapshot.reference);
                                              SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                              prefs.remove(title);
                                            });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              AppLocalizations.of(context)
                                                  .tr('cancelBooking2') +
                                                  title),
                                          backgroundColor: Colors.red,
                                          duration: Duration(seconds: 3),
                                        ));
                                      },
                                    ));*/
                          },
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                width: 220.0,
                                child: Text(
                                  title,
                                  style: _txtStyleTitle,
                                  overflow: TextOverflow.ellipsis,
                                )),
                            Padding(padding: EdgeInsets.only(top: 5.0)),
                            Row(
                              children: <Widget>[
                                RatingBar.builder(
                                  initialRating: rating,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 12.0,
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                  },
                                ),
                                // ratingbar(
                                //   starRating: rating,
                                //   color: Color(0xFF09314F),
                                // ),
                                Padding(padding: EdgeInsets.only(left: 5.0)),
                                Text(
                                  "(" + rating.toString() + ")",
                                  style: _txtStyleSub,
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4.9),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.location_on,
                                    size: 16.0,
                                    color: Colors.black26,
                                  ),
                                  Padding(padding: EdgeInsets.only(top: 3.0)),
                                  Text(locationReservision, style: _txtStyleSub)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 13.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "\$" + price.toString(),
                              style: TextStyle(
                                  fontSize: 25.0,
                                  color: Color(0xFF09314F),
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Gotik"),
                            ),
                            Text('PER_NIGHT',
                                style: _txtStyleSub.copyWith(fontSize: 11.0))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 6.9),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('CHECK_IN' + " : \t",
                              style: _txtStyleSub.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          Padding(padding: EdgeInsets.only(top: 3.0)),
                          Text(checkIn, style: _txtStyleSub)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 6.9),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('CHECK_OUT' + " : \t",
                              style: _txtStyleSub.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          Padding(padding: EdgeInsets.only(top: 3.0)),
                          Text(checkOut, style: _txtStyleSub)
                        ],
                      ),
                    )
                  ],
                ),
              ]),
            ),
          ),
        );
      },
    ));
  }
}
