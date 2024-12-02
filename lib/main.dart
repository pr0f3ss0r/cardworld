
import 'package:cloudinary_flutter/cloudinary_object.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cardworld/presentation/screens/login_screen.dart';
import 'package:cardworld/presentation/screens/home_screen.dart';
import 'package:cardworld/presentation/screens/registration_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();


//Cloudinary cloudinary = CloudinaryObject.fromCloudName(cloudName: 'daj1zigmo');
  runApp(const CardWorldApp());
}

class CardWorldApp extends StatelessWidget {
  const CardWorldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CardWorld',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/register': (context) => const RegistrationScreen(),
      },
    );
  }
}
