import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hellostay/constants/colors.dart';
import 'package:hellostay/extentions/extentions.dart';
import 'package:hellostay/model/filtersModel.dart';
import 'package:hellostay/model/hotel_search_response.dart';
import 'package:hellostay/repository/apiConstants.dart';
import 'package:hellostay/screens/Hotel/hotel_details_View.dart';
import 'package:hellostay/screens/loginScreen.dart';
import 'package:hellostay/utils/date_function.dart';
import 'package:hellostay/utils/draggable_sheet.dart';
import 'package:hellostay/utils/filtersheet.dart';
import 'package:hellostay/utils/globle.dart';
import 'package:hellostay/utils/traver_tile.dart';
import 'package:hellostay/widgets/custom_app_button.dart';
import 'package:hellostay/widgets/select_date_widget.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../repository/apiStrings.dart';
import 'homeView.dart';

class HotelSearchScreen extends StatefulWidget {
  HotelSearchScreen(
      {Key? key,
      this.title,
      this.userId,
      this.checkIn,
      this.checkOut,
      this.adults,
      this.lat,
      this.long,
      this.address,
      this.children})
      : super(key: key);
  final String? title, userId;
  String? checkIn, checkOut, address, lat, long;

  final int? adults, children;

  @override
  State<HotelSearchScreen> createState() => _HotelSearchScreenState();
}

class _HotelSearchScreenState extends State<HotelSearchScreen> {
  var searchedHotel;

//  Api api = Api();

  var data;
  RangeValues _selectedRange =  RangeValues(100, 1000);
  RangeValues _selectedRangeStar = const RangeValues(0, 5);
  List<SelectedModel> selectedItems = [];

  @override
  void initState() {
    // TODO: implement initState.
    inIt();

    super.initState();
  }

  inIt() async {
    await getSearchedHotel();
    await getProductFilters( context);
  }

  @override
  Widget build(BuildContext context) {
    var appBar = PreferredSize(
      preferredSize: const Size.fromHeight(45.0),
      child: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(widget.title ?? '',
            style: const TextStyle(fontFamily: "rubic", color: Colors.black)),
      ),
    );

    var topAnaheim = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // const Padding(
        //   padding: EdgeInsets.only(left: 20.0, top: 30.0, right: 20.0),
        //   child: Text(
        //     'Top Choice',
        //     style: TextStyle(
        //         fontFamily: "rubic",
        //         fontSize: 16.0,
        //         ),
        //   ),
        // ),
        const SizedBox(height: 5.0),
        !loading?
        Container(
    color: Colors.grey.withOpacity(0.2),
            child: card(
          list: hotelList,
          /*dataUser: widget.userId,
            list: snapshot.data.docs,*/
        )): Center(child: CircularProgressIndicator()),
        const SizedBox(
          height: 25.0,
        ),
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                InkWell(
                    onTap: () async {
                      _showBottomSheetforDate(context);
                    },
                    child: Text(
                      '${widget.checkIn}',
                      style: TextStyle(color: AppColors.secondary,fontFamily: "rubic"),
                    )),
                const SizedBox(
                  width: 15,
                ),
                Container(
                    padding: const EdgeInsets.all(5),
                    color: AppColors.faqanswerColor.withOpacity(0.2),
                    child: const Icon(
                      Icons.compare_arrows,
                      size: 14,
                    )),
                const SizedBox(
                  width: 15,
                ),
                InkWell(
                  onTap: () {
                    _showBottomSheetforDate(context);
                  },
                  child: Text(
                    '${widget.checkOut}',
                    style: const TextStyle(color: AppColors.secondary,fontFamily: "rubic"),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  width: 2,
                  height: 20,
                  color: AppColors.faqanswerColor,
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    _showBottomSheetforDate(context);
                  },
                  child: Text(
                    '${room} rooms',
                    style: const TextStyle(color: AppColors.secondary,fontFamily: "rubic"),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                InkWell(
                  onTap: () {
                    _showBottomSheetforDate(context);
                  },
                  child: Text(
                    '${childrenCount1 + adultCount1} guest',
                    style: const TextStyle(color: AppColors.secondary,fontFamily: "rubic"),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                InkWell(
                  onTap: (){
                    _showBottomSheetforSorting( context);
                  },
                  child: Container(
                    width: 80,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          width: 2,
                            color: AppColors.faqanswerColor.withOpacity(0.5))),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text('Sort',style: TextStyle(fontFamily: "rubic"),),
                          Icon(
                            Icons.sort,
                            color: AppColors.faqanswerColor.withOpacity(0.5),

                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: false,
                    builder: (BuildContext context) {
                      return BottomSheetContent(
                        selectedRange: _selectedRange,
                        selectedItems: selectedItems,
                        onChangedRange: (newRange) {
                          setState(() {
                            _selectedRange = newRange;
                          });
                          getSearchedHotel();
                        },
                        onChangedItems: (newItems) {
                          print("+++++++++++++654654644");
                          print("${newItems.length}_______________");
                          setState(() {
                            selectedItems = newItems;
                          });
                          getSearchedHotel();
                          },

                        filterListt: filterModel,
                        selectedRangeStar: _selectedRangeStar,
                        onClearAll: (val){
                          if(val){
                            getSearchedHotel();
                          }
                        },
                      );
                    },
                  ),
                  child: Container(
                    width: 80,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          width: 2,
                            color: AppColors.faqanswerColor.withOpacity(0.5))),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text('Filters',style: TextStyle(fontFamily: "rubic"),),
                          Icon(
                            Icons.filter_list_outlined,
                            color: AppColors.faqanswerColor.withOpacity(0.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
            topAnaheim,
          ],
        ),
      ),
    );
  }

  List<HotelDataList> hotelList = [];
  bool loading = false;


  getSearchedHotel() async {
    try {
      setState(() {
        loading=true;
      });

      var params = {
        'start': '${widget.checkIn}',
        'end': '${widget.checkOut}',
        'price_range': '${_selectedRange.start.toInt()};${_selectedRange.end.toInt()}',
        'star_rate': '',
        'review_score': '',
        'map_lat': lat.toString(),
        'map_lgn': lng.toString(),
        'map_place': 'Near',
      };

      List<Map<String, String>> guestsList = [];
      List<Map<String, String>> guestsList1 = [];

      for (int i = 0; i < adultCountList.length; i++) {
        Map<String, String> guestData = {
          'adults[$i]': adultCountList[i].toString(),
          'children[$i]': childrenCountList[i].toString(),
          'children_age[$i]': childrenCountListOfList[i].toString()
        };
        guestsList.add(guestData);
      }


      var data = addMapListToData(params, guestsList);
      for (int i = 0; i < selectedItems.length; i++) {
        Map<String, String> guestData = {
          'terms[$i]': selectedItems[i].id.toString(),

        };
        guestsList1.add(guestData);
      }

      print('1111111111111${data}');

      var data1 = addMapListToData(data, guestsList1);

      print(data1);
      print("gggggggggggggg");

      apiBaseHelper.postAPICall(hotelSearch, data1).then((getData) {
        hotelList = HotelSearchResponse.fromJson(getData).data ?? [];
        print(hotelList);



        setState(() {

          loading=false;
        });
      });
    } catch (e) {
      setState(() {

        print('__${e}___________');
        isLoading = false;
      });
    } finally {
      /*setState(() {
        isLoading = false;
      });*/
    }
  }

  var hotelDetailsResponse;
  var hotelSearchListData;
  List<dynamic> hotels = [];
  bool isLoading = false;

  Map<String, String> addMapListToData(
      Map<String, String> data, List<Map<String, dynamic>> mapList) {
    for (var map in mapList) {
      map.forEach((key, value) {
        data[key] = value;
      });
    }
    return data;
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            color: const Color.fromRGBO(0, 0, 0, 0.001),
            child: GestureDetector(
              onTap: () {},
              child: const MyDraggableSheetState(),
            ),
          ),
        );
      },
    );
  }
  bool isCheckInSelected = false;

  bool isCheckOutSelected = false;
  void _showBottomSheetforDate(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      shape: const RoundedRectangleBorder(),
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState2) {
            return SingleChildScrollView(
              child: Container(
                //height: 800,
                color: const Color.fromRGBO(0, 0, 0, 0.001),
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 30,
                        height: 2,
                        color: AppColors.faqanswerColor,
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                              onTap: () async {
                                //String date = await selectDate(context);
                                await showCalanderDatePicker(context);

                                // checkInDate = date;
                                String date = checkInDate;
                                print(checkInDate +'sdjkfhshdfhshfsh');

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
                                print(checkInDate +'sdjkfhshdfhshfsh');

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
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     InkWell(
                      //         onTap: () async {
                      //           String date = await selectDate(context);
                      //
                      //           checkInDate = date;
                      //
                      //           formattedCheckInDate = DateFormat("dd MMM''yy")
                      //               .format(DateTime.parse(date));
                      //           checkInDayOfWeek =
                      //               DateFormat("EEEE").format(DateTime.parse(date));
                      //           setState2(() {
                      //
                      //           });
                      //
                      //         },
                      //         child: selectDateWidget('Check-in', checkInDayOfWeek,
                      //             formattedCheckInDate, true, context)),
                      //     const Icon(
                      //       Icons.nights_stay,
                      //       color: AppColors.faqanswerColor,
                      //     ),
                      //     InkWell(
                      //         onTap: () async {
                      //           String date = await selectDate(context);
                      //
                      //           checkOutDate = date;
                      //
                      //           formattedCheckOutDate = DateFormat("dd MMM''yy")
                      //               .format(DateTime.parse(date));
                      //           checkOutDayOfWeek =
                      //               DateFormat("EEEE").format(DateTime.parse(date));
                      //           setState2(() {
                      //
                      //           });
                      //         },
                      //         child: selectDateWidget('Check-out', checkOutDayOfWeek,
                      //             formattedCheckOutDate, true, context))
                      //   ],
                      // ),
                      TravelDetailsTile(),
                      InkWell(
                        onTap: () {
                            widget.checkIn = DateFormat('yyyy-MM-dd')
                                .format(DateTime.parse(checkInDate));
                            widget.checkOut = DateFormat('yyyy-MM-dd')
                                .format(DateTime.parse(checkOutDate));

                          Navigator.pop(context);

                          getSearchedHotel();
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 08, 20, 08),
                          child: CustomButton(textt: 'Update'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        );
      },
    );
  }
  List<FiltersModelDatum> filterModel = [];
  void _showBottomSheetforSorting(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      shape: const RoundedRectangleBorder(),
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context,setState1) {
            return SingleChildScrollView(
              child: Container(
                //height: 800,
                color: const Color.fromRGBO(0, 0, 0, 0.001),
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            width: 30,
                            height: 2,
                            color: AppColors.faqanswerColor,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'Sort by',
                          style: TextStyle(
                              fontFamily: "rubic",
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: sortList.length,
                          itemBuilder: (context, index) {
                            var item  = sortList[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: InkWell(
                              onTap: (){
                                sortList.forEach((element) {
                                  element.isSelected = false ;
                                });
                                item.isSelected = true ;

                                setState1((){});
                                if(item.titel == 'Low to high') {
                                  hotelList.sort((a, b) =>
                                      (double.parse(a.price ?? '0.0'))
                                          .compareTo(
                                              double.parse(b.price ?? '0.0')));
                                }else if(item.titel == 'High to low'){
                                  hotelList.sort((a, b) =>
                                      (double.parse(b.price ?? '0.0'))
                                          .compareTo(
                                          double.parse(a.price ?? '0.0')));
                                }else {
                                  hotelList.sort((a, b) =>
                                      (double.parse(b.reviewScore?.scoreTotal.toString() ?? '0.0'))
                                          .compareTo(
                                          double.parse(a.reviewScore?.scoreTotal.toString() ?? '0.0')));
                                }
                                Navigator.pop(context);
                                setState(() {});
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                Row(children: [
                                  Icon(item.icon),
                                  const SizedBox(width: 10,),
                                  Text(item.titel ?? '',style: const TextStyle(
                                      fontFamily: "rubic",
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w400),),
                                ],),
                                  item.isSelected ?? false ? const Icon(Icons.check): const SizedBox(),

                              ],),
                            ),
                          );
                        },)
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        );
      },
    );
  }

  Future<void> getProductFilters(BuildContext context) async {
    await filterListRequest(
        "${baseUrl1}hotel/filters")
        .then((value) {
      filterModel = value.data;

      setState(() {
        _selectedRange =  RangeValues(double.parse(filterModel[0].min.toString()) , double.parse(filterModel[0].max.toString()));
        print(_selectedRange);
      });
    }).onError((error, stackTrace) {
      print(error.toString() + "product filter error");
      print(stackTrace.toString() + "product filter error");
    });
  }

  Future<FiltersModel> filterListRequest(String api) async {
    final url = Uri.parse(api);

    final http.Response res;
    res = await http.get(url);

    print(res.body);
    var asn = await json.decode(res.body);

    return FiltersModel.fromJson(asn);
  }




  List<Sort> sortList =[
    Sort(icon: Icons.arrow_downward,titel: 'Low to high',isSelected: false),
    Sort(icon: Icons.arrow_upward,titel: 'High to low',isSelected: false),
    Sort(icon: Icons.score,titel: 'Review Score', isSelected: false),

  ];
}

class Sort {
  String? titel;
  IconData? icon;

  bool? isSelected;

  Sort({this.titel, this.icon, this.isSelected});
}

class card extends StatelessWidget {
  final String? dataUser;
  final List<HotelDataList>? list;

  card({this.dataUser, this.list});

  @override
  Widget build(BuildContext context) {
    return list?.isEmpty ?? true ? Center(
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height/4,),
          const Text('Hotel Not Found', style: TextStyle(fontFamily: 'rubic'),),
          SizedBox(height: MediaQuery.of(context).size.height/2.8,)
        ],
      ),
    ) :  ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      primary: false,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list?.length ?? 0,
      itemBuilder: (context, i) {
        //List<String> photo = List.from(list[i].data()['photo']);
        // List<String> service = List.from(list[i].data()['service']);
        // List<String> description = List.from(list[i].data()['description']);
        String title = list?[i].title ?? 'title';
        String type = list?[i].objectModel ?? 'title';
        // String type = list[i].data()['type'].toString();
        double rating = double.parse( list?[i].reviewScore?.scoreTotal.toString()?? '0');
        String location = list?[i].location?.name ?? 'location';
        /*  String image =
              'https://media-cdn.tripadvisor.com/media/photo-m/1280/21/dc/28/e0/fortune-pandiyan-hotel.jpg';*/
        String image = list?[i].image ?? '';
        String id = list?[i].id.toString() ?? '';
        String price = list?[i].price ?? '5000';
        //num latLang1 = list[i].data()['latLang1'];
        // num latLang2 = list[i].data()['latLang2'];

        return InkWell(
          onTap: (){
            if(authToken !=null && authToken != ''){
              Navigator.push(context, MaterialPageRoute(builder: (context) =>  HotelDetailsScreen(idD: id,),));
            }else{
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  const LoginPage(),));
            }


          },
          child: Container(
              color: AppColors.whiteTemp,
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Hero(
                  tag: 'hero-tag-${id}',
                  child: Container(
                    height: 180.0,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(image), fit: BoxFit.fill),
                        color: Colors.black12,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 5.0,
                              color: Colors.black12.withOpacity(0.1),
                              spreadRadius: 2.0)
                        ]),
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Text(
                  type.capitalize(),
                  style: const TextStyle(
                      fontFamily: "rubic",
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                      color: Colors.black38),
                ),
                Text(
                  title,
                  style: const TextStyle(
                      fontFamily: "rubic",
                      fontWeight: FontWeight.w700,
                      fontSize: 16.0,
                      color: Colors.black87),
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
                    Text(
                      location,
                      style: const TextStyle(
                          fontFamily: "rubic",
                          fontWeight: FontWeight.w600,
                          fontSize: 15.0,
                          color: Colors.black26),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    /*const Icon(
                      Icons.star,
                      size: 18.0,
                      color: Colors.yellow,
                    ),*/
                    Container(
                      color: Colors.green,
                      margin: const EdgeInsets.only(top: 3.0,left: 3,right: 3),
                      padding: const EdgeInsets.only(top: 3.0,left: 3,right: 3),
                      child: Text(
                        '$rating/5',
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontFamily: "rubic",
                            fontSize: 13.0, color: AppColors.whiteTemp),
                      ),
                    ),
                    const SizedBox(
                      width: 35.0,
                    ),
                    Container(
                     // height: 27.0,
                     // width: 82.0,
                      decoration: const BoxDecoration(
                         /// color: Color(0xFF09314F),
                          borderRadius: BorderRadius.all(Radius.circular(20.0))),
                      child: Center(
                        child: Column(children: [
                          Text("\u{20B9} $price",
                              style: const TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w700,fontFamily: 'rubic',
                                  fontSize: 16.0)),
                          Text('per night'),
                        ],),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },

    );
  }
}

class cardList extends StatelessWidget {
  final List<dynamic>? hotels;

  final _txtStyleTitle = const TextStyle(
    color: Colors.black87,
    fontFamily: "Gotik",
    fontSize: 17.0,
    fontWeight: FontWeight.w800,
  );

  final _txtStyleSub = const TextStyle(
    color: Colors.black26,
    fontFamily: "Gotik",
    fontSize: 12.5,
    fontWeight: FontWeight.w600,
  );

  cardList({
    this.hotels,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        primary: false,
        itemCount: hotels?.length ?? 0,
        itemBuilder: (context, i) {
          // List<String> photo = List.from(list[i].data()['photo']);
          //List<String> service = List.from(list[i].data()['service']);
          //List<String> description = List.from(list[i].data()['description']);
          String title = hotels?[i].name ?? '';
          // String type = list[i].data()['type'].toString();
          num rating = hotels?[i].rt ?? 4.5;
          String location = hotels?[i].ad?.city?.name ?? '';
          String image2 =
              'https://www.seleqtionshotels.com/content/dam/seleqtions/Connaugth/TCPD_PremiumBedroom4_1235.jpg/jcr:content/renditions/cq5dam.web.1280.1280.jpeg';
          String image = hotels?[i].img?.first.url ?? image2;
          String id = hotels?[i].id ?? '';
          num price = hotels?[i].pops?.first.tpc ?? 2000;
          String latLang1 = hotels?[i].gl?.ln ?? '';
          String latLang2 = hotels?[i].gl?.lt ?? '';

          return Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
            child: InkWell(
              onTap: () {
                /*Navigator.of(context).push( PageRouteBuilder(
                    pageBuilder: (_, __, ___) => HotelDetail2(
                          titleD: title,
                          idD: id,
                          imageD: image,
                          latLang1D: latLang1,
                          latLang2D: latLang2,
                          locationD: location,
                          priceD: price,
                          ratingD: rating,
                        ),
                    transitionDuration: const Duration(milliseconds: 600),
                    transitionsBuilder:
                        (_, Animation<double> animation, __, Widget child) {
                      return Opacity(
                        opacity: animation.value,
                        child: child,
                      );
                    }));*/
              },
              child: Container(
                height: 250.0,
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
                  Hero(
                    tag: 'hero-tag-${id}',
                    child: Material(
                      child: Container(
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
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  width: 210.0,
                                  child: Text(
                                    title,
                                    style: _txtStyleTitle,
                                    overflow: TextOverflow.ellipsis,
                                  )),
                              const Padding(padding: EdgeInsets.only(top: 5.0)),
                              Row(
                                children: <Widget>[
                                  /*ratingbar(
                                    starRating: rating.toDouble(),
                                    color: const Color(0xFF09314F),
                                  ),*/
                                  const Padding(
                                      padding: EdgeInsets.only(left: 5.0)),
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
                                    const Icon(
                                      Icons.location_on,
                                      size: 16.0,
                                      color: Colors.black26,
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(top: 3.0)),
                                    Text(location, style: _txtStyleSub)
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              FittedBox(
                                clipBehavior: Clip.antiAlias,
                                child: Text(
                                  "\$" + price.toStringAsFixed(0),
                                  style: const TextStyle(
                                      fontSize: 22.0,
                                      color: Color(0xFF09314F),
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Gotik"),
                                ),
                              ),
                              Text("per night",
                                  style: _txtStyleSub.copyWith(fontSize: 11.0))
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ]),
              ),
            ),
          );
        });
  }
}
