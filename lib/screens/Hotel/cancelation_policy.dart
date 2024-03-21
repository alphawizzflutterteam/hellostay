import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class CancellationPolicyView extends StatefulWidget {
  const CancellationPolicyView({Key? key, this.hotelId, this.optionId})
      : super(key: key);
  final String? hotelId, optionId;

  @override
  State<CancellationPolicyView> createState() => _CancellationPolicyViewState();
}

class _CancellationPolicyViewState extends State<CancellationPolicyView> {
  //HotelCancellationPolicyResponse? hotelCancellationPolicyResponse;
  dynamic? hotelCancellationPolicyResponse;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getHotelCancellationPolicy();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Cancellation ',
          style: TextStyle(
              fontFamily: "Sofia",
              fontSize: 19.0,
              color: Colors.black,
              fontWeight: FontWeight.w700),
        ),
      ),
      body: hotelCancellationPolicyResponse?.cancellationPolicy?.pd == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : hotelCancellationPolicyResponse?.cancellationPolicy?.pd?.isEmpty ??
                  false
              ? Center(
                  child: Text('Data Not Available'),
                )
              : ListView.builder(
                  itemCount: hotelCancellationPolicyResponse
                      ?.cancellationPolicy?.pd?.length,
                  itemBuilder: (context, index) {
                    var item = hotelCancellationPolicyResponse
                        ?.cancellationPolicy?.pd?[index];
                    return Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 150,
                                child: const Text(
                                  'Penalty starts from',
                                ),
                              ),
                              Text(
                                item?.fdt?.replaceRange(10, 11, ' \n Time ') ??
                                    'jhj',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 50,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: 150,
                                child: Text(
                                  'Penalty ends on',
                                ),
                              ),
                              Text(
                                  item?.tdt?.replaceRange(10, 11, '\n Time ') ??
                                      '',
                                  style: TextStyle(color: Colors.red)),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Penalty amount',
                              ),
                              Text(item?.am.toString() ?? '',
                                  style: TextStyle(color: Colors.red)),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  getHotelCancellationPolicy() async {
    var headers = {
      'Content-Type': 'application/json',
      'apikey': 'apiKey'
    };
    var request = http.Request(
        'POST', Uri.parse('${'flightUrl'}hms/v1/hotel-cancellation-policy'));
    request.body =
        json.encode({"id": widget.hotelId, "optionId": widget.optionId});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    print('${request.body}');

    if (response.statusCode == 200) {
      var finalResult = await response.stream.bytesToString();

      /*final jsonResponse =
          HotelCancellationPolicyResponse.fromJson(json.decode(finalResult));
*/
      //hotelCancellationPolicyResponse = jsonResponse;

     /* print(
          '${hotelCancellationPolicyResponse?.cancellationPolicy?.pd?.first.tdt} ___________');*/
    } else {
      print(response.reasonPhrase);
    }
  }
}
