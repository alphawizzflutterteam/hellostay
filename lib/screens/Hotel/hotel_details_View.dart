import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hellostay/constants/colors.dart';
import 'package:hellostay/model/hotel_detail_response.dart';
import 'package:hellostay/repository/apiConstants.dart';
import 'package:hellostay/repository/apiStrings.dart';
import 'package:hellostay/screens/Hotel/hotel_rooms.dart';
import 'package:hellostay/screens/Hotel/room_review.dart';
import 'package:hellostay/utils/gallery_Screen.dart';
import 'package:hellostay/utils/globle.dart';
import 'package:hellostay/utils/traver_tile.dart';
import 'package:hellostay/widgets/custom_app_button.dart';
import 'package:hellostay/widgets/room_widget.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:styled_text/tags/styled_text_tag.dart';
import 'package:styled_text/widgets/styled_text.dart';

import '../../utils/Webviewexample.dart';
import '../../utils/rating_bar.dart';
import 'homeView.dart';

class HotelDetailsScreen extends StatefulWidget {
  const HotelDetailsScreen({
    Key? key,
    this.imageD,
    this.titleD,
    this.priceD,
    this.locationD,
    this.idD,
    this.latLang1D,
    this.latLang2D,
    this.ratingD,
  }) : super(key: key);

  final String? imageD, titleD, locationD, idD, latLang1D, latLang2D;
  final num? ratingD, priceD;

  @override
  State<HotelDetailsScreen> createState() => _HotelDetailsScreenState();
}

class _HotelDetailsScreenState extends State<HotelDetailsScreen> {
  final Set<Marker> _markers = {};
  List<String>? photoD = [];
  List<String>? serviceD = [];
  List<String>? descriptionD = [];
  List<dynamic> rooms = [];
  List<bool> showAllList = [];
  bool showAll = false; // Add this variable to control visibility
  bool viewAll = false; // Add this variable to control visibility

  String? selectedRoomId;

  String? reviewPrice;
  bool more = false;

  List<dynamic> list = [];
  // bool showAll = false;
  // bool showAll2 = false;
  // bool showAll3 = false;

  bool flag = true;
  HotelDetailsResponse? hotelDetailsResponse;

//  bool showAll=false;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    getHotelDetail(widget.idD ?? '');

    setState(() {});
  }

  inIt() async {
    await getHotelDetail(widget.idD ?? '');
    // serviceD = api.hotelDetailsResponse?.hotel?.fl;
    /*api.hotelDetailsResponse?.hotel?.img?.forEach((element) {
      photoD?.add(element.url ?? '');
    });*/

    //descriptionD?.add(api.hotelDetailsResponse?.hotel?.des ?? '');
  }

  Widget commonImage(
    url, {
    double? height,
    double? width,
    Color? color,
    BlendMode? colorBlendMode,
    placeHolder,
    context,
    errorImage,
  }) {
    return CachedNetworkImage(
      imageUrl: url,
      height: height,
      width: width,
      fit: BoxFit.fill,
      color: color,
      colorBlendMode: colorBlendMode,
      placeholder: (context, url) {
        return Container(
          height: height,
          width: width,
          color: Colors.grey.withOpacity(0.2),
          child: Center(
              child: Icon(
            Icons.photo,
            color: Colors.grey,
          )),
        );
      },
      errorWidget: (context, url, error) {
        return Container(
          height: height,
          width: width,
          color: Colors.grey.withOpacity(0.2),
          child: Center(
              child: Icon(
            Icons.error,
            color: Colors.grey,
          )),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var _location = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
              top: 0.0, left: 20.0, right: 20.0, bottom: 10.0),
          child: Text(
            widget.locationD ?? '',
            style: const TextStyle(
                fontFamily: "rubic",
                fontSize: 20.0,
                fontWeight: FontWeight.w700),
            textAlign: TextAlign.justify,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Stack(
            children: <Widget>[
              SizedBox(
                height: 190.0,
                child: hotelDetailsResponse?.data.mapLng!=null? GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(double.parse( hotelDetailsResponse?.data.mapLat?? '' ),
                        double.parse( hotelDetailsResponse?.data.mapLng?? '0.0')),
                    zoom: 13.0,
                  ),
                  markers: _markers,
                ): Center(
                  child: Container(
                      width: 50,
                      height: 50,
                      child: const CircularProgressIndicator(
                        //strokeWidth: 2,

                        color: AppColors.primary,
                      )),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 135.0, right: 60.0),
              //   child: Align(
              //     alignment: Alignment.bottomRight,
              //     child: InkWell(
              //       onTap: () {
              //         Navigator.of(context).push(PageRouteBuilder(
              //             pageBuilder: (_, __, ___) => maps()));
              //       },
              //       child: Container(
              //         height: 35.0,
              //         width: 95.0,
              //         decoration: BoxDecoration(
              //             color: Colors.black12.withOpacity(0.5),
              //             borderRadius:
              //                 const BorderRadius.all(Radius.circular(30.0))),
              //         child: const Center(
              //           child: Text('seeMap',
              //               style: TextStyle(
              //                   color: Colors.white, fontFamily: "rubic")),
              //         ),
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ],
    );
    return Scaffold(
        bottomNavigationBar: InkWell(
          onTap: () {
            print('--------price -------${hotelDetailsResponse?.data?.price}');
         if(hotelDetailsResponse!.data.rooms!.length < 1)
           {
             Fluttertoast.showToast(msg: "No Rooms Available");
           }
         else
           {
             Navigator.push(
                 context,
                 MaterialPageRoute(
                     builder: (context) => HotelRooms(
                       rooms: hotelDetailsResponse?.data.rooms,
                       idD: widget.idD,
                       photoD: photoD,
                       price: hotelDetailsResponse?.data?.price,

                     )));
           }

            // Scrollable.ensureVisible(key1.currentContext!);

            setState(() {});
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 08, 20, 08),
            child: CustomButton(textt: 'Select Room'),
          ),
        ),
        body:  SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                  child: photoD != null
                      ? CarouselSlider(
                          options: CarouselOptions(
                              autoPlay: true,
                              viewportFraction: 1,
                              height: 200.0),
                          items: photoD?.map<Widget>((i) {
                            return commonImage(i, width: double.infinity);
                          }).toList(),
                        )
                      : SizedBox()
                  // SliverPersistentHeader(
                  //   delegate: MySliverAppBar(
                  //       expandedHeight: height - 30.0,
                  //       img: hotelDetailsResponse?.data.image ?? '',
                  //       id: hotelDetailsResponse?.data.id.toString() ?? '',
                  //       title: hotelDetailsResponse?.data.title.toString() ?? '',
                  //       price: double.parse(hotelDetailsResponse?.data.price ?? '150'),
                  //       location: hotelDetailsResponse?.data.location?.name ?? '',
                  //       ratting: double.parse(
                  //           hotelDetailsResponse?.data.reviewScore?.scoreTotal ??
                  //               '4.5')),
                  //   pinned: true,
                  // ),
                  //
                  ),
              SliverToBoxAdapter(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            hotelDetailsResponse?.data.title ??
                                ""
                                    // model!.row!.title ?? "",
                                    "Hotel",
                            style: const TextStyle(
                              fontFamily: "rubic",
                             // fontFamily: "open-sans",
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                              //color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 16,
                          ),
                          const Icon(
                            Icons.location_on_outlined,
                            color: Colors.black54,
                            size: 25,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Text(
                              // model!.row!.location?.name ?? '',
                              // "Indore",
                              hotelDetailsResponse?.data.address ?? "",
                              //overflow: TextOverflow.clip,
                              //maxLines: 1,
                              style:  TextStyle(
                               // fontFamily: "open-sans",
                                fontSize: 12.0,
                                fontFamily: "rubic",
                                fontWeight: FontWeight.w400,
                                color: Colors.black54,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: 20,
                          ),
                          IgnorePointer(
                            ignoring: true,
                            child: RatingBar.builder(
                              initialRating: hotelDetailsResponse
                                      ?.data!.starRate
                                      ?.toDouble() ??
                                  0.0,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: false,
                              itemCount: 5,
                              itemSize: 12.0,
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate:
                                  (_) {}, // Provide an empty function to disable editing
                            ),
                          )

                          // const Icon(
                          //   Icons.star,
                          //   color: Colors.green,size: 10,
                          // ),const Icon(
                          //   Icons.star,
                          //   color: Colors.green,size: 10,
                          // ),const Icon(
                          //   Icons.star,
                          //   color: Colors.green,size: 10,
                          // ),const Icon(
                          //   Icons.star,
                          //   color: Colors.green,size: 10,
                          // ),const Icon(
                          //   Icons.star,
                          //   color: Colors.green,size: 10,
                          // ),

                          ,
                          const SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            'Total Review ${hotelDetailsResponse?.data!.starRate?.toDouble() ?? 0.0} ',
                            style: const TextStyle(
                                fontFamily: "rubic",
                                color: Colors.black54,
                                fontSize: 12),
                          )
                        ],
                      ),
                      const Divider(),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                    /*StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.userId)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return new Text("Loading");
                        } else {
                          var userDocument = snapshot.data;
                          _nama = userDocument["name"];
                          _email = userDocument["email"];
                          _photoProfile = userDocument["photoProfile"];
                        }

                        var userDocument = snapshot.data;
                        return Container();
                      },
                    ),*/

                    /// Description
                    const Padding(
                      padding: EdgeInsets.only(
                          top: 20.0, left: 20.0, right: 20.0, bottom: 10.0),
                      child: Text(
                        'About the Hotel',
                        style: TextStyle(
                            fontFamily: "rubic",
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 0.0, left: 20.0, right: 20.0, bottom: 0.0),
                      child: Column(
                        children: [
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List<Widget>.generate( !viewAll ? 0 :descriptionD?.length ?? 0, (index) {
                                var item = descriptionD?[index];
                                return Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10.0, left: 10.0, bottom: 10.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.3,
                                              child: StyledText(
                                                text: item!.replaceAll("</p>", "\n"),
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: "rubic",
                                                  color: Colors.black54,
                                                ),
                                                tags: {
                                                  'h4': StyledTextTag(
                                                      style: const TextStyle(
                                                          fontFamily: "rubic",
                                                          fontSize: 16,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w700
                                                      )),
                                                  'li': StyledTextTag(
                                                      style: const TextStyle(
                                                        fontFamily: "rubic",
                                                        fontSize: 16,
                                                        color: Colors.black54,
                                                  //  fontStyle: FontStyle.italic,
                                                  )

                                                  ),
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                              })
                                  .toList()),
                          InkWell(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  !viewAll ? "...show more" : "...show less",
                                  style:
                                  const TextStyle(color: Colors.blue, fontFamily: 'rubic'),
                                ),
                              ],
                            ),
                            onTap: () {
                              setState(() {
                                viewAll = !viewAll;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                        const Padding(
                          padding: EdgeInsets.only(
                              top: 10.0, left: 20.0, right: 20.0, bottom: 10.0),
                          child: Text(
                            'Amenities',
                            style: TextStyle(
                                fontFamily: "rubic",
                                fontSize: 16.0,
                                fontWeight: FontWeight.w700),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        ///Amenities
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 0.0, left: 20.0, right: 20.0, bottom: 0.0),
                          child: Column(
                            children: [
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List<Widget>.generate(!showAll ? 1 : hotelDetailsResponse?.data.terms?.length ?? 0 , (index) {
                                    var item = hotelDetailsResponse?.data.terms?[index];

                                    return Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10.0, left: 10.0, bottom: 0.0),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item?.title ?? '',
                                          style: const TextStyle(
                                              fontFamily: "rubic",
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w700),
                                          textAlign: TextAlign.justify,
                                        ),
                                        Wrap(
                                          children: List<Widget>.generate(
                                            !showAll ? 4 : item?.child.length ?? 0,
                                                (index) {
                                              return Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    "-   ",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18.0,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                        1.3,
                                                    child: Text(
                                                      item?.child[index].title ?? '',
                                                      style: const TextStyle(
                                                        fontFamily: "rubic",
                                                        color: Colors.black54,
                                                        fontSize: 16.0,
                                                      ),
                                                      overflow:
                                                      TextOverflow.clip,
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                                                  );
                                  })
                                      .toList()),
                              InkWell(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      !showAll ? "...show more" : "...show less",
                                      style:
                                      const TextStyle(color: Colors.blue, fontFamily: 'rubic'),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    showAll = !showAll;
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                    /// Location
                    _location,



                    /// service



                    //
                    // const Padding(
                    //   padding:
                    //       EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
                    //   child: Text(
                    //     'Rooms',
                    //     style: TextStyle(
                    //         fontFamily: "rubic",
                    //         fontSize: 20.0,
                    //         fontWeight: FontWeight.w700),
                    //     textAlign: TextAlign.justify,
                    //   ),
                    // ),

                    // roomsWidget(),
                    // Padding(
                    //   padding: const EdgeInsets.only(
                    //       top: 40.0, left: 20.0, right: 20.0, bottom: 10.0),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       const Text(
                    //         'photos',
                    //         style: TextStyle(
                    //             fontFamily: "rubic",
                    //             fontSize: 20.0,
                    //             fontWeight: FontWeight.w700),
                    //         textAlign: TextAlign.justify,
                    //       ),
                    //       InkWell(
                    //         onTap: () {
                    //           Navigator.of(context).push(PageRouteBuilder(
                    //               pageBuilder: (_, __, ___) =>
                    //                   GalleryScreen(image: photoD ?? [])));
                    //         },
                    //         child: const Text(
                    //           'seeAll',
                    //           style: TextStyle(
                    //               fontFamily: "rubic",
                    //               color: Colors.black38,
                    //               fontSize: 16.0,
                    //               fontWeight: FontWeight.w600),
                    //           textAlign: TextAlign.justify,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    const Padding(
                      padding:
                          EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
                      child: Text(
                        'Hotel Rules - Policies',
                        style: TextStyle(
                            fontFamily: "rubic",
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700),
                        textAlign: TextAlign.justify,
                      ),
                    ),

                    rules(),

                    // roomes,

                    /*Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                    top: 0.0,
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text(
                          'Cancellation Policy',
                          style: TextStyle(
                              fontFamily: "rubic",
                              fontSize: 20.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w700),
                        ),
                        const Icon(Icons.arrow_forward_outlined),
                        InkWell(
                          onTap: () {
                            */ /* Navigator.of(context).push(PageRouteBuilder(
                                    pageBuilder: (_, __, ___) => questionSeeAll(
                                      title: widget.titleD,
                                      name: _nama,
                                      photoProfile: _photoProfile,
                                    )));*/ /*


                          },
                          child: const Text(
                            'View',
                            style: TextStyle(
                                fontFamily: "rubic",
                                color: Colors.black54,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ]),
                ),*/
                    const SizedBox(
                      height: 0.0,
                    ),
                    // Question
                    /* Column(
                      children: [
                        questionCard(
                        */ /*userId: widget.userId,
                        list: snapshot.data.docs*/ /*)
                      ],
                    ),*/

                    // Review
                    /*Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 25.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                        top: 0.0,
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Reviews',
                              style: TextStyle(
                                  fontFamily: "rubic",
                                  fontSize: 20.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(PageRouteBuilder(
                                    pageBuilder: (_, __, ___) =>
                                        ReviewScreen()));
                              },
                              child: Text(
                                'seeAll',
                                style: TextStyle(
                                    fontFamily: "rubic",
                                    color: Colors.black54,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ]),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Column(
                      children: [
                        ratingCard(
                          rattings: widget.ratingD.toString(),

                          */ /*userId: widget.userId,
                            list: snapshot.data.docs*/ /*
                        )
                      ],
                    ),
                    SizedBox(
                      height: 50.0,
                    )
                  ],
                ),*/

                    /// Button
                    /*Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, bottom: 10.0),
                  child: InkWell(
                    onTap: () async {
                      */ /*Navigator.of(context).push(PageRouteBuilder(
                              pageBuilder: (_, __, ___) => new Room(
                                userId: widget.userId,
                                titleD: widget.titleD,
                                idD: widget.idD,
                                imageD: widget.imageD,
                                latLang1D: widget.latLang1D,
                                latLang2D: widget.latLang2D,
                                locationD: widget.locationD,
                                priceD: widget.priceD,
                                descriptionD: widget.descriptionD,
                                photoD: widget.photoD,
                                ratingD: widget.ratingD,
                                serviceD: widget.serviceD,
                                typeD: widget.typeD,
                                emailD: _email,
                                nameD: _nama,
                                photoProfileD: _photoProfile,
                              )));*/ /*

                      if (selectedRoomId == null) {
                        Fluttertoast.showToast(msg: 'Please Select a room');
                      } else {
                        */ /*Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RoomReview(
                                titleD: widget.titleD,
                                roomType: selectedRoomId,
                                locationD: widget.locationD,
                                ratingD: widget.ratingD,
                                priceR: reviewPrice ?? '',
                                list: list,
                                idD: widget.idD,


                              ),
                            ));*/ /*
                      }
                    },
                    child: Container(
                      height: 55.0,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          gradient: LinearGradient(
                              colors: [
                                Colors.red,
                                Colors.redAccent,
                              ],
                              begin: FractionalOffset(0.0, 0.0),
                              end: FractionalOffset(1.0, 0.0),
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp)),
                      child: const Center(
                        child: Text(
                          'Review Now',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 19.0,
                              fontFamily: "rubic",
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ),*/
                  ]))
            ],
          ),
        ));
  }

  Widget rules() {
    return Padding(
      padding: const EdgeInsets.only(
          top: 10.0, left: 20.0, right: 20.0, bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Chick In',
            style: TextStyle(
                fontFamily: "rubic",
                color: Colors.black38,
                fontSize: 16.0,
                fontWeight: FontWeight.w400),
            textAlign: TextAlign.justify,
          ),
          Text(
            hotelDetailsResponse?.data.checkInTime ?? '',
            style: const TextStyle(
                fontFamily: "rubic",
                fontSize: 16.0,
                fontWeight: FontWeight.w700),
            textAlign: TextAlign.justify,
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'Chick Out',
            style: TextStyle(
              fontFamily: "rubic",
              color: Colors.black38,
              fontSize: 16.0,
            ),
            textAlign: TextAlign.justify,
          ),
          Text(
            hotelDetailsResponse?.data.checkOutTime ?? '',
            style: const TextStyle(
                fontFamily: "rubic",
                fontSize: 16.0,
                fontWeight: FontWeight.w700),
            textAlign: TextAlign.justify,
          ),
          flag
              ? const SizedBox(
                  height: 10,
                )
              : const SizedBox.shrink(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
                flag ? 1 : hotelDetailsResponse?.data.policy?.length ?? 0,
                (index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hotelDetailsResponse?.data.policy?[index].title ?? '',
                    style: const TextStyle(
                        fontFamily: "rubic",
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700),
                    textAlign: TextAlign.justify,
                  ),
                  Text(
                    hotelDetailsResponse?.data.policy?[index].content ??
                        '' ??
                        '',
                    style: const TextStyle(
                      fontFamily: "rubic",
                      color: Colors.black54,
                      fontSize: 16.0,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              );
            }),
          ),
          InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  flag ? "...show more" : "show less",
                  style:
                      const TextStyle(color: Colors.blue, fontFamily: 'rubic'),
                ),
              ],
            ),
            onTap: () {
              setState(() {
                flag = !flag;
              });
            },
          )
        ],
      ),
    );
  }

  var key1 = GlobalKey();
  Widget roomsWidget() {
    return SingleChildScrollView(
      key: key1,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(hotelDetailsResponse?.data.rooms?.length ?? 0,
            (index) {
          var item = hotelDetailsResponse?.data.rooms![index];

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
                    builder: (context) =>
                        RoomReview(room: item, idD: item?.id.toString()),
                  ));
            },
            onTapBook: () {
              addToCartRoom(item?.id.toString() ?? '');
            },
          );
        }),
      ),
    );
  }

  Widget card(List<dynamic> rooms) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 500,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          primary: false,
          itemCount: rooms.length,
          itemBuilder: (context, i) {
            //List<String> photo = List.from(list[i].data()['photo']);
            // List<String> service = List.from(list[i].data()['service']);
            // List<String> description = List.from(list[i].data()['description']);
            String title = rooms[i].ris?.first.rc ?? '';
            // String type = list[i].data()['type'].toString();
            double rating = 4.5;
            String des = rooms[i].ris?.first.des ?? '';
            // String image =
            //     'https://media-cdn.tripadvisor.com/media/photo-m/1280/21/dc/28/e0/fortune-pandiyan-hotel.jpg';
            num? price = rooms[i].ris?.first.tp ?? 150;
            bool isSelected = rooms[i].isSelected ?? false;
            String roomId = rooms[i].id ?? '';
            //String hotelId = hotelDetailsResponse?.hotel?.id ?? '' ;
            //num latLang1 = list[i].data()['latLang1'];
            // num latLang2 = list[i].data()['latLang2'];

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 250,
                      child: Text(
                        title,
                        style: const TextStyle(
                            fontFamily: "rubic",
                            fontWeight: FontWeight.w600,
                            fontSize: 17.0,
                            color: Colors.black87),
                      ),
                    ),
                    const SizedBox(
                      height: 2.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Icon(
                          Icons.location_on,
                          size: 18.0,
                          color: Colors.black12,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.7,
                          child: Text(
                            des,
                            style: const TextStyle(
                                fontFamily: "rubic",
                                fontWeight: FontWeight.w500,
                                fontSize: 15.0,
                                color: Colors.black26),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const Icon(
                            Icons.star,
                            size: 18.0,
                            color: Colors.yellow,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 3.0),
                            child: Text(
                              rating.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "rubic",
                                  fontSize: 13.0),
                            ),
                          ),
                          const SizedBox(
                            width: 35.0,
                          ),
                          Container(
                            height: 27.0,
                            width: 82.0,
                            decoration: const BoxDecoration(
                                color: Color(0xFF09314F),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0))),
                            child: Center(
                              child: Text("\u{20B9} " + price.toString(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13.0)),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            /*Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CancellationPolicyView(
                                    hotelId: hotelId,
                                    optionId: roomId,
                                  ),
                                ));*/
                          },
                          child: const Text(
                            'Cancellation Policy ',
                            style: TextStyle(
                                fontFamily: "rubic",
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                                fontSize: 12.0,
                                color: Colors.black87),
                          ),
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              rooms.forEach((element) {
                                element.isSelected = false;
                              });
                              rooms[i].isSelected = true;

                              selectedRoomId = rooms[i].id ?? '';

                              reviewPrice =
                                  rooms[i].ris?.first.tp.toString() ?? '';
                              list = rooms[i].ris ?? [];
                            });
                          },
                          child: Row(
                            children: [
                              const Text(
                                'Select room',
                                style: TextStyle(
                                    fontFamily: "rubic",
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.0,
                                    color: Colors.black87),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Container(
                                padding: EdgeInsets.all(1),
                                height: 15,
                                width: 15,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.grey)),
                                child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isSelected
                                          ? AppColors.primary
                                          : Colors.transparent),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }

  getHotelDetail(String idD) async {
    var params = {
      'start_date':
          DateFormat('yyyy-MM-dd').format(DateTime.parse(checkInDate)),
      'end_date': DateFormat('yyyy-MM-dd').format(DateTime.parse(checkOutDate)),
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
    var data = addMapListToData(params, guestsList);
    print('----------id=${idD}');
    print(data.toString());

    apiBaseHelper
        .postAPICall(Uri.parse('${baseUrl1}hotel/hotel-detail/$idD'), data)
        .then((getData) {
      print("aaaaaaaaaaaa");
      print(getData);
      log('${getData}');

      String status = getData['status'].toString();
     // String msg= getData['message'].toString();



      if (status == '1') {
        hotelDetailsResponse = HotelDetailsResponse.fromJson(getData);
        print("--------1-----------1----------");
        print(widget.idD);
        // print(hotelDetailsResponse?.data.related.);
        print("-------3--------------3");
        print(hotelDetailsResponse?.data?.price);
        print(hotelDetailsResponse?.data.gallery);


        hotelDetailsResponse?.data.gallery!.forEach((element) {
          photoD?.add(element ?? '');
        });
        descriptionD?.add(hotelDetailsResponse?.data.content ?? '');

        //rooms = hotelDetailsResponse?.hotel?.ops ?? [];
        rooms = [];

        _markers.add(Marker(
          // markerId: MarkerId(hotelDetailsResponse!.data.mapLat! +
          //     hotelDetailsResponse!.data.mapLng.toString()),
          // position: LatLng(
          //     double.parse(hotelDetailsResponse!.data.mapLat ?? ''),
          //     double.parse(hotelDetailsResponse!.data.mapLng ?? '')),
          markerId: MarkerId(hotelDetailsResponse!.data.mapLat! +
              hotelDetailsResponse!.data.mapLng.toString()),
          position: LatLng(
              double.parse(hotelDetailsResponse!.data.mapLat ?? ''),
              double.parse(hotelDetailsResponse!.data.mapLng ?? '')),
          icon: BitmapDescriptor.defaultMarker,
        ));
        // serviceD = hotelDetailsResponse?.hotel?.fl;

        showAllList = List.generate(
          (hotelDetailsResponse?.data.terms ?? []).length,
          (_) => false,
        );

        setState(() {});
      } else {
        // Fluttertoast.showToast(msg: msg);
      }
    });
  }

  String? ulr;
  Future<void> addToCartRoom(String roomId) async {
    print("kkkkkkkk111111");
    var param = {
      'service_type': 'hotel',
      'service_id': '${widget.idD}',
      'rooms': '[{"id":"${roomId}","number_selected":"${room}"}]',
      'start_date':
          DateFormat('yyyy-MM-dd').format(DateTime.parse(checkInDate)),
      'end_date': DateFormat('yyyy-MM-dd').format(DateTime.parse(checkOutDate)),
      'adults': '${adultCount1}',
      'children': '${childrenCount1}',
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
      log('${value}');

      var status = value['status'];

      if (status.toString() == '1') {
        ulr = value['url'];
        print("kkkkkkkk");
        print(ulr);
        //   https://hotelbooking.alphawizzserver.com/api/booking/02edafa5f093ff99fef7836b0963d2b0/checkout?token=39|0RQIduOQh5ZHasnEEJgYH2dtP3Hp1MOSPt1GtBA244f38060
        String neurl = ulr! + '?' + 'token=${authToken}';
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WebViewExample(
                      url: neurl,
                    )));
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
}

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;

  String img, id, title, location;
  num price;
  num ratting;

  MySliverAppBar(
      {required this.expandedHeight,
      required this.img,
      required this.id,
      required this.title,
      required this.price,
      required this.location,
      required this.ratting});

  var _txtStyleTitle = TextStyle(
    color: Colors.black54,
    fontFamily: "rubic",
    fontSize: 20.0,
    fontWeight: FontWeight.w800,
  );

  var _txtStyleSub = TextStyle(
    color: Colors.black26,
    fontFamily: "rubic",
    fontSize: 12.5,
    fontWeight: FontWeight.w600,
  );

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          height: 50.0,
          width: double.infinity,
          color: Colors.white,
        ),
        Align(
          alignment: Alignment.center,
          child: Image.asset(
            "assets/images/appLogo.png",
            height: (expandedHeight / 5) - (shrinkOffset / 40) + 24,
          ),
        ),
        Opacity(
          opacity: (1 - shrinkOffset / expandedHeight),
          child: Hero(
            tag: 'hero-tag-${id}',
            child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(img),
                ),
                shape: BoxShape.rectangle,
              ),
              child: Container(
                margin: const EdgeInsets.only(top: 620.0),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: FractionalOffset(0.0, 0.0),
                    end: FractionalOffset(0.0, 1.0),
                    stops: [0.0, 1.0],
                    colors: <Color>[
                      Color(0x00FFFFFF),
                      Color(0xFFFFFFFF),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Opacity(
            opacity: (1 - shrinkOffset / expandedHeight),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 20.0, right: 20.0, left: 20.0, bottom: 20.0),
              child: Container(
                height: MediaQuery.of(context).size.height / 4.2,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: Colors.white.withOpacity(0.85)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, right: 2.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                SizedBox(
                                    width: 205.0,
                                    child: Text(
                                      title,
                                      style: _txtStyleTitle.copyWith(
                                          fontSize: 27.0),
                                      overflow: TextOverflow.clip,
                                    )),
                                Padding(
                                  padding: const EdgeInsets.only(right: 13.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "\u{20B9} " + price.toStringAsFixed(0),
                                        style: TextStyle(
                                            fontSize: 22.0,
                                            color: Color(0xFF09314F),
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "Gotik"),
                                      ),
                                      Text('PER_NIGHT',
                                          style: _txtStyleSub.copyWith(
                                              fontSize: 11.0))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, right: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.star,
                                          color: Color(0xFF09314F),
                                          size: 22.0,
                                        ),
                                        Icon(
                                          Icons.star,
                                          color: Color(0xFF09314F),
                                          size: 22.0,
                                        ),
                                        Icon(
                                          Icons.star,
                                          color: Color(0xFF09314F),
                                          size: 22.0,
                                        ),
                                        Icon(
                                          Icons.star,
                                          color: Color(0xFF09314F),
                                          size: 22.0,
                                        ),
                                        Icon(
                                          Icons.star_half,
                                          color: Color(0xFF09314F),
                                          size: 22.0,
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Icon(
                                            Icons.location_on,
                                            size: 14.0,
                                            color: Colors.black26,
                                          ),
                                          Text(
                                            location,
                                            style: TextStyle(
                                                color: Colors.black26,
                                                fontSize: 14.5,
                                                fontFamily: "rubic",
                                                fontWeight: FontWeight.w400),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                      child: Container(
                          height: 35.0,
                          width: 35.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(40.0),
                            ),
                            color: Colors.white70,
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          )),
                    ))),
            SizedBox(
              width: 36.0,
            )
          ],
        ),
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

class questionCard extends StatelessWidget {
  final String? userId;

  questionCard({this.list, this.userId});

  final List? list;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0),
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          primary: false,
          itemCount: 1,
          itemBuilder: (context, i) {
            String pp = 'Photo Profile';
            String question = 'Detail question';
            String name = 'Name';
            String answer = 'Answer';
            String image = 'Image';
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    image: DecorationImage(
                        image: NetworkImage(
                            'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 15.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 100,
                    padding: EdgeInsets.only(
                        left: 15.0, top: 0.0, bottom: 15.0, right: 15.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20.0),
                        bottomLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                      color: Color(0xFF09314F).withOpacity(0.1),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(
                          name,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              fontSize: 18.0),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        image == "null"
                            ? Container(height: 1, width: 1)
                            : Container(
                                height: 150.0,
                                width: 150.0,
                                decoration: BoxDecoration(
                                    color: Colors.black12,
                                    image: DecorationImage(
                                        image: NetworkImage(image),
                                        fit: BoxFit.cover)),
                              ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Wrap(
                          children: [
                            Text(
                              'ask' + ": ",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                  fontSize: 15.5),
                            ),
                            Text(
                              question,
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black54,
                                  fontSize: 15.5),
                              overflow: TextOverflow.fade,
                            ),
                          ],
                        ),
                        SizedBox(height: 5.0),
                        Wrap(
                          children: [
                            Text(
                              'answer' + ": ",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                  fontSize: 15.5),
                            ),
                            Text(
                              answer,
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black54,
                                  fontSize: 15.5),
                              overflow: TextOverflow.fade,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          }),
    );
  }
}

class ratingCard extends StatelessWidget {
  final String? rattings;

  ratingCard({this.list, this.rattings});

  final List? list;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          primary: false,
          itemCount: 1,
          itemBuilder: (context, i) {
            String pp = 'Photo Profile';
            String review = 'Detail rating';
            String name = 'Name';
            String rating = rattings ?? '';
            return Padding(
              padding: const EdgeInsets.only(left: 0.0, right: 0.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 40.0,
                        width: 40.0,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          image: DecorationImage(
                              image: NetworkImage(
                                'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                              ),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 18.0),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.star,
                              size: 22.0,
                              color: Colors.yellow,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 3.0),
                              child: Text(
                                rating,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "rubic",
                                    fontSize: 16.0),
                              ),
                            ),
                            SizedBox(
                              width: 35.0,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 0.0, right: 0.0, top: 10.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width - 40,
                      padding: EdgeInsets.only(
                          left: 15.0, top: 15.0, bottom: 15.0, right: 15.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(30.0),
                          bottomLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                          topLeft: Radius.circular(30.0),
                        ),
                        color: Color(0xFF09314F).withOpacity(0.1),
                      ),
                      child: Text(
                        review,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.black54,
                            fontSize: 17.5),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
