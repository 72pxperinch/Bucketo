import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:bucketo/screens/welcome_screen.dart';
import 'package:bucketo/screens/login_screen.dart';
import 'package:bucketo/screens/registration_screen.dart';
import 'package:bucketo/screens/empty.dart';
import 'package:bucketo/screens/addTask.dart';
import 'package:bucketo/screens/home.dart';
import 'package:bucketo/screens/categoryScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const bucketo());
}

class bucketo extends StatelessWidget {
  const bucketo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => const WelcomeScreen(),
        AddTaskScreen.id: (context) => const AddTaskScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        RegistrationScreen.id: (context) => const RegistrationScreen(),
        Empty.id: (context) => const Empty(
              typed: "",
            ),
        Home.id: (context) => const Home(),
        Category.id: (context) => const Category(cat: ''),
      },
    );
  }
}
