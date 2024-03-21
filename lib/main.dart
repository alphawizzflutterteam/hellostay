import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hellostay/screens/Splash.dart';
import 'package:hellostay/screens/bottom_nav/bottom_Nav_bar.dart';
import 'package:hellostay/screens/loginScreen.dart';
import 'package:hellostay/services/notification_service.dart';
import 'package:hellostay/utils/globle.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  print(message.data.toString());
  print(message.notification!.title);
}


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  LocalNotificationService.initialize();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  authToken =  prefs.getString('userToken');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HELLOSTAY',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
       home: const SplashScreen(),
      // home:LoginPage(),
    );
  }
}


