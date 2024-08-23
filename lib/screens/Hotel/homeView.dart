import 'dart:async';
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hellostay/constants/colors.dart';
import 'package:hellostay/model/home_banner_model.dart';
import 'package:hellostay/model/trendingHotelModel.dart';
import 'package:hellostay/repository/apiConstants.dart';
import 'package:hellostay/screens/Hotel/hotel_list_View.dart';
import 'package:hellostay/screens/Hotel/notification_screen.dart';
import 'package:hellostay/screens/loginScreen.dart';
import 'package:hellostay/screens/userProfile/Mywallet.dart';
import 'package:hellostay/utils/address_search.dart';
import 'package:hellostay/utils/date_function.dart';
import 'package:hellostay/utils/globle.dart';
import 'package:hellostay/utils/place_service.dart';
import 'package:hellostay/utils/traver_tile.dart';
import 'package:hellostay/widgets/custom_app_button.dart';
import 'package:hellostay/widgets/select_date_widget.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import 'calender_view.dart';
import 'hotel_details_View.dart';

final List rooms = [
  {
    "image":
        "https://cdn.britannica.com/96/115096-050-5AFDAF5D/Bellagio-Hotel-Casino-Las-Vegas.jpg",
    "title": "Peaceful Room"
  },
  {
    "image":
        "https://images.unsplash.com/photo-1625244724120-1fd1d34d00f6?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8aG90ZWxzfGVufDB8fDB8fA%3D%3D&w=1000&q=80",
    "title": "Peaceful Room"
  },
  {
    "image":
        "https://23c133e0c1637be1e07d-be55c16c6d91e6ac40d594f7e280b390.ssl.cf1.rackcdn.com/u/gpch/Park-Hotel-Group---Explore---Grand-Park-City-Hall-Facade.jpg",
    "title": "Beautiful Room"
  },
  {
    "image":
        "https://cdn.britannica.com/96/115096-050-5AFDAF5D/Bellagio-Hotel-Casino-Las-Vegas.jpg",
    "title": "Vintage room near Pashupatinath"
  },
];

List images = [];
List city = [];
DateTime startDate = DateTime.now();
DateTime endDate = DateTime.now().add(const Duration(days: 5));
String formattedCheckInDate = '';
String formattedCheckOutDate = '';
String checkInDayOfWeek = '';
String checkOutDayOfWeek = '';
double? lat = 12.9715987;
double? lng = 77.5945627;

bool isDatePopupOpen = false;

class HotelHomePage extends StatefulWidget {
  static const String path = "lib/src/pages/hotel/hhome.dart";

  @override
  State<HotelHomePage> createState() => _HotelHomePageState();
}

int roomCount = 0;
int peopleCount = 0;
int childCount = 0;

final checkInC = TextEditingController();
final checkOutC = TextEditingController();
final searchC = TextEditingController();

String checkInDate = '';

String checkOutDate = '';

//CityListResponse? cityListResponse;
dynamic cityListResponse;

class _HotelHomePageState extends State<HotelHomePage> {
  Position? _position;
  var _controller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    //getCityList();
    super.initState();

    ///

    _controller.text =
        "Suggestion(description: Bengaluru, Karnataka, India, placeId: ChIJbU60yXAWrjsR4E9-UejD3_g).description";
    searchC.text = "Bengaluru, Karnataka, India";
    adultCountList = [];
    childrenCountList = [];
    adultCount1 = 2;
    childrenCount1 = 0;
    room = 1;
    childrenCountListOfList = [];

    ///
    getFcmToken();
    checkInDate = DateTime.now().toString();
    checkOutDate = DateTime.now().add(const Duration(days: 1)).toString();
    formattedCheckInDate =
        DateFormat("dd MMM''yy").format(DateTime.parse(checkInDate));
    checkInDayOfWeek = DateFormat("EEEE").format(DateTime.parse(checkInDate));
    formattedCheckOutDate =
        DateFormat("dd MMM''yy").format(DateTime.parse(checkOutDate));
    checkOutDayOfWeek = DateFormat("EEEE").format(DateTime.parse(checkOutDate));
    getBannerApi();
    trendingHotel();
    getLocationApi();
    print("token----${authToken}");
  }

  HomeBannerModel? homeBannerModel;
  getBannerApi() async {
    var request = http.Request(
        'GET', Uri.parse('https://hellostay.com/api/coupon-banners'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();

      var finaResult = jsonDecode(result);

      setState(() {
        homeBannerModel = HomeBannerModel.fromJson(finaResult);

        print(homeBannerModel?.data?.length);
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  getFcmToken() async {
    String? token = await FirebaseMessaging.instance.getToken();

    print("${token}");
  }

  // Payload? cityId;

  /*static String _displayStringForOption(Payload option) =>
      option.name ?? '';*/
  // TextEditingController citySearchC =  TextEditingController();

  String _streetNumber = '';
  String _street = '';
  String _city = '';
  String _zipCode = '';
  int adultCount = 1;
  int childrenCount = 0;
  List<int> childrenAges = List.filled(0, 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: InkWell(
        onTap: () {
          int valid = 0;
          bool containsNull =
              childrenCountListOfList.any((list) => list.contains(null));
          // for(int i=0;i<room ;i++)
          //   {
          //     for(int k=0;k<)
          //     valid+=childrenCountListOfList[i].length;
          //   }
          bool isFirstElementNull = adultCountList.isNotEmpty;

          bool isLessThan1 = true;
          for (int i = 0; i < adultCountList.length; i++) {
            print(adultCountList[i].toString() + "ADULT COUNT");
            if (adultCountList[i] < 1) {
              isLessThan1 = true;
              Fluttertoast.showToast(msg: "Please add  adults in all rooms");
              return;
            } else {
              isLessThan1 = false;
            }
            Map<String, String> guestData = {
              'tot_adults[$i]': adultCountList[i].toString(),
              'tot_children[$i]': childrenCountList[i].toString(),
              'children_age[$i]': childrenCountListOfList[i].toString()
            };
            //   guestsList.add(guestData);
          }
          print('roomscounts------${childrenCountList.length}');
          print('rooms counts------${childrenCountListOfList.length}');
          print('rooms counts------${childrenCount1}');
          print('rooms counts------${isFirstElementNull}');

          // for(int i=0;i<childrenCountList.length; i++)
          //   {
          //     if(childrenCountList)
          //   }

          // childrenCountList[i].toString(),
          // 'children_age[$i]': childrenCountListOfList[i].toString()

          if (containsNull == false) {
            print('api address ${_controller.text}');
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HotelSearchScreen(
                    children: childrenCount,
                    adults: adultCount,
                    //title: cityId?.name ?? '',
                    checkIn: DateFormat("dd MMM''yy")
                        .format(DateTime.parse(checkInDate)),
                    checkOut: DateFormat("dd MMM''yy")
                        .format(DateTime.parse(checkOutDate)),
                    address: _controller.text,
                    lat: '',
                    long: '',
                  ),
                ));
          } else {
            Fluttertoast.showToast(msg: "Please Select Child Age");
          }
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 08, 20, 08),
          child: CustomButton(textt: 'Search Hotels'),
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        leading: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NotificationScreen()));
            },
            child: const Icon(Icons.notifications_active_outlined,
                color: AppColors.faqanswerColor)),
        title: Container(
          height: 70,
          width: 150,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/homeLogo.png'),
                  fit: BoxFit.contain)),
        ),
        actions: [
          InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyWallet()));
              },
              child: Icon(Icons.account_balance_wallet_outlined,
                  color: AppColors.faqanswerColor)),
          SizedBox(
            width: 12,
          ),
          InkWell(
            onTap: () {
              share();
            },
            child: Icon(
              Icons.share_outlined,
              color: AppColors.faqanswerColor,
            ),
          ),
          SizedBox(
            width: 15,
          )
        ],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          /* SliverAppBar(
            title: Container(
              padding: const EdgeInsets.all(40),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                          'assets/images/appLogo2.png'),
                      fit: BoxFit.contain)),
            ),
            backgroundColor: Colors.white,
            */ /*leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),*/ /*
            */ /*actions: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.favorite_border,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
            ],*/ /*
            floating: false,
          ),*/
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 15.0,
            ),
          ),
          /*SliverToBoxAdapter(
            child: getTimeDateUI(context),
          ),*/
          /*const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Book on India's Largest Hotel Network",
                style: TextStyle(fontSize: 25),
              ),
            ),
          ),*/
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: 30,
              width: double.maxFinite,
              color: AppColors.faqanswerColor.withOpacity(0.1),
              child: InkWell(
                onTap: () async {
                  var posstion = await _determinePosition();
                  lat = posstion.latitude;
                  lng = posstion.longitude;
                  searchC.text = 'Near Me';
                  print("lat------$lat");
                  print("long----------$lat");
                },
                child: Row(
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(5),
                      child: Icon(
                        Icons.gps_fixed,
                        color: AppColors.secondary,
                        size: 18,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text(
                      'Show Hotels near me',
                      style: TextStyle(
                          color: AppColors.secondary, fontFamily: 'rubic'),
                    )
                  ],
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Select City, Location or Hotel Name(Worldwide)",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.black54.withOpacity(0.4),
                    fontFamily: 'rubic'),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: TextFormField(
                readOnly: true,
                controller: searchC,
                onTap: () async {
                  print("kkk");
                  final sessionToken = const Uuid().v4();
                  debugPrint("${sessionToken}");
                  final Suggestion? result = await showSearch(
                    context: context,
                    delegate: AddressSearch(sessionToken),
                  );
                  if (result != null) {
                    final placeDetails = await PlaceApiProvider(sessionToken)
                        .getPlaceDetailFromId(result.placeId);

                    searchC.text = result.description;
                    _streetNumber = placeDetails.streetNumber ?? '';
                    _street = placeDetails.street ?? '';
                    _city = placeDetails.city ?? '';
                    _zipCode = placeDetails.zipCode ?? '';
                    setState(() {
                      print("adddddrrrreeeees $result.description");
                      _controller.text = result.description;
                      setState(() {});
                      print("adddddrrrreeeees $_controller.text");
                    });
                  }
                  /* var result = ShowListForm();
                              if (result != "" ||
                                  result != null) {
                                fromcitycontroller =
                                    TextEditingController(
                                        text: result
                                            .toString());
                              }*/
                },
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 16, fontFamily: 'rubic', color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Select',
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'rubic',
                      color: Colors.black54.withOpacity(0.4)),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 15.0,
            ),
          ),
          SliverToBoxAdapter(
            child: TravelDetailsTile(isFromHome: true),
          ),
          const SliverToBoxAdapter(
              child: Padding(
            padding: EdgeInsets.only(left: 8.0, right: 8.0),
            child: Divider(),
          )),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      onTap: () async {
                        //String date = await selectDate(context);
                        await showCalanderDatePicker(context);

                        // checkInDate = date;
                        String date = checkInDate;
                        print(checkInDate + 'sdjkfhshdfhshfsh');

                        formattedCheckInDate = DateFormat("dd MMM''yy")
                            .format(DateTime.parse(date));

                        checkInDayOfWeek =
                            DateFormat("EEEE").format(DateTime.parse(date));

                        ///for automate checkout date-------------------------------------------------
                        /* checkOutDate = DateTime.parse(date)
                            .add(const Duration(days: 5))
                            .toString();*/

                        formattedCheckOutDate = DateFormat("dd MMM''yy")
                            .format(DateTime.parse(checkOutDate));
                        checkOutDayOfWeek = DateFormat("EEEE")
                            .format(DateTime.parse(checkOutDate));

                        ///-----------------------------------------------------

                        setState(() {
                          isCheckInSelected = true;
                          isCheckOutSelected = false;
                        });
                      },
                      child: selectDateWidget('Check-in', checkInDayOfWeek,
                          formattedCheckInDate, isCheckInSelected, context)),
                  const Icon(
                    Icons.nights_stay,
                    color: AppColors.faqanswerColor,
                  ),
                  InkWell(

                      // onTap: () async {
                      //  // String date = await selectDate(context);
                      //   await showCalanderDatePicker(context);
                      //  // checkOutDate = date;
                      //   String date = checkOutDate;
                      //   formattedCheckOutDate = DateFormat("dd MMM''yy")
                      //       .format(DateTime.parse(date));
                      //   checkOutDayOfWeek =
                      //       DateFormat("EEEE").format(DateTime.parse(date));
                      //   setState(() {
                      //     isCheckInSelected = false;
                      //     isCheckOutSelected = true;
                      //   });
                      // },
                      onTap: () async {
                        //String date = await selectDate(context);
                        await showCalanderDatePicker(context);

                        // checkInDate = date;
                        String date = checkInDate;
                        print(checkInDate + 'sdjkfhshdfhshfsh');

                        formattedCheckInDate = DateFormat("dd MMM''yy")
                            .format(DateTime.parse(date));

                        checkInDayOfWeek =
                            DateFormat("EEEE").format(DateTime.parse(date));

                        ///for automate checkout date-------------------------------------------------
                        /* checkOutDate = DateTime.parse(date)
                            .add(const Duration(days: 5))
                            .toString();*/

                        formattedCheckOutDate = DateFormat("dd MMM''yy")
                            .format(DateTime.parse(checkOutDate));
                        checkOutDayOfWeek = DateFormat("EEEE")
                            .format(DateTime.parse(checkOutDate));

                        ///-----------------------------------------------------

                        setState(() {
                          isCheckInSelected = true;
                          isCheckOutSelected = false;
                        });
                      },
                      child: selectDateWidget('Check-Out', checkOutDayOfWeek,
                          formattedCheckOutDate, isCheckOutSelected, context)),
                  /*Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                       Text("Check-in",style: TextStyle(color: Colors.black54
                          .withOpacity(0.4)),),
                      SizedBox(
                        width: MediaQuery.of(context)
                            .size
                            .width /
                            2.5,
                        child: TextFormField(
                          readOnly: true,
                          controller: checkInC,
                          onTap: () {
                           */
                  /*Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                       Text("Check-out",style: TextStyle(color: Colors.black54
                          .withOpacity(0.4))),
                      SizedBox(
                        width: MediaQuery.of(context)
                            .size
                            .width /
                            2.5,
                        child: TextFormField(
                          readOnly: true,
                          controller: checkOutC,
                          onTap: () async{

                            String date = await selectDate(context);

                           // String _dateValue = convertDateTimeDisplay(date);
                            String dateFormate = DateFormat("dd MMM''yy, EEEE").format(DateTime.parse(date ?? ""));

                            checkOutC.text =  dateFormate;

                            print(dateFormate) ;
                          },
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                              hintText: 'Select',
                              hintStyle: TextStyle(
                                  fontWeight:
                                  FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.black54
                                      .withOpacity(0.4))),
                        ),
                      )
                    ],
                  )*/
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(left: 20, top: 10),
              child: Text(
                "Top Destinations",
                style: TextStyle(fontSize: 16, fontFamily: 'rubic'),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal, child: _buildRooms(context)),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 10),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                "Today's Offer",
                style: TextStyle(fontSize: 16, fontFamily: 'rubic'),
              ),
            ),
          ),
          // SliverToBoxAdapter(
          //   child: SingleChildScrollView(
          //     scrollDirection: Axis.horizontal,
          //     child: Row(
          //       children: [
          //         ListView.builder(
          //           itemCount: homeBannerModel?.data?.length??0,
          //           itemBuilder: (context, index) {
          //           return Container(
          //             decoration: BoxDecoration(
          //               image: DecorationImage(
          //                 image: NetworkImage(homeBannerModel!.data![index].bgImage ?? ""),
          //                    //fit: BoxFit.cover, // Adjust this based on your requirement
          //               ),
          //             ),
          //           );
          //
          //           },)
          //       ],
          //     ),
          //   ),
          // ),

          //
          //  SliverToBoxAdapter(
          //      child: SingleChildScrollView(
          //        scrollDirection: Axis.horizontal,
          //          child: Row (children: List<Widget>.generate(homeBannerModel?.data?.length ?? 0, (index) => Padding(
          //            padding: const EdgeInsets.all(8.0),
          //            child: _buildRooms2(context, index),
          //          )),))
          // ),

          SliverToBoxAdapter(
            child: CarouselSlider(
              options: CarouselOptions(
                viewportFraction: 1,
                height: 230,
                // enlargeCenterPage: true,
                enableInfiniteScroll: true,
                autoPlay: true,
                // enlargeCenterPage: true,
              ),
              items: homeBannerModel?.data?.map((item) {
                return Builder(
                  builder: (BuildContext context) {
                    return _buildRooms2(context, item);
                  },
                );
              }).toList(),
            ),
          )

          /*SliverList(
            delegate:
            SliverChildBuilderDelegate((BuildContext context, int index) {
              return _buildRooms(context, index);
            }, childCount: 100,),
          )*/
        ],
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: "Location services are disabled");
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  // CitySearchModel? citySearchModel;
  TrendingHotelModel? imageTrendingModel;

  trendingHotel() async {
    var request = http.Request('GET', Uri.parse("${baseUrl1}hotel/trending"));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();

      final finalResult =
          TrendingHotelModel.fromJson(json.decode(finalResponse));
      setState(() {
        imageTrendingModel = finalResult;
      });
    } else {
      print(response.reasonPhrase);
      print("api not run");
    }
  }

  getLocationApi() async {
    var request = http.Request('GET', Uri.parse('${baseUrl1}locations'));
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      var finaResult = jsonDecode(finalResponse);
      // print(await response.stream.bytesToString());
      images.clear();
      city.clear();
      for (Map i in finaResult['data']) {
        images.add(i["image"]);
        city.add(i["title"]);
      }
      setState(() {});
    } else {
      print(response.reasonPhrase);
    }
  }

  int currentIndex = 0;

  Widget _buildRooms(BuildContext context) {
    // var room = rooms[index % rooms.length];
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context)
              .size
              .width, // Set the width to the screen width
          child: CarouselSlider(
            options: CarouselOptions(
              height: 240,
              // Adjust height as needed
              viewportFraction: 1,
              // enlargeCenterPage: true,
              enableInfiniteScroll: true,
              autoPlay: true,
              onPageChanged: (int index, CarouselPageChangedReason reason) {
                // currentIndex=index;
                setState(() {
                  currentIndex = index;
                });
              },
            ),
            items: images.map((image) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    margin: const EdgeInsets.only(
                        left: 10, right: 10, top: 20, bottom: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                Container(
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.black45.withOpacity(0.1),
                                    image: DecorationImage(
                                      image: NetworkImage(image),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 8,
                                  top: 8,
                                  child: Text(
                                    city[currentIndex],
                                    // Assuming city list length matches images list length
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ),
        // Dots Indicator
        /*Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(images.length, (index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index == currentIndex ? Colors.grey : Colors.black,
                ),
              ),
            );
          }),
        ),*/
      ],
    );
  }

  // Widget _buildRooms2(BuildContext context, int index) {
  //   var room = rooms[index % rooms.length];
  //   var item =homeBannerModel?.data?[index];
  //   return Container(
  //     //height: 322,
  //     width: MediaQuery.of(context).size.width/1.05,
  //     child: ClipRRect(
  //       borderRadius: BorderRadius.circular(5.0),
  //       child: Column(
  //         //crossAxisAlignment: CrossAxisAlignment.start,
  //        // mainAxisSize: MainAxisSize.min,
  //         children: <Widget>[
  //           Stack(
  //             children: <Widget>[
  //               Image.network(item?.bgImage?? "",fit: BoxFit.fill,height: 200,width: MediaQuery.of(context).size.width/1.05,),
  //               Positioned(
  //                 right: 10,
  //                 top: 10,
  //                 child: Icon(
  //                   Icons.star,
  //                   color: Colors.grey.shade800,
  //                   size: 20.0,
  //                 ),
  //               ),
  //               const Positioned(
  //                 right: 8,
  //                 top: 8,
  //                 child: Icon(
  //                   Icons.star_border,
  //                   color: Colors.white,
  //                   size: 24.0,
  //                 ),
  //               ),
  //
  //             ],
  //           ),
  //
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildRooms2(BuildContext context, item) {
    // Replace YourItemType with the actual type of homeBannerModel?.data
    return Container(
      height: 200,
      // width: MediaQuery.of(context).size.width / 1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: Column(
            children: <Widget>[
              Image.network(
                item?.bgImage ?? "",
                fit: BoxFit.fill,
                height: 200,
                //width: MediaQuery.of(context).size.width / 1.05,
              ),
            ],
          ),
        ),
      ),
    );
  }
  // Widget _buildRooms2(BuildContext context, int index) {
  //    var room = rooms[index % rooms.length];
  //    var item =homeBannerModel?.data?[index];
  //    return Container(
  //      //height: 322,
  //      width: MediaQuery.of(context).size.width/1.05,
  //      child: ClipRRect(
  //        borderRadius: BorderRadius.circular(5.0),
  //        child: Column(
  //          //crossAxisAlignment: CrossAxisAlignment.start,
  //         // mainAxisSize: MainAxisSize.min,
  //          children: <Widget>[
  //            Stack(
  //              children: <Widget>[
  //                Image.network(item?.bgImage?? "",fit: BoxFit.fill,height: 200,width: MediaQuery.of(context).size.width/1.05,),
  //                Positioned(
  //                  right: 10,
  //                  top: 10,
  //                  child: Icon(
  //                    Icons.star,
  //                    color: Colors.grey.shade800,
  //                    size: 20.0,
  //                  ),
  //                ),
  //                const Positioned(
  //                  right: 8,
  //                  top: 8,
  //                  child: Icon(
  //                    Icons.star_border,
  //                    color: Colors.white,
  //                    size: 24.0,
  //                  ),
  //                ),
  //                // Positioned(
  //                //   bottom: 20.0,
  //                //   right: 10.0,
  //                //   child: Container(
  //                //     padding: const EdgeInsets.all(10.0),
  //                //     color: Colors.white,
  //                //     child: Text("\u{20B9} ${item?.price ?? ""}", style: TextStyle(fontFamily: 'rubic'),),
  //                //   ),
  //                // )
  //              ],
  //            ),
  //            // Container(
  //            //   padding: const EdgeInsets.all(16.0),
  //            //   child: Column(
  //            //     crossAxisAlignment: CrossAxisAlignment.start,
  //            //     children: <Widget>[
  //            //       Text(
  //            //         item?.title ?? "",
  //            //         style: const TextStyle(
  //            //             fontSize: 15.0,fontFamily: 'rubic'),
  //            //       ),
  //            //       const SizedBox(
  //            //         height: 5.0,
  //            //       ),
  //            //       // Text(item?.location?.name ?? "",style: TextStyle(fontFamily: 'rubic'),),
  //            //       const SizedBox(
  //            //         height: 10.0,
  //            //       ),
  //            //       // Row(
  //            //       //   crossAxisAlignment: CrossAxisAlignment.center,
  //            //       //   children: <Widget>[
  //            //       //     IgnorePointer(
  //            //       //       ignoring: true,
  //            //       //       child: RatingBar.builder(
  //            //       //         initialRating: item?.reviewScore?.totalReview is int
  //            //       //             ? (item?.reviewScore?.totalReview as int)
  //            //       //                 .toDouble()
  //            //       //             : double.tryParse(item?.reviewScore?.totalReview
  //            //       //                         ?.toString() ??
  //            //       //                     "") ??
  //            //       //                 0.0,
  //            //       //         minRating: 1,
  //            //       //         direction: Axis.horizontal,
  //            //       //         allowHalfRating: false,
  //            //       //         itemCount: 5,
  //            //       //         itemSize: 12.0,
  //            //       //         itemBuilder: (context, _) => Icon(
  //            //       //           Icons.star,
  //            //       //           color: Colors.amber,
  //            //       //         ),
  //            //       //         onRatingUpdate:
  //            //       //             (_) {}, // Provide an empty function to disable editing
  //            //       //       ),
  //            //       //     )
  //            //       //
  //            //       //     // const Icon(
  //            //       //     //   Icons.star,
  //            //       //     //   color: Colors.green,size: 10,
  //            //       //     // ),const Icon(
  //            //       //     //   Icons.star,
  //            //       //     //   color: Colors.green,size: 10,
  //            //       //     // ),const Icon(
  //            //       //     //   Icons.star,
  //            //       //     //   color: Colors.green,size: 10,
  //            //       //     // ),const Icon(
  //            //       //     //   Icons.star,
  //            //       //     //   color: Colors.green,size: 10,
  //            //       //     // ),const Icon(
  //            //       //     //   Icons.star,
  //            //       //     //   color: Colors.green,size: 10,
  //            //       //     // ),
  //            //       //
  //            //       //     ,
  //            //       //     const SizedBox(
  //            //       //       width: 5.0,
  //            //       //     ),
  //            //       //     Text(
  //            //       //       'Total Review ${item?.reviewScore?.totalReview ?? ""} ',
  //            //       //       style:
  //            //       //           const TextStyle(color: Colors.grey, fontSize: 10),
  //            //       //     )
  //            //       //   ],
  //            //       // )
  //            //     ],
  //            //   ),
  //            // ),
  //          ],
  //        ),
  //      ),
  //    );
  //  }

  Widget getTimeDateUI(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, bottom: 16),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.grey.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      setState(() {
                        isDatePopupOpen = true;
                      });
                      showDemoDialog(context: context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 4, bottom: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Choose date',
                            style: TextStyle(
                                fontWeight: FontWeight.w100,
                                fontSize: 16,
                                color: Colors.grey.withOpacity(0.8)),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            '${DateFormat("dd, MMM").format(startDate)} - ${DateFormat("dd, MMM").format(endDate)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w100,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(
              width: 1,
              height: 42,
              color: Colors.grey.withOpacity(0.8),
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.grey.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      if (false /*cityId == null*/) {
                        Fluttertoast.showToast(msg: 'please select city first');
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => showPeopleDialouge(context),
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 4, bottom: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Number of Rooms',
                            style: TextStyle(
                                fontWeight: FontWeight.w100,
                                fontSize: 16,
                                color: Colors.grey.withOpacity(0.8)),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            '${peopleCount} Adults - ${childCount} Child',
                            style: const TextStyle(
                              fontWeight: FontWeight.w100,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> share({String? referCode}) async {
    FlutterShare.share(
        title: 'HELLOSTAY',
        text: "HELLOSTAY",
        linkUrl: 'https://g.co/kgs/urtYWPz',
        chooserTitle: 'Example Chooser Title');
  }

  Widget showPeopleDialouge(BuildContext cntxtt) {
    return StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: const Align(
            alignment: Alignment.topCenter, child: Text('Room Selected')),
        titlePadding: const EdgeInsets.only(top: 10),
        backgroundColor: Colors.white,
        contentPadding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.withOpacity(0.5))),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.center,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Adults'),
                    Row(
                      children: [
                        InkWell(
                            onTap: () {
                              setState(() {
                                peopleCount++;
                              });
                            },
                            child: const Icon(Icons.add_circle_outline)),
                        const SizedBox(
                          width: 10,
                        ),
                        Text('${peopleCount}'),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                            onTap: () {
                              setState(() {
                                if (peopleCount > 0) {
                                  peopleCount--;
                                }
                              });
                            },
                            child: const Icon(Icons.remove_circle_outline)),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Child'),
                    Row(
                      children: [
                        InkWell(
                            onTap: () {
                              setState(() {
                                childCount++;
                              });
                            },
                            child: const Icon(Icons.add_circle_outline)),
                        const SizedBox(
                          width: 10,
                        ),
                        Text('${childCount}'),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                            onTap: () {
                              setState(() {
                                if (childCount > 0) {
                                  childCount--;
                                }
                              });
                            },
                            child: const Icon(Icons.remove_circle_outline)),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      /*Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AnaheimScreen(
                              child: childCount,
                              adults: peopleCount,
                              title: cityId?.name ?? '',
                              checkIn:
                              DateFormat('yyyy-MM-dd').format(startDate),
                              checkOut:
                              DateFormat('yyyy-MM-dd').format(endDate),
                              cityId: cityId?.code.toString(),
                            ),
                          ));*/
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        minimumSize: const Size(double.maxFinite, 40),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    child: const Text('Apply')),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showDemoDialog({BuildContext? context}) {
    showDialog<dynamic>(
      context: context!,
      builder: (BuildContext context) => CalendarPopupView(
        barrierDismissible: true,
        minimumDate: DateTime.now(),
        //  maximumDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 10),
        initialEndDate: endDate,
        initialStartDate: startDate,
        onApplyClick: (DateTime startData, DateTime endData) {
          setState(() {
            startDate = startData;
            endDate = endData;
          });
        },
        onCancelClick: () {},
      ),
    );
  }

  String dayOfWeek = '';

  bool isCheckInSelected = false;

  bool isCheckOutSelected = false;

/* Widget getTimeDateUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 18, bottom: 16),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.grey.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      // setState(() {
                      //   isDatePopupOpen = true;
                      // });
                      showDemoDialog(context: context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 4, bottom: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Choose date',
                            style: TextStyle(
                                fontWeight: FontWeight.w100,
                                fontSize: 16,
                                color: Colors.grey.withOpacity(0.8)),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            '${DateFormat("dd, MMM").format(startDate)} - ${DateFormat("dd, MMM").format(endDate)}',
                            style: TextStyle(
                              fontWeight: FontWeight.w100,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(
              width: 1,
              height: 42,
              color: Colors.grey.withOpacity(0.8),
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.grey.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 4, bottom: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Number of Rooms',
                            style: TextStyle(
                                fontWeight: FontWeight.w100,
                                fontSize: 16,
                                color: Colors.grey.withOpacity(0.8)),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            '1 Room - 2 Adults',
                            style: TextStyle(
                              fontWeight: FontWeight.w100,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }*/
}

class Category extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? backgroundColor;

  const Category(
      {Key? key, required this.icon, required this.title, this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(5.0))),
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        padding: const EdgeInsets.all(10.0),
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              color: Colors.white,
            ),
            const SizedBox(
              height: 5.0,
            ),
            Text(title, style: const TextStyle(color: Colors.white))
          ],
        ),
      ),
    );
  }
}
