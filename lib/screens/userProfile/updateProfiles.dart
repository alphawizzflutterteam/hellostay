import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hellostay/repository/apiConstants.dart';
import 'package:hellostay/utils/globle.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/colors.dart';
import 'package:http/http.dart' as http;

import '../../model/getProfineModel.dart';
import '../../widgets/loadingwidget.dart';


class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  var userimagedata;


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      bottomSheet: Padding(
          padding: const EdgeInsets.all(8),
          child: !isLoading2
              ? InkWell(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      updateProfileApi();
                    }
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Center(
                        child: Text('Update Profile',
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: "rubic",
                               // fontWeight: FontWeight.bold,
                                color: AppColors.white))),
                  ),
                )
              : SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: LoadingWidget(context),
                  ),
                )),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.whiteTemp,

        title:  Text('Edit Profile',

          style: TextStyle(
              fontFamily: "rubic",
              fontSize: 20.0,
              color: AppColors.white),
        ),
      ),
      body: isLoading
          ? SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(children: [
                    const SizedBox(
                      height: 25,
                    ),

                    InkWell(
                      onTap: () {
                        showAlertDialog(context);
                      },
                      child: CircleAvatar(
                        radius: 55,
                        child: userImg != null
                            ? CircleAvatar(
                                backgroundImage: FileImage(File(userImg!.path)),
                                radius: 50,
                                child: const Icon(
                                  Icons.camera_alt_outlined,
                                  size: 35,
                                  color: Colors.grey,
                                ),
                              )
                            : CircleAvatar(
                                backgroundImage:
                                    NetworkImage("$userimagedata"),
                                radius: 50,
                                child: const Icon(
                                  Icons.camera_alt_outlined,
                                  size: 35,
                                  color: Colors.grey,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(
                      height: 25,
                    ),

                    TextFormField(
                      controller: bussinessnamecontroller,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.bubble_chart_sharp,
                          color: AppColors.tabtextColor,
                        ),
                        hintText: 'Bussiness Name',
                        hintStyle: const TextStyle(fontSize: 16),
                        contentPadding: const EdgeInsets.symmetric(vertical: 5),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                                color: AppColors.whiteTemp, width: 2)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                                color: AppColors.whiteTemp, width: 2)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                                color: AppColors.whiteTemp, width: 2)),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: AppColors.whiteTemp),
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Business Name';
                        }
                        return null; // Return null if the input is valid
                      },
                    ),
                    const SizedBox(
                      height: 5,
                    ),

                    TextFormField(
                      controller: usernamecontroller,
                      // controller: usernamecontroller,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.person,
                          color: AppColors.tabtextColor,
                        ),
                        hintText: 'User Name',
                        hintStyle: const TextStyle(fontSize: 16),
                        contentPadding: const EdgeInsets.symmetric(vertical: 5),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                                color: AppColors.whiteTemp, width: 2)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                                color: AppColors.whiteTemp, width: 2)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                                color: AppColors.whiteTemp, width: 2)),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: AppColors.whiteTemp),
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter User Name';
                        }
                        return null; // Return null if the input is valid
                      },
                    ),

                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      readOnly: true,
                      controller: emailC,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.email,
                          color: AppColors.tabtextColor,
                        ),
                        hintText: 'Email',
                        hintStyle: const TextStyle(fontSize: 16),
                        contentPadding: const EdgeInsets.symmetric(vertical: 5),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                                color: AppColors.whiteTemp, width: 2)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                                color: AppColors.whiteTemp, width: 2)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                                color: AppColors.whiteTemp, width: 2)),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: AppColors.whiteTemp),
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Email';
                        } else if (!value.contains('@') ||
                            !value.contains(".com")) {
                          return 'Please Enter Valid Email';
                        }
                        return null; // Return null if the input is valid
                      },
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      controller: firstNmaeController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.person,
                          color: AppColors.tabtextColor,
                        ),
                        hintText: 'First Name',
                        hintStyle: const TextStyle(fontSize: 16),
                        contentPadding: const EdgeInsets.symmetric(vertical: 5),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                                color: AppColors.whiteTemp, width: 2)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                                color: AppColors.whiteTemp, width: 2)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                                color: AppColors.whiteTemp, width: 2)),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: AppColors.whiteTemp),
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter First Name';
                        }
                        return null; // Return null if the input is valid
                      },
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      controller: lastNmaecontroller,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.person,
                          color: AppColors.tabtextColor,
                        ),
                        hintText: 'Last Name',
                        hintStyle: const TextStyle(fontSize: 16),
                        contentPadding: const EdgeInsets.symmetric(vertical: 5),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                                color: AppColors.whiteTemp, width: 2)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                                color: AppColors.whiteTemp, width: 2)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                                color: AppColors.whiteTemp, width: 2)),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: AppColors.whiteTemp),
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Last Name';
                        }
                        return null; // Return null if the input is valid
                      },
                    ),
                    const SizedBox(
                      height: 5,
                    ),

                    TextFormField(
                      maxLength: 10,
                      controller: mobilecontroller,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        counterText: "",
                        prefixIcon: const Icon(
                          Icons.call,
                          color: AppColors.tabtextColor,
                        ),
                        hintText: 'Phone',
                        hintStyle: const TextStyle(fontSize: 16),
                        contentPadding: const EdgeInsets.symmetric(vertical: 5),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                                color: AppColors.whiteTemp, width: 2)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                                color: AppColors.whiteTemp, width: 2)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                                color: AppColors.whiteTemp, width: 2)),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: AppColors.whiteTemp),
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Phone Number';
                        } else if (value.length < 10) {
                          return 'Please Enter Valid Phone Number';
                        }
                        return null; // Return null if the input is valid
                      },
                    ),
                    const SizedBox(
                      height: 5,
                    ),

                    TextFormField(
                      onTap: () {
                        sselectDate(context);
                      },
                      readOnly: true,
                      controller: dateofbirthcontroller,
                      decoration: InputDecoration(
                        counterText: "",
                        prefixIcon: const Icon(
                          Icons.calendar_month,
                          color: AppColors.tabtextColor,
                        ),
                        hintText: 'Date Of Birth',
                        hintStyle: const TextStyle(fontSize: 16),
                        contentPadding: const EdgeInsets.symmetric(vertical: 5),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                                color: AppColors.whiteTemp, width: 2)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                                color: AppColors.whiteTemp, width: 2)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                                color: AppColors.whiteTemp, width: 2)),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: AppColors.whiteTemp),
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Date Of Birth';
                        }
                        return null; // Return null if the input is valid
                      },
                    ),
                    // const SizedBox(
                    //   height: 5,
                    // ),
                    //
                    // Container(
                    //   height: 150,
                    //   width: MediaQuery.of(context).size.width,
                    //   decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(8),
                    //       border:
                    //           Border.all(color: AppColors.whiteTemp, width: 2)),
                    //   child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.start,
                    //     children: [
                    //       Padding(
                    //         padding: const EdgeInsets.all(8),
                    //         child: TextFormField(
                    //           controller: aboutuscontroller,
                    //           decoration: const InputDecoration(
                    //             enabledBorder: InputBorder.none,
                    //             errorBorder: InputBorder.none,
                    //             focusedBorder: InputBorder.none,
                    //             focusedErrorBorder: InputBorder.none,
                    //             hintText: 'About Your Self...',
                    //             hintStyle: TextStyle(fontSize: 16),
                    //           ),
                    //           maxLines: 4,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    const SizedBox(
                      height: 5,
                    ),

                    TextFormField(
                      controller: address1controller,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.location_on,
                          color: AppColors.tabtextColor,
                        ),
                        hintText: 'Address Line 1',
                        hintStyle: const TextStyle(fontSize: 13),
                        contentPadding: const EdgeInsets.symmetric(vertical: 5),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                                color: AppColors.whiteTemp, width: 2)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                                color: AppColors.whiteTemp, width: 2)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                                color: AppColors.whiteTemp, width: 2)),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: AppColors.whiteTemp),
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Address Line 1';
                        }
                        return null; // Return null if the input is valid
                      },
                    ),
                    const SizedBox(
                      height: 5,
                    ),

                    TextFormField(
                      controller: address2controller,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.location_on,
                          color: AppColors.tabtextColor,
                        ),
                        hintText: 'Address Line 2',
                        hintStyle: const TextStyle(fontSize: 13),
                        contentPadding: const EdgeInsets.symmetric(vertical: 5),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                                color: AppColors.whiteTemp, width: 2)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                                color: AppColors.whiteTemp, width: 2)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                                color: AppColors.whiteTemp, width: 2)),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: AppColors.whiteTemp),
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Address Line 2';
                        }
                        return null; // Return null if the input is valid
                      },
                    ),
                    const SizedBox(
                      height: 5,
                    ),

                    TextFormField(
                      controller: citycontroller,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.location_on,
                          color: AppColors.tabtextColor,
                        ),
                        hintText: 'City',
                        hintStyle: const TextStyle(fontSize: 13),
                        contentPadding: const EdgeInsets.symmetric(vertical: 5),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                                color: AppColors.whiteTemp, width: 2)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                                color: AppColors.whiteTemp, width: 2)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                                color: AppColors.whiteTemp, width: 2)),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: AppColors.whiteTemp),
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter City';
                        }
                        return null; // Return null if the input is valid
                      },
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      controller: statecontroller,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.location_on,
                          color: AppColors.tabtextColor,
                        ),
                        hintText: 'State',
                        hintStyle: const TextStyle(fontSize: 13),
                        contentPadding: const EdgeInsets.symmetric(vertical: 5),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                                color: AppColors.whiteTemp, width: 2)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                                color: AppColors.whiteTemp, width: 2)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                                color: AppColors.whiteTemp, width: 2)),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: AppColors.whiteTemp),
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter State';
                        }
                        return null; // Return null if the input is valid
                      },
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    // TextFormField(
                    //   controller: contrycontroller,
                    //   decoration: InputDecoration(
                    //     prefixIcon: const Icon(
                    //       Icons.location_on,                color: AppColors.tabtextColor,
                    //     ),
                    //     hintText: 'Country',
                    //     hintStyle: const TextStyle(fontSize: 13),
                    //     contentPadding: const EdgeInsets.symmetric(vertical: 5),
                    //     focusedErrorBorder: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(25),
                    //         borderSide: const BorderSide(
                    //             color: AppColors.whiteTemp, width: 2)),
                    //     enabledBorder: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(25),
                    //         borderSide: const BorderSide(
                    //             color: AppColors.whiteTemp, width: 2)),
                    //     errorBorder: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(25),
                    //         borderSide: const BorderSide(
                    //             color: AppColors.whiteTemp, width: 2)),
                    //     focusedBorder: OutlineInputBorder(
                    //       borderSide: const BorderSide(color: AppColors.whiteTemp),
                    //       borderRadius: BorderRadius.circular(25),
                    //     ),
                    //   ),
                    //   validator: (value) {
                    //     if (value!.isEmpty) {
                    //       return 'Please Enter Country';
                    //     }
                    //     return null; // Return null if the input is valid
                    //   },
                    // ),
                    // const SizedBox(
                    //   height: 5,
                    // ),
                    TextFormField(
                      controller: zipcodecontroller,
                      maxLength: 6,
                      decoration: InputDecoration(
                        counterText: "",
                        prefixIcon: const Icon(
                          Icons.location_on,
                          color: AppColors.tabtextColor,
                        ),
                        hintText: 'Zip Code',
                        hintStyle: const TextStyle(fontSize: 13),
                        contentPadding: const EdgeInsets.symmetric(vertical: 5),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                                color: AppColors.whiteTemp, width: 2)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                                color: AppColors.whiteTemp, width: 2)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: const BorderSide(
                                color: AppColors.whiteTemp, width: 2)),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: AppColors.whiteTemp),
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Zip Code';
                        }
                        return null; // Return null if the input is valid
                      },
                    ),
                    const SizedBox(
                      height: 5,
                    ),

                    const SizedBox(
                      height: 100,
                    )
                  ]),
                ),
              ),
            ),
    ));
  }

  @override
  void initState() {
    // TODO: implement initState
    gettoken();
    super.initState();
  }

  var token;

  Future<void> gettoken() async {
    setState(() {
      isLoading = true;
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token =  prefs.getString('userToken');
    debugPrint("===my technic=======$token===============");
    setState(() {});
    if (token == null) {
      setState(() {
        isLoading = false;
      });
    } else {
      getUserDataApi();
    }
  }

  GetUserData? getUserDataResponse;

  Future<void> getUserDataApi() async {
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.MultipartRequest('GET', Uri.parse('${baseUrl}me'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    debugPrint("===my technic=======${request.url}===============");
    debugPrint("===my technic=======${request.fields}===============");
    if (response.statusCode == 200) {
      print("token---------${token}");
      var result = await response.stream.bytesToString();
      debugPrint("===my technic=======$result===============");
      var finalResult = jsonDecode(result);

      if (finalResult['status'] == 1) {
        setState(() {
          getUserDataResponse = GetUserData.fromJson(finalResult);

          isLoading = false;
          debugPrint(
              "===my technic=======${getUserDataResponse?.data.userName}===============");
          bussinessnamecontroller.text = getUserDataResponse?.data.businessName ?? "";
          usernamecontroller.text = getUserDataResponse?.data.userName ?? "";
          emailC.text = getUserDataResponse?.data.email ?? "";
          firstNmaeController.text = getUserDataResponse?.data.firstName ?? "";
          lastNmaecontroller.text = getUserDataResponse?.data.lastName ?? "";
          mobilecontroller.text = getUserDataResponse?.data.phone ?? "";
          dateofbirthcontroller.text = getUserDataResponse?.data.birthday ?? "";
          aboutuscontroller.text = getUserDataResponse?.data.birthday ?? "";
          address1controller.text = getUserDataResponse?.data.address ?? "";
          address2controller.text = getUserDataResponse?.data.address2 ?? "";
          statecontroller.text = getUserDataResponse?.data.state ?? "";
          citycontroller.text = getUserDataResponse?.data.city ?? "";
          zipcodecontroller.text = getUserDataResponse?.data.zipCode ?? "";
          contrycontroller.text = getUserDataResponse?.data.country ?? "";
          userimagedata = getUserDataResponse?.data.avatarUrl ?? "";
        });
      }
    } else {
      debugPrint(response.reasonPhrase);
    }
  }

  bool isLoading = false;
  bool isLoading2 = false;

  Future<void> sessionRemove() async {
    setState(() {
      isLoading = true;
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    authToken = '';
    await prefs.remove('userToken');
    setState(() {
      isLoading = false;
    });
  }

  final emailC = TextEditingController();
  TextEditingController dateofbirthcontroller = TextEditingController();
  TextEditingController bussinessnamecontroller = TextEditingController();
  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController mobilecontroller = TextEditingController();
  TextEditingController firstNmaeController = TextEditingController();
  TextEditingController lastNmaecontroller = TextEditingController();
  TextEditingController aboutuscontroller = TextEditingController();
  TextEditingController address1controller = TextEditingController();
  TextEditingController address2controller = TextEditingController();
  TextEditingController statecontroller = TextEditingController();
  TextEditingController citycontroller = TextEditingController();
  TextEditingController zipcodecontroller = TextEditingController();
  TextEditingController contrycontroller = TextEditingController();

  DateTime selectedDate = DateTime.now();

  Future<void> sselectDate(
    BuildContext context,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1800),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) selectedDate = picked;

    dateofbirthcontroller.text = DateFormat('dd-MM-yyyy').format(selectedDate);

    setState(() {});
    debugPrint("===my technic=======${dateofbirthcontroller.text}===============");
  }

  File? userImg;

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(
      source: source,
      maxHeight: 100,
      maxWidth: 100,
      imageQuality: 50, // You can adjust the image quality here
    );

    if (pickedFile != null) {
      setState(() {
        userImg = File(pickedFile.path);
        debugPrint('============${userImg!.path}');

        uploadImage();
      });
    }
  }

  showAlertDialog(
    BuildContext context,
  ) {
    AlertDialog alert = AlertDialog(
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 25),
          child: Container(
            height: 250,
            color: Colors.transparent, //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0))),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 5,
                      width: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(75),
                          color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      'Select Any One Option',
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        pickImage(ImageSource.gallery);
                      },
                      child: Card(
                        elevation: 5,
                        child: Container(
                          width: 200,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8)),
                          child: const Center(child: Text('Select From Gallery')),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        pickImage(ImageSource.camera);
                      },
                      child: Card(
                        elevation: 5,
                        child: Container(
                          width: 200,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8)),
                          child: const Center(child: Text('Select From Camera')),
                        ),
                      ),
                    )
                  ],
                )),
          ),
        ),
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> updateProfileApi() async {
    debugPrint("===my technic=======${token}===============");
    setState(() {
      isLoading2 == true;
    });
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.MultipartRequest('POST', Uri.parse('${baseUrl}me'));
    request.fields.addAll({
      'business_name': bussinessnamecontroller.text,
      'user_name': usernamecontroller.text,
      'email': emailC.text,
      'first_name': firstNmaeController.text,
      'last_name': lastNmaecontroller.text,
      'phone': mobilecontroller.text,
      'birthday': dateofbirthcontroller.text,
      'bio': "1",
      'avatar_id': imageid.toString(),
      'address': address1controller.text,
      'address2': address2controller.text,
      'city': citycontroller.text,
      'state': statecontroller.text,
      'country': 'IN',
      'zip_code': zipcodecontroller.text,
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    debugPrint("===my technic=======${request.url}===============");
    debugPrint("===my technic=======${request.fields}===============");
    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var finalresult = jsonDecode(result);
      if (finalresult['status'] == 1) {
        Fluttertoast.showToast(msg: "Update Successfully");
        setState(() {
          isLoading2 == false;
        });
        Navigator.pop(context);
      }
    } else {
      debugPrint(response.reasonPhrase);
    }
  }

  var imageid;

  Future<void> uploadImage() async {
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.MultipartRequest(
        'POST', Uri.parse('${UpdateImageUrl}media/store'));
    if (userImg != null) {
      request.files
          .add(await http.MultipartFile.fromPath('file', userImg!.path));
    }
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      debugPrint("===my technic=======$result===============");
      var finalResult = jsonDecode(result);
      if (finalResult['status'] == 1) {
        imageid = finalResult['data']['id'].toString();
      } else {
        print(response.reasonPhrase);
      }
    }
  }


}
