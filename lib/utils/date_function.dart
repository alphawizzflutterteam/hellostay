import 'package:flutter/material.dart';
import 'package:hellostay/constants/colors.dart';
import 'package:hellostay/screens/Hotel/homeView.dart';
import 'package:intl/intl.dart';

Future <String> selectDate(BuildContext context, ) async {
  String yourDate  = '';
  DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
      //firstDate: DateTime.now().subtract(Duration(days: 1)),
      // lastDate: new DateTime(2022),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
              primaryColor: AppColors.primary,
              hintColor: AppColors.secondary,
              colorScheme: const ColorScheme.light(primary: AppColors.primary),
              // ColorScheme.light(primary: const Color(0xFFEB6C67)),
              buttonTheme:
              const ButtonThemeData(textTheme: ButtonTextTheme.accent)),
          child: child!,
        );
      });
  if (picked != null) {
       yourDate = picked.toString();

  }

  return yourDate ;
}
String convertDateTimeDisplay(String date) {
  final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
  final DateFormat serverFormater = DateFormat('yyyy-MM-dd');
  final DateTime displayDate = displayFormater.parse(date);
  final String formatted = serverFormater.format(displayDate);
  return formatted;
}

Future<void> showCalanderDatePicker(BuildContext context) async {
  DateTime initialDate = checkInDate != '' ? DateTime.parse(checkInDate) : DateTime.now();
  DateTime currentDate = DateTime.now();

  DateTimeRange? pickedDateRange = await showDateRangePicker(
    context: context,
    firstDate: currentDate,
    lastDate: DateTime(2025),
    initialDateRange: DateTimeRange(
      start: initialDate,
      end: checkOutDate != '' ? DateTime.parse(checkOutDate) : DateTime.now().add(Duration(days: 5))),

  );

  if (pickedDateRange != null) {
    checkInDate = pickedDateRange.start.toString();
      checkOutDate = pickedDateRange.end.toString();

  }
}