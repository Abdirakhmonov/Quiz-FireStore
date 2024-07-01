import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lesson_65/providers/select_index.dart';
import 'package:lesson_65/utils/routes.dart';
import 'package:lesson_65/views/screens/home_page.dart';
import 'package:lesson_65/views/screens/login_screen.dart';
import 'package:lesson_65/views/screens/registr_screen.dart';
import 'package:provider/provider.dart';
import 'controllers/question_controller.dart';
import 'firebase_options.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyWidget());
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => QuestionController()),
        ChangeNotifierProvider(create: (_) => SelectedAnswerProvider()),
      ],
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            appBarTheme: const AppBarTheme(
              surfaceTintColor: Colors.transparent,
              backgroundColor: Colors.transparent,
            ),
          ),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return const Homepage();
              }

              return const LoginScreen();
            },
          ),
          routes: {
            AppRoutes.login: (context) => const LoginScreen(),
            AppRoutes.register: (context) => const RegisterScreen(),
            AppRoutes.home: (context) => const Homepage(),
          },
        );
      },
    );
  }
}
