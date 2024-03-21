import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:hellostay/constants/colors.dart';
import 'package:hellostay/repository/apiConstants.dart';
import 'package:hellostay/repository/apiStrings.dart';
import 'package:hellostay/utils/customeTost.dart';
import 'package:hellostay/widgets/custom_app_button.dart';
import 'package:hellostay/widgets/loadingwidget.dart';

import '../widgets/custumScreen.dart';
import 'loginScreen.dart';

class SignUpScr extends StatefulWidget {
  const SignUpScr({super.key});

  @override
  State<SignUpScr> createState() => _SignUpScrState();
}

class _SignUpScrState extends State<SignUpScr> {
  final emailC = TextEditingController();
  final referral = TextEditingController();
  final passwordC = TextEditingController();
  final confirmPasswordC = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            customAuthDegine(context, "assets/images/loginImage.png"),
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.36),
              height: MediaQuery.of(context).size.height * 0.69,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: const BoxDecoration(
                color: Color(0xffF6F6F6),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 13,
                    ),
                    const Row(
                      children: [
                        Text(
                          'Sign Up',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 13,
                    ),
                    Center(
                      child: const Text(
                        "Welcome to HELLOSTAY",
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: "rubic"
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      "Please Login/ Register using your Email/ Mobile to continue.",
                      style: TextStyle(
                        fontSize: 14,
                        //fontFamily: "rubic"
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      controller: firstNmaeController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.person,
                          color: AppColors.tabtextColor,
                        ),
                        hintText: 'First Name',
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
                          borderSide: const BorderSide(color: AppColors.whiteTemp),
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
                          borderSide: const BorderSide(color: AppColors.whiteTemp),
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
                          borderSide: const BorderSide(color: AppColors.whiteTemp),
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
                      controller: emailC,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.email,
                          color: AppColors.tabtextColor,
                        ),
                        hintText: 'Email',
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
                          borderSide: const BorderSide(color: AppColors.whiteTemp),
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
                    ), const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      controller: referral,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.share,
                          color: AppColors.tabtextColor,
                        ),
                        hintText: 'Referral Code',
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
                          borderSide: const BorderSide(color: AppColors.whiteTemp),
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      // validator: (value) {
                      //   if (value!.isEmpty) {
                      //     return 'Please Enter Email';
                      //   } else if (!value.contains('@') ||
                      //       !value.contains(".com")) {
                      //     return 'Please Enter Valid Email';
                      //   }
                      //   return null; // Return null if the input is valid
                      // },
                    ),
                    // const SizedBox(
                    //   height: 8,
                    // ),
                    //
                    // Container(
                    //   height: 50,
                    //   width: MediaQuery.of(context).size.width,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(
                    //         MediaQuery.of(context).size.width / 2),
                    //     border:
                    //         Border.all(width: 2, color: AppColors.whiteTemp),
                    //   ),
                    //   child: Row(
                    //     children: [
                    //       const SizedBox(
                    //         width: 10,
                    //       ),
                    //       const Icon(
                    //         Icons.map,
                    //         color: AppColors.tabtextColor,
                    //       ),
                    //       DropdownButtonHideUnderline(
                    //         child: DropdownButton2(
                    //           hint: SizedBox(
                    //             width:
                    //                 MediaQuery.of(context).size.width / 1.7,
                    //             child: const Text(
                    //               'Select Gender',
                    //               overflow: TextOverflow.ellipsis,
                    //               maxLines: 1,
                    //               style: TextStyle(
                    //                   color: AppColors.tabtextColor,
                    //                   fontSize: 13),
                    //             ),
                    //           ), // Not necessary for Option 1
                    //           value: _selectvehiclecat,
                    //           onChanged: (newValue) {
                    //             setState(() {
                    //               _selectvehiclecat = newValue.toString();
                    //             });
                    //           },
                    //           items: selectVehicleList.map((location) {
                    //             return DropdownMenuItem(
                    //               value: location,
                    //               child:  Text(location),
                    //             );
                    //           }).toList(),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 5,
                    // ),
                    // TextFormField(
                    //   controller: registrationNoController,
                    //   decoration: InputDecoration(
                    //     prefixIcon: const Icon(
                    //       Icons.car_crash_outlined,
                    //       color: AppColors.tabtextColor,
                    //     ),
                    //     hintText: 'Registration No',
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
                    //       return 'Please Enter Registration No';
                    //     }
                    //     return null; // Return null if the input is valid
                    //   },
                    // ),
                    // const SizedBox(
                    //   height: 5,
                    // ),
                    // TextFormField(
                    //   onTap: () {
                    //     showPlacePicker();
                    //   },
                    //   readOnly: true,
                    //   controller: addressController,
                    //   decoration: InputDecoration(
                    //     prefixIcon: const Icon(
                    //       Icons.location_on,
                    //       color: AppColors.tabtextColor,
                    //     ),
                    //     hintText: 'Address',
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
                    //       return 'Please Enter Address';
                    //     }
                    //     return null; // Return null if the input is valid
                    //   },
                    // ),
                    // const SizedBox(
                    //   height: 8,
                    // ),
                    TextFormField(
                      obscureText: _obscureText,
                      controller: passwordC,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColors.primary,
                            size: 16,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: AppColors.tabtextColor,
                        ),
                        hintText: 'Password',
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
                          borderSide: const BorderSide(color: AppColors.whiteTemp),
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Password';
                        }
                        return null; // Return null if the input is valid
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      obscureText: _obscureText,
                      controller: confirmPasswordC,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColors.primary,
                            size: 16,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: AppColors.tabtextColor,
                        ),
                        hintText: 'Confirm Password',
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
                          borderSide: const BorderSide(color: AppColors.whiteTemp),
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Confirm Password';
                        } else if (value.toString() !=
                            passwordC.text.toString()) {
                          return 'Confirm Password is Not Match';
                        }
                        return null; // Return null if the input is valid
                      },
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    InkWell(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          signUp();
                          //  Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard(),));
                        }
                      },
                      child: !isLoading
                          ? CustomButton(
                              textt: "Sign Up",
                            )
                          : LoadingWidget(context),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account?",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            " Log In",
                            style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 100,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  TextEditingController firstNmaeController = TextEditingController();
  TextEditingController lastNmaecontroller = TextEditingController();
  TextEditingController registrationNoController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  void signUp() {
    setState(() {
      isLoading = true;
    });
    var param = {
      'email': emailC.text.toString(),
      'password':passwordC.text.toString(),
      'first_name':firstNmaeController.text.toString(),
      'last_name': lastNmaecontroller.text.toString(),
      'term': '1',
      'phone': mobilecontroller.text.toString(),
      'referrer':referral.text
    };
    apiBaseHelper.postAPICall(userRegister, param).then((getData) {
      int error = getData['status'];

      if (error == 1) {
        String msg = getData['message'].toString();

        customSnackbar(context, msg.toString());
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ));
        setState(() {
          isLoading = false;
        });
      } else {
        print('mmmmmmmm${getData['message']['email']==null ? "" : getData['message']['email'][0].toString()}');
        String msg ;
        if(getData['message']['email'] == null)
          {
             msg = getData['message']['phone'][0].toString();

          }
        else
          {
             msg = getData['message']['email'][0].toString();
          }
      //  String msg = getData['message']['email'][0].toString();

        customSnackbar(context, msg.toString());
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  TextEditingController mobilecontroller = TextEditingController();
  bool isLoading = false;

  bool _obscureText = true;

  String? _selectvehiclecat;
  List selectVehicleList = ['Male', 'Female'];
  static const kInitialPosition = LatLng(-33.8567844, 151.213108);

/*
  void showPlacePicker() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return PlacePicker(
          resizeToAvoidBottomInset: false,
          // only works in page mode, less flickery
          apiKey: Platform.isAndroid
              ? 'APIKeys.androidApiKey'
              : 'APIKeys.iosApiKey',
          hintText: "Find a place ...",
          searchingText: "Please wait ...",
          selectText: "Select place",
          outsideOfPickAreaText: "Place not in area",
          initialPosition: kInitialPosition,
          useCurrentLocation: true,
          selectInitialPosition: true,
          usePinPointingSearch: true,
          usePlaceDetailSearch: true,
          zoomGesturesEnabled: true,
          zoomControlsEnabled: true,
          ignoreLocationPermissionErrors: true,
          onMapCreated: (GoogleMapController controller) {},
          onPlacePicked: (PickResult result) {
            addressController.text = result.formattedAddress ?? '';
            lat = result.geometry?.location.lat;

            lang = result.geometry?.location.lng;

            setState(() {
              // selectedPlace = result;
              Navigator.of(context).pop();
            });
          },
          onMapTypeChanged: (MapType mapType) {});
    }));
  }
*/

  double? lat;
  double? lang;
}
