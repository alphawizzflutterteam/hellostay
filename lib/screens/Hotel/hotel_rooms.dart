import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hellostay/model/hotel_detail_response.dart';
import 'package:hellostay/repository/apiConstants.dart';
import 'package:hellostay/repository/apiStrings.dart';
import 'package:hellostay/screens/Hotel/room_review.dart';
import 'package:hellostay/utils/Webviewexample.dart';
import 'package:hellostay/utils/globle.dart';
import 'package:intl/intl.dart';

import '../../constants/colors.dart';
import '../../utils/traver_tile.dart';
import '../../widgets/room_widget.dart';
import 'BookNowDetails.dart';
import 'homeView.dart';

class HotelRooms extends StatefulWidget {
  String? price;
  // final String  rooms;
  List<String>? photoD = [];

  List<Room>? rooms;
  final String? idD;

  HotelRooms({Key? key, this.rooms, this.idD, this.photoD, this.price})
      : super(key: key);

  @override
  State<HotelRooms> createState() => _HotelRoomsState();
}

class _HotelRoomsState extends State<HotelRooms> {
  String? selectedRoomId;
  String? reviewPrice;
  List<dynamic> list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // rooms = widget.rooms1;
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
              'Room Details',
              style: TextStyle(
                  fontFamily: "rubic",
                  fontSize: 20.0,
                  color: AppColors.blackTemp),
            ),
          ),
        ),
        body: roomsWidget());
  }

  var key1 = GlobalKey();
  Widget roomsWidget() {
    return SingleChildScrollView(
      key: key1,
      //  scrollDirection: Axis.horizontal,
      child: Column(
        children: List.generate(widget.rooms?.length ?? 0, (index) {
          var item = widget.rooms![index];
          print("bbbb${widget.rooms![index].doubleOccupancyPrice}");

          return FeatureItem(
            data: item,
            onTapFavorite: () {
              item?.isFavorite = !(item.isFavorite ?? false);
              setState(() {});
            },
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RoomReview(
                        room: item, idD: widget.idD, photoD: widget.photoD),
                  ));
            },
            onTapBook: () {
              addToCartRoom(item?.id.toString() ?? '', item.image ?? "",
                  item.title ?? "", widget.rooms![index]);
              print("price---");
              print(widget.rooms![index].totPriceText ?? "");
            },
          );
        }),
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
      var msg = value['message'];

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
      } else
        Fluttertoast.showToast(msg: msg);
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

// Widget card(List<dynamic> rooms) {
  //   return SizedBox(
  //     width: MediaQuery.of(context).size.width,
  //     height: 500,
  //     child: ListView.builder(
  //         scrollDirection: Axis.horizontal,
  //         shrinkWrap: true,
  //         primary: false,
  //         itemCount: rooms.length,
  //         itemBuilder: (context, i) {
  //           //List<String> photo = List.from(list[i].data()['photo']);
  //           // List<String> service = List.from(list[i].data()['service']);
  //           // List<String> description = List.from(list[i].data()['description']);
  //           String title = rooms[i].ris?.first.rc ?? '';
  //           // String type = list[i].data()['type'].toString();
  //           double rating = 4.5;
  //           String des = rooms[i].ris?.first.des ?? '';
  //           // String image =
  //           //     'https://media-cdn.tripadvisor.com/media/photo-m/1280/21/dc/28/e0/fortune-pandiyan-hotel.jpg';
  //           num? price = rooms[i].ris?.first.tp ?? 150;
  //           bool isSelected = rooms[i].isSelected ?? false;
  //           String roomId = rooms[i].id ?? '';
  //           //String hotelId = hotelDetailsResponse?.hotel?.id ?? '' ;
  //           //num latLang1 = list[i].data()['latLang1'];
  //           // num latLang2 = list[i].data()['latLang2'];
  //
  //           return Card(
  //             child: Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: Column(
  //                 //mainAxisAlignment: MainAxisAlignment.start,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: <Widget>[
  //                   SizedBox(
  //                     width: 250,
  //                     child: Text(
  //                       title,
  //                       style: const TextStyle(
  //                           fontFamily: "rubic",
  //                           fontWeight: FontWeight.w600,
  //                           fontSize: 17.0,
  //                           color: Colors.black87),
  //                     ),
  //                   ),
  //                   const SizedBox(
  //                     height: 2.0,
  //                   ),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.start,
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: <Widget>[
  //                       const Icon(
  //                         Icons.location_on,
  //                         size: 18.0,
  //                         color: Colors.black12,
  //                       ),
  //                       SizedBox(
  //                         width: MediaQuery.of(context).size.width / 1.7,
  //                         child: Text(
  //                           des,
  //                           style: const TextStyle(
  //                               fontFamily: "rubic",
  //                               fontWeight: FontWeight.w500,
  //                               fontSize: 15.0,
  //                               color: Colors.black26),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   Expanded(
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       crossAxisAlignment: CrossAxisAlignment.center,
  //                       children: <Widget>[
  //                         const Icon(
  //                           Icons.star,
  //                           size: 18.0,
  //                           color: Colors.yellow,
  //                         ),
  //                         Padding(
  //                           padding: const EdgeInsets.only(top: 3.0),
  //                           child: Text(
  //                             rating.toString(),
  //                             style: const TextStyle(
  //                                 fontWeight: FontWeight.w700,
  //                                 fontFamily: "rubic",
  //                                 fontSize: 13.0),
  //                           ),
  //                         ),
  //                         const SizedBox(
  //                           width: 35.0,
  //                         ),
  //                         Container(
  //                           height: 27.0,
  //                           width: 82.0,
  //                           decoration: const BoxDecoration(
  //                               color: Color(0xFF09314F),
  //                               borderRadius:
  //                               BorderRadius.all(Radius.circular(20.0))),
  //                           child: Center(
  //                             child: Text("\u{20B9} " + price.toString(),
  //                                 style: const TextStyle(
  //                                     color: Colors.white,
  //                                     fontWeight: FontWeight.w500,
  //                                     fontSize: 13.0)),
  //                           ),
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                   const SizedBox(
  //                     height: 10,
  //                   ),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     crossAxisAlignment: CrossAxisAlignment.end,
  //                     children: [
  //                       InkWell(
  //                         onTap: () {
  //                           /*Navigator.push(
  //                               context,
  //                               MaterialPageRoute(
  //                                 builder: (context) => CancellationPolicyView(
  //                                   hotelId: hotelId,
  //                                   optionId: roomId,
  //                                 ),
  //                               ));*/
  //                         },
  //                         child: const Text(
  //                           'Cancellation Policy ',
  //                           style: TextStyle(
  //                               fontFamily: "rubic",
  //                               fontWeight: FontWeight.w600,
  //                               decoration: TextDecoration.underline,
  //                               fontSize: 12.0,
  //                               color: Colors.black87),
  //                         ),
  //                       ),
  //                       const SizedBox(
  //                         width: 50,
  //                       ),
  //                       InkWell(
  //                         onTap: () {
  //                           setState(() {
  //                             rooms.forEach((element) {
  //                               element.isSelected = false;
  //                             });
  //                             rooms[i].isSelected = true;
  //
  //                             selectedRoomId = rooms[i].id ?? '';
  //
  //                             reviewPrice =
  //                                 rooms[i].ris?.first.tp.toString() ?? '';
  //                             list = rooms[i].ris ?? [];
  //                           });
  //                         },
  //                         child: Row(
  //                           children: [
  //                             const Text(
  //                               'Select room',
  //                               style: TextStyle(
  //                                   fontFamily: "rubic",
  //                                   fontWeight: FontWeight.w600,
  //                                   fontSize: 16.0,
  //                                   color: Colors.black87),
  //                             ),
  //                             const SizedBox(
  //                               width: 8,
  //                             ),
  //                             Container(
  //                               padding: EdgeInsets.all(1),
  //                               height: 15,
  //                               width: 15,
  //                               decoration: BoxDecoration(
  //                                   shape: BoxShape.circle,
  //                                   border: Border.all(color: Colors.grey)),
  //                               child: Container(
  //                                 decoration: BoxDecoration(
  //                                     shape: BoxShape.circle,
  //                                     color: isSelected
  //                                         ? AppColors.primary
  //                                         : Colors.transparent),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       )
  //                     ],
  //                   )
  //                 ],
  //               ),
  //             ),
  //           );
  //         }),
  //   );
  // }
}
