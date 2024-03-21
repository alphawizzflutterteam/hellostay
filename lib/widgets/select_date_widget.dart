import 'package:flutter/material.dart';
import 'package:hellostay/constants/colors.dart';

Widget selectDateWidget (String title, String checkInDayOfWeek, String formattedCheckInDate, bool isSelected, BuildContext context){

  return Padding(
    padding:const EdgeInsets.symmetric(horizontal: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? AppColors.primary : Colors.black54.withOpacity(0.5),
          ),
        ),
        const SizedBox(height: 8),
        checkInDayOfWeek == ''  ? const Text('Select Date', style: TextStyle(fontFamily: 'rubic'),) : RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '$formattedCheckInDate\n',
                style: const TextStyle(
                  fontSize: 20,
                  color:  AppColors.blackTemp,fontFamily: 'rubic'
                ),
              ),
              TextSpan(
                text: checkInDayOfWeek,
                style: const TextStyle(
                  fontSize: 14,
                  color:  Colors.grey,fontFamily: 'rubic'
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 2,

          width: MediaQuery.of(context).size.width/3,
          color: isSelected ?  AppColors.primary : Colors.grey,
        ),
      ],
    ),
  );
}



