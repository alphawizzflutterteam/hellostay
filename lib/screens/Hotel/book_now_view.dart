import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hellostay/utils/sharedPreference.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

import 'hotel_booked_screen.dart';


class BookNowView extends StatefulWidget {
  const BookNowView({Key? key, this.bookingId, this.totalPayment, required this.passengerList}) : super(key: key);

 final String? bookingId, totalPayment;
// final List <HotelPassengerModel> passengerList ;
 final List <dynamic> passengerList ;


  @override
  State<BookNowView> createState() => _BookNowViewState();
}

class _BookNowViewState extends State<BookNowView> {
  List<String> title = ["Mr", "Mrs", "Ms"];
  late Razorpay _razorpay;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }
  @override
  Widget build(BuildContext context) {
    print('_____bookingId_____${widget.bookingId}_________');
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text('bookNow',
            style: TextStyle(fontFamily: "Sofia", color: Colors.black),
          ),
        ),
      body: Card(child: SingleChildScrollView(
        child: Column(children: [
          Column(
            children: [
              Column(
                children: [
                  Column(
                    children: widget.passengerList.map((e) {
                      int index =
                      widget.passengerList.indexWhere((element) => 'element.type!'.contains('e.type!'));
                      return Container(
                        margin: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(color: Colors.grey)),
                        child: ExpansionTile(
                          title: Text(
                            'e.type!',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          children: [
                            const Divider(),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0,
                                    ),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5.0),
                                        border: Border.all(color: Colors.grey)),
                                    child: DropdownButton<String>(
                                      focusColor: Colors.white,
                                      underline: SizedBox(),
                                      value: 'e.title',
                                      //elevation: 5,
                                      style: TextStyle(color: Colors.white),
                                      iconEnabledColor: Colors.black,
                                      iconSize: 20,
                                      items:
                                      title.map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        );
                                      }).toList(),
                                      hint: Text(
                                        "Title",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      onChanged: (String? value) {
                                        setState(() {
                                          widget.passengerList[index].title = value;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  flex: 3,
                                  child: TextFormField(
                                    onChanged: (String value) {
                                      setState(() {
                                        widget.passengerList[index].fName = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      isDense: true,
                                      labelText: "First Name",
                                      enabledBorder: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  flex: 3,
                                  child: TextFormField(
                                    onChanged: (String value) {
                                      setState(() {
                                        widget.passengerList[index].lName = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      labelText: "Last Name",
                                      isDense: true,
                                      enabledBorder: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: TextFormField(
                                onChanged: (String value) {
                                  setState(() {
                                    widget.passengerList[index].pan = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  labelText: "Pan No.",
                                  isDense: true,
                                  enabledBorder: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(),
                                ),
                              ),
                            ),


                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ],
          ),
           SizedBox(height: MediaQuery.of(context).size.height/2.7,),
          bottomButton()
        ],),
      ),),
    );
  }

  bottomButton(){

    return SizedBox(
      height: 150,
      child: Column(children: [
        Container(
          height: 0.5,
          width: double.infinity,
          color: Colors.black12.withOpacity(0.2),
        ),
        Padding(
          padding: const EdgeInsets.only(
              top: 20.0, right: 20.0, left: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'price',
                style: TextStyle(
                    fontFamily: "Sofia",
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700),
              ),
              Text(
                "\$" + '${widget.totalPayment}',
                style: const TextStyle(
                    fontFamily: "Sofia",
                    fontSize: 20.0,
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
              bool validate = true;

              for (int i = 0; i < widget.passengerList.length; i++) {
               // HotelPassengerModel element = widget.passengerList[i];
                var element = widget.passengerList[i];
                if (element.title == null) {
                  Fluttertoast.showToast(
                      msg:
                      "Please Enter ${element.type!} Title");
                  validate = false;
                  break;
                }
                if (element.fName == null) {
                  Fluttertoast.showToast(
                      msg:
                      "Please Enter ${element.type!} First Name");
                  validate = false;
                  break;
                }
                if (element.lName == null) {
                  Fluttertoast.showToast(
                      msg:
                      "Please Enter ${element.type!} Last Name");
                  validate = false;
                  break;
                }
                if (element.pan == null || element.pan?.length != 10) {
                  Fluttertoast.showToast(
                      msg:
                      "Please Enter valid ${element.type!} Pan");
                  validate = false;
                  break;
                }

              }
              if (!validate) {
                return;
              }else{
                openCheckout();
              }



            },
            child: Container(
              height: 55.0,
              width: double.infinity,
              decoration: const BoxDecoration(
                  borderRadius:
                  BorderRadius.all(Radius.circular(5.0)),
                  gradient: LinearGradient(
                      colors: [
                        Color(0xFF09314F),
                        Color(0xFF09314F),
                      ],
                      begin: FractionalOffset(0.0, 0.0),
                      end: FractionalOffset(1.0, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp)),
              child: const Center(
                child: Text(
                  'bookNow',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 19.0,
                      fontFamily: "Sofia",
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ),
      ],),
    );
  }
bool isLoading = false ;

  Future<void> bookHotel() async {
    isLoading = true;
    setState(() {

    });
    var headers = {
      'Content-Type': 'application/json',
      'apikey': 'apiKey'
    };
    List<Map> mapList = [];
    widget.passengerList.forEach((element) {
      Map param = {
        "ti": 'element.title',
        "fN": 'element.fName',
        "lN": 'element.lName',
        "pan": 'element.pan',
        "pt":'' //element.type!.split(" ")[0].toUpperCase(),
      };

      mapList.add(param);
    });


    var request =await
    http.post( Uri.parse('${'flightUrl'}oms/v1/hotel/book'),body:json.encode({
      "bookingId": widget.bookingId,
      "roomTravellerInfo": [
        {
          "travellerInfo": mapList
        }
      ],
      "deliveryInfo": {
        "emails": ["xyz@technogramsolccutions.com"],
        "contacts": ["12341267890"],
        "code": ["+91"]
      },
      "type": "HOTEL",
      "paymentInfos": [
        {"amount": widget.totalPayment}
      ]
    }),headers:  headers);




    print('${request.body}');
    print('${'flightUrl'}oms/v1/hotel/book');
    print('${request.statusCode}');
    var finalResult = json.decode(request.body);
    print('$finalResult');
    if (request.statusCode == 200) {

    //  final jsonResponse = HotelBookingResponse.fromJson(finalResult);
      finalBookingApi();
      setState(() {
      });
    } else {
      Fluttertoast.showToast(msg: finalResult['errors'][0]['message']);
      print(request.reasonPhrase);
    }
  }

finalBookingApi() async {
  String? token = App.localStorage.getString("token");
  var headers = {
    'apikey': '61075878cf0bfdc3-5b33-4da8-b4b0-355e77498f58',
    'Authorization': 'Bearer ${token}'
  };
  var request = http.MultipartRequest('POST', Uri.parse('${'baseUrl'}booking/addToCart'));
  request.fields.addAll({
    'service_type': 'hotel',
    'service_id': '1',
    'booking_id':widget.bookingId ?? "",
    'amount':widget.totalPayment ?? "500",
    'name': "",

  });
  print('_____request.fields_____${request.fields}_________');

  request.headers.addAll(headers);
  http.StreamedResponse response = await request.send();
  if (response.statusCode == 200) {
    print('______sssssssss____${response.statusCode}_________');
      var result  = await response.stream.bytesToString();
      var finalResult =  jsonDecode(result);

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HotelBookedScreen()));
  }
  else {
  print(response.reasonPhrase);
  }

}

  void openCheckout() async   {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userMobile = prefs.getString('mobile');
    String? userEmail = prefs.getString('email');

    double price1 = double.parse(widget.totalPayment ?? '');
    int price = price1.toInt();


    // if(totalValue == null || totalValue == ""){
    //   pricerazorpayy= cartModel!.getCartList!.total! * 100;
    // }
    // else{
    //   pricerazorpayy= int.parse(totalValue.toString()) * 100;
    // }
    var options = {
      'key': 'rzp_live_MmLFC6z5L7yGRk',
      'amount': price*100,
      'name': 'Assignment-assist',
      'description': 'Assignment-assist',
      'prefill': {'contact': '$userMobile', 'email': '$userEmail'},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    // RazorpayDetailApi();
    // Order_cash_ondelivery();
    bookHotel();
    Fluttertoast.showToast(
        msg: "Successful",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
    // Navigator.push(context, MaterialPageRoute(builder: (context)=>DashBoardScreen()));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Fluttertoast.showToast(
    //     msg: "ERROR: " + response.code.toString() + " - " + response.message!,
    //     toastLength: Toast.LENGTH_SHORT);


    Fluttertoast.showToast(
        msg: "Payment cancelled by user",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    bookHotel();
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!,
        toastLength: Toast.LENGTH_SHORT);
  }


}

