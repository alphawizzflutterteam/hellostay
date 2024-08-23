import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hellostay/screens/Hotel/hotel_list_View.dart';
import 'package:hellostay/utils/globle.dart';
import 'package:http/http.dart' as http;
import '../../constants/colors.dart';

class AddBankDetails extends StatefulWidget {
  const AddBankDetails({Key? key}) : super(key: key);

  @override
  State<AddBankDetails> createState() => _AddBankDetailsState();
}

class _AddBankDetailsState extends State<AddBankDetails> {
  TextEditingController ifscCodeController = TextEditingController();
  TextEditingController AccountNoController = TextEditingController();
  TextEditingController BankNameController = TextEditingController();
  TextEditingController AccountHolderNameController = TextEditingController();
  TextEditingController AmountController = TextEditingController();
  TextEditingController AmountController1 = TextEditingController();
  TextEditingController upiIdController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();

  show(int i) {
    switch (i) {
      case 1:
        return Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                height: 55,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.supportColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: AmountController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '   Enter Amount';
                    }

                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10, bottom: 3),
                    // isDense: true,
                    border: InputBorder.none,
                    hintText: ' Enter Amount',
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 55,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.supportColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  controller: BankNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '   Enter Bank Name';
                    }

                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10, bottom: 3),
                    // isDense: true,
                    border: InputBorder.none,
                    hintText: ' Bank Name',
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 55,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.supportColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  controller: AccountHolderNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '   Enter Account Holder  Name';
                    }

                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10, bottom: 3),
                    // isDense: true,
                    border: InputBorder.none,
                    hintText: '  Account Holder Name',
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 55,
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.supportColor),
                    borderRadius: BorderRadius.circular(10)),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: AccountNoController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '     Enter Account Number';
                    }
                    // else if (value.length < 10 || value.length > 10) {
                    //   return '     Enter Valid Mobile Number';
                    // }
                    return null;
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10, bottom: 3),
                      // isDense: true,
                      border: InputBorder.none,
                      hintText: '  Account Number'
                      // label: Text('   Number'),
                      // border: OutlineInputBorder(
                      //   borderRadius: BorderRadius.circular(15),
                      // ),
                      ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 55,
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.supportColor),
                    borderRadius: BorderRadius.circular(10)),
                child: TextFormField(
                  //keyboardType: TextInputType.number,
                  controller: ifscCodeController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '     Enter IFSC  CODE';
                    }
                    // else if (value.length < 10 || value.length > 10) {
                    //   return '     Enter Valid Mobile Number';
                    // }
                    return null;
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10, bottom: 3),
                      // isDense: true,
                      border: InputBorder.none,
                      hintText: '  IFSC CODE'
                      // label: Text('   Number'),
                      // border: OutlineInputBorder(
                      //   borderRadius: BorderRadius.circular(15),
                      // ),
                      ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : InkWell(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          withdrawalApi();
                        }
                      },
                      child: Container(
                        height: 50,
                        width: 200,
                        decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                            child: isLoading
                                ? CircularProgressIndicator()
                                : Text(
                                    "SUBMIT",
                                    style: TextStyle(
                                        color: AppColors.white,
                                        fontSize: 16,
                                        fontFamily: "rubic"),
                                  )),
                      ),
                    )
            ],
          ),
        );
        break;

      case 2:
        return Form(
          key: _formKey1,
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                height: 55,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.supportColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: AmountController1,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '   Enter Amount';
                    }

                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10, bottom: 3),
                    // isDense: true,
                    border: InputBorder.none,
                    hintText: ' Enter Amount',
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 55,
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.supportColor),
                    borderRadius: BorderRadius.circular(10)),
                child: TextFormField(
                  //keyboardType: TextInputType.number,
                  controller: upiIdController,
                  // controller:ifscCodeController,

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '     Enter UPI ID';
                    }
                    // else if (value.length < 10 || value.length > 10) {
                    //   return '     Enter Valid Mobile Number';
                    // }
                    return null;
                  },

                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10, bottom: 3),
                      // isDense: true,
                      border: InputBorder.none,
                      hintText: '  UPI ID'
                      // label: Text('   Number'),
                      // border: OutlineInputBorder(
                      //   borderRadius: BorderRadius.circular(15),
                      // ),
                      ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : InkWell(
                      onTap: () {
                        if (_formKey1.currentState!.validate()) {
                          withdrawalApi();
                        }
                      },
                      child: Container(
                        height: 50,
                        width: 200,
                        decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                            child: Text(
                          "SUBMIT",
                          style: TextStyle(
                              color: AppColors.white,
                              fontSize: 16,
                              fontFamily: "rubic"),
                        )),
                      ),
                    )
            ],
          ),
        );
    }
  }

  bool isLoading = false;
  withdrawalApi() async {
    isLoading = true;
    setState(() {});
    String upiIdDeatils = 'UPI Id: ${upiIdController.text}';
    String bankDetils =
        'Banke Name: ${BankNameController.text}, Account Holder Name: ${AccountHolderNameController.text}, Account Number: ${AccountNoController.text},IFSC Code: ${ifscCodeController.text}';
    var headers = {'Authorization': 'Bearer ${authToken}'};
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://hellostay.com/api/auth/add-wallet-request'));
    request.fields.addAll({
      'amount':
          selectedOption == 1 ? AmountController.text : AmountController1.text,
      'description': selectedOption == 1 ? bankDetils : upiIdDeatils
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // print(await response.stream.bytesToString());
      var result = await response.stream.bytesToString();
      print("withdrawal money api-----");
      var finaResult = jsonDecode(result);

      if (finaResult['status'] == '1') {
        Fluttertoast.showToast(msg: "${finaResult['message']}");
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(msg: "${finaResult['message']}");
        Navigator.pop(context);
      }
      isLoading = false;
      setState(() {});
    } else {
      print("cccc-----");
      print(response.reasonPhrase);
    }
  }

  int selectedOption = 1;
  bool option1Selected = true;
  bool option2Selected = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.whiteTemp,
            title: const Text(
              'Add Bank Details',
              style: TextStyle(
                  fontFamily: "rubic", fontSize: 20.0, color: AppColors.white),
            )),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile(
                        title: Text(
                          'BANK',
                          style: TextStyle(
                            fontFamily: "rubic",
                            fontSize: 16,
                          ),
                        ),
                        value: 1,
                        groupValue: selectedOption,
                        activeColor: AppColors.primary,
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value!;
                          });
                        },
                        selected: selectedOption == 1,
                      ),
                    ),
                    Expanded(
                      child: RadioListTile(
                        title: Text('UPI',
                            style: TextStyle(
                              fontFamily: "rubic",
                              fontSize: 16,
                            )),
                        value: 2,
                        groupValue: selectedOption,
                        activeColor: AppColors.primary,
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value!;
                          });
                        },
                        selected: selectedOption == 2,
                      ),
                    ),
                  ],
                ),
                // Show additional content based on selectedOption
                if (selectedOption != null) show(selectedOption),
              ],
            ),
          ),
        ));
  }
}
