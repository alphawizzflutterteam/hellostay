import 'dart:convert';
import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hellostay/model/hotel_detail_response.dart';
import 'package:hellostay/model/hotel_pasanger_model.dart';
import 'package:hellostay/repository/apiConstants.dart';
import 'package:hellostay/repository/apiStrings.dart';
import 'package:hellostay/utils/Webviewexample.dart';
import 'package:hellostay/utils/globle.dart';
import 'package:hellostay/utils/traver_tile.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../constants/colors.dart';
import 'BookNowDetails.dart';
import 'book_now_view.dart';
import 'homeView.dart';
import 'homeView.dart';
import 'homeView.dart';
import 'homeView.dart';

class RoomReview extends StatefulWidget {
  String? imageD,
      titleD,
      locationD,
      idD,
      typeD,
      userId,
      nameD,
      photoProfileD,
      emailD,
      titleR,
      informationR,
      roomType,
      priceR,
      idR;

  List<String>? photoD, serviceD, descriptionD, imageR;
  num? ratingD, priceD, latLang1D, latLang2D;
  Room? room;

  // List<RoomFullInfo>? list;
  List<dynamic>? list;

  RoomReview(
      {super.key,
      this.room,
      this.imageD,
      this.titleD,
      this.priceD,
      this.locationD,
      this.idD,
      this.photoD,
      this.serviceD,
      this.descriptionD,
      this.userId,
      this.typeD,
      this.emailD,
      this.nameD,
      this.photoProfileD,
      this.latLang1D,
      this.latLang2D,
      this.ratingD,
      this.idR,
      this.imageR,
      this.informationR,
      this.priceR,
      this.roomType,
      this.titleR,
      this.list});

  @override
  _RoomDetailState createState() => _RoomDetailState();
}

class _RoomDetailState extends State<RoomReview> {
  // ReviewRoomResponse? reviewRoomResponse;
  dynamic reviewRoomResponse;

  //HotelBookingResponse? hotelBookingResponse;
  dynamic hotelBookingResponse;

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  // List<HotelPassengerModel> passenger = [];
  List<dynamic> passenger = [];
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.room?.title ?? '',
          style: const TextStyle(
            color: AppColors.blackTemp,
            fontFamily: "rubic",
            fontSize: 20,
            //   fontWeight: FontWeight.w600,
            //fontSize: 30
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.room?.gallery?.isNotEmpty ?? false
                ? SizedBox(
                    height: 200.0,
                    child: Material(
                      child: CarouselSlider.builder(
                        options: CarouselOptions(
                          autoPlay: true,
                          aspectRatio: 14 / 8.5,
                          viewportFraction: 0.8,
                          enlargeCenterPage: true,
                          autoPlayAnimationDuration: const Duration(seconds: 2),
                          autoPlayInterval: const Duration(seconds: 4),
                          autoPlayCurve: Curves.easeInOutSine,
                          onPageChanged: (index, reason) {
                            _current = index;
                          },
                          scrollPhysics: const BouncingScrollPhysics(),
                        ),
                        itemBuilder: (context, index, realIndex) {
                          return index == _current
                              ? ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  child: Stack(
                                    children: [
                                      Image.network(
                                        widget.room?.gallery?[index].large ??
                                            '',
                                        fit: BoxFit.cover,
                                        width: 1000,
                                        height: 170,
                                      )
                                    ],
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(top: 25),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5.0)),
                                    child: Stack(
                                      children: [
                                        Image.network(
                                          widget.room?.gallery?[index].large ??
                                              '',
                                          fit: BoxFit.cover,
                                          width: 1000,
                                          height: 172,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                        },
                        itemCount: widget.room?.gallery?.length ?? 0,
                      ),
                    ),
                  )
                : SizedBox(),

            Padding(
              padding: const EdgeInsets.only(top: 15.0, left: 15.0),
              child: Text(
                widget.room?.title ?? '',
                style: const TextStyle(
                    fontFamily: "rubic",
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 5.0, left: 15.0, bottom: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.star,
                    size: 18.0,
                    color: Colors.yellow,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 3.0, left: 15.0),
                    child: Text(
                      '4.5',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black45,
                          fontFamily: "rubic",
                          fontSize: 19.0),
                    ),
                  ),
                  SizedBox(
                    width: 35.0,
                  ),
                ],
              ),
            ),
            /*const Padding(
                    padding: EdgeInsets.only(top: 20.0, left: 20.0),
                    child: Text(
                      'Services',
                      style: TextStyle(
                          fontFamily: "rubic",
                          fontSize: 20.0,
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.justify,
                    ),
                  ),*/

            /*Padding(
                    padding: const EdgeInsets.only(
                        top: 0.0, left: 20.0, right: 20.0, bottom: 0.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: (widget.room?.termFeatures ?? [])
                            .map((item) => Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, left: 10.0, bottom: 10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "-   ",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 24.0),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.3,
                                        child: Text(
                                          item.title ?? '',
                                          style: const TextStyle(
                                              fontFamily: "rubic",
                                              color: Colors.black54,
                                              fontSize: 18.0),
                                          overflow: TextOverflow.clip,
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                            .toList()),
                  ),*/
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GridView.count(
                shrinkWrap: true,
                childAspectRatio: 2.65,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                crossAxisCount: 3,
                children: List<Widget>.generate(
                    widget.room?.termFeatures?.length ?? 0, (index) {
                  var item = widget.room?.termFeatures?[index];
                  return Column(
                    children: [
                      Row(
                        children: [
                          item!.title.toLowerCase().contains('wake')
                              ? const Icon(
                                  Icons.watch_later_outlined,
                                  size: 24,
                                  color: AppColors.primary,
                                )
                              : item.title.toLowerCase().contains('tv')
                                  ? const Icon(
                                      Icons.tv,
                                      size: 24,
                                      color: AppColors.primary,
                                    )
                                  : item.title.toLowerCase().contains('laundry')
                                      ? const Icon(
                                          Icons.local_laundry_service,
                                          size: 24,
                                          color: AppColors.primary,
                                        )
                                      : item.title
                                              .toLowerCase()
                                              .contains('wifi')
                                          ? const Icon(
                                              Icons.wifi,
                                              size: 24,
                                              color: AppColors.primary,
                                            )
                                          : const Icon(
                                              Icons.coffee,
                                              size: 24,
                                              color: AppColors.primary,
                                            ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Text(
                              widget.room?.termFeatures?[index].title ?? '',
                              style: const TextStyle(
                                  fontFamily: "rubic",
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.0),
                            ),
                          ),
                        ],
                      ),
                      /*Row(children: [
                        const Icon(Icons.person, size: 24, color:AppColor.activeColor ,),
                        const SizedBox(width: 5,),
                        Expanded(
                          child: Text(
                            'Max People ${model!.row!.maxPeople} ',
                            style:const TextStyle(
                                fontFamily: "open-sans",
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 14.0),
                          ),
                        ),

                      ],),*/
                    ],
                  );
                }),
              ),
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.only(top: 20.0, left: 20.0),
              child: Text(
                'Information',
                style: TextStyle(
                    fontFamily: "rubic",
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700),
                textAlign: TextAlign.justify,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color:
                                  AppColors.faqanswerColor.withOpacity(0.5))),
                      child: const ImageIcon(
                          AssetImage('assets/icons/roomSize.png')),
                    ),
                    SizedBox(
                        width: 60,
                        child: Html(data: widget.room?.sizeHtml ?? '')),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color:
                                  AppColors.faqanswerColor.withOpacity(0.5))),
                      child: const Icon(Icons.bed),
                    ),
                    SizedBox(
                        width: 30,
                        child: Html(data: widget.room?.bedsHtml ?? '')),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color:
                                  AppColors.faqanswerColor.withOpacity(0.5))),
                      child: const Icon(Icons.people_alt),
                    ),
                    SizedBox(
                        width: 30,
                        child: Html(data: widget.room?.adultsHtml ?? '')),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color:
                                  AppColors.faqanswerColor.withOpacity(0.5))),
                      child: const Icon(Icons.boy),
                    ),
                    SizedBox(
                        width: 30,
                        child: Html(data: widget.room?.childrenHtml ?? '')),
                  ],
                ),
              ],
            ),

            Container(
              height: 0.5,
              width: double.infinity,
              color: Colors.black12.withOpacity(0.2),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 20.0, right: 20.0, left: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Price',
                    style: TextStyle(
                        fontFamily: "rubic",
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    "\u{20B9}" + '${widget.room?.totalPriceInString}',
                    style: const TextStyle(
                        fontFamily: "rubic",
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),

            /// Button
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, bottom: 10.0, top: 20.0),
              child: InkWell(
                onTap: () async {
                  addToCartRoom(
                      widget.room?.id.toString() ?? "",
                      widget.room?.image ?? "",
                      widget.room?.title ?? "",
                      widget.room!);
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
                  //  addToCartRoom();
                },
                child: Container(
                  height: 55.0,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      color: AppColors.primary
                      // gradient: LinearGradient(
                      //     colors: [
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
                      'Book Now',
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
          ],
        ),
      ),
    );
  }

  String? ulr;
  Future<void> addToCartRoom(
      String roomId, String img, String title, Room rooms) async {
    print("gopl-------------");
    var param = {
      'service_type': 'hotel',
      'service_id': '${widget.idD}',
      'rooms': '[{"id":"${roomId}","number_selected":"${room}"}]',
      'start_date':
          DateFormat('yyyy-MM-dd').format(DateTime.parse(checkInDate)),
      'end_date': DateFormat('yyyy-MM-dd').format(DateTime.parse(checkOutDate)),
      'adults': '${adultCount1}',
      'children': '${childrenCount1}',
      'room_amount': rooms.totalPriceInString ?? "0"
    };
    List<Map<String, String>> guestsList = [];
    for (int i = 0; i < adultCountList.length; i++) {
      Map<String, String> guestData = {
        'tot_adults[$i]': adultCountList[i].toString(),
        'tot_children[$i]': childrenCountList[i].toString(),
        'children_age[$i]': childrenCountListOfList[i].toString()
      };
      guestsList.add(guestData);
    }

    var data = addMapListToData(param, guestsList);
    apiBaseHelper.postAPICall(getAddToCartApi, data).then((value) {
      print("------aaa----------");
      log('${value}');

      var status = value['status'];
      var bookingCode = value['booking_code'];
      print(bookingCode);
      print(authToken);

      if (status.toString() == '1') {
        ulr = value['url'];
        //   https://hellostay.com/api/booking/02edafa5f093ff99fef7836b0963d2b0/checkout?token=39|0RQIduOQh5ZHasnEEJgYH2dtP3Hp1MOSPt1GtBA244f38060
        String neurl = ulr! + '?' + 'token=${authToken}';

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BookNowDetails(
                      imageUrl: img,
                      title: title,
                      bookingId: bookingCode,
                      rooms: rooms,
                    )));
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => WebViewExample(
        //           url: neurl,
        //         )));
      }
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

//  String? ulr ;
  // Future<void> addToCartRoom() async{
  //
  //   var param = {
  //     'service_type': 'hotel',
  //     'service_id': '${widget.idD}',
  //     'rooms': '[{"id":"${widget.room?.id}","number_selected":"${room}"}]',
  //     'start_date': DateFormat('yyyy-MM-dd').format(DateTime.parse(checkInDate)),
  //     'end_date': DateFormat('yyyy-MM-dd').format(DateTime.parse(checkOutDate)),
  //     'adults': '${adultCount1}',
  //     'children': '${childrenCount1}',
  //   };
  //   List<Map<String, String>> guestsList = [];
  //   for (int i = 0; i < adultCountList.length; i++) {
  //     Map<String, String> guestData = {
  //       'tot_adults[$i]': adultCountList[i].toString(),
  //       'tot_children[$i]': childrenCountList[i].toString(),
  //       'children_age[$i]': childrenCountListOfList[i].toString()
  //     };
  //     guestsList.add(guestData);
  //   }
  //
  //   var data = addMapListToData(param, guestsList);
  //    apiBaseHelper.postAPICall(getAddToCartApi, data).then((value) {
  //
  //      log('${value}');
  //
  //      var status = value['status'];
  //
  //      if(status.toString() == '1'){
  //
  //        ulr = value['url'];
  //     //   https://hellostay.com/api/booking/02edafa5f093ff99fef7836b0963d2b0/checkout?token=39|0RQIduOQh5ZHasnEEJgYH2dtP3Hp1MOSPt1GtBA244f38060
  //        String neurl = ulr!+'?'+'token=${authToken}';
  //        Navigator.push(context, MaterialPageRoute(builder: (context) =>  WebViewExample( url: neurl,)));
  //
  //      }
  //
  //    });
  // }
  //
  //  Map<String, String> addMapListToData(
  //      Map<String, String> data, List<Map<String, dynamic>> mapList) {
  //    for (var map in mapList) {
  //      map.forEach((key, value) {
  //        data[key] = value;
  //      });
  //    }
  //    return data;
  //  }
}
