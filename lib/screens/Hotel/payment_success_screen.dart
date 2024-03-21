import 'package:flutter/material.dart';
import 'package:hellostay/constants/colors.dart';
import '../bottom_nav/bottom_Nav_bar.dart';
import 'homeView.dart';

class PaymentSuccessfulScreen extends StatelessWidget {
  const PaymentSuccessfulScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    // Delayed navigation function
    void navigateToBottomNavBar() {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNavBar()),
      );
    }

    // Schedule navigation after three seconds
    Future.delayed(Duration(seconds: 3), navigateToBottomNavBar);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 100,
              color: Colors.green,
            ),
            const SizedBox(height: 20),
            const Text(
              'Payment Successful!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Your payment has been processed successfully.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            InkWell(
              onTap: navigateToBottomNavBar, // Navigate immediately on tap
              child: Container(
                height: 45,
                width: MediaQuery.of(context).size.width / 1.4,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: AppColors.primary,
                ),
                child: const Text(
                  "Back to Home",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Lora',
                      color: AppColors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:hellostay/constants/colors.dart';
//
// import '../bottom_nav/bottom_Nav_bar.dart';
// import 'homeView.dart';
// // import 'package:job_dekho_app/Jdx_screens/Dashbord.dart';
// // import 'package:job_dekho_app/Utils/color.dart';
//
// class PaymentSuccessfulScreen extends StatelessWidget {
//   const PaymentSuccessfulScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(
//               Icons.check_circle_outline,
//               size: 100,
//               color: Colors.green,
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'Payment Successful!',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             const Text(
//               'Your payment has been processed successfully.',
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 18, color: Colors.grey),
//             ),
//             const SizedBox(height: 30),
//
//             InkWell(
//               onTap: (){
//                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>BottomNavBar()));
//               },
//               child: Container(
//                 height: 45,
//                 width: MediaQuery.of(context).size.width / 1.4,
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(30),
//                   color: AppColors.primary,
//                 ),
//                 child:  const Text(
//                   "Back to Home",
//                   style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       fontFamily: 'Lora',color: AppColors.white),
//                 ),
//               ),
//             ),
//
//           ],
//         ),
//       ),
//     );
//   }
// }