import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memories_entry/layout/add_memories.dart';
import 'package:memories_entry/layout/home.dart';
import 'package:memories_entry/layout/login.dart';
import 'package:memories_entry/layout/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:memories_entry/provider/memories_provider.dart';
import 'package:memories_entry/themes/app_theme.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.pink,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  User? user = FirebaseAuth.instance.currentUser;
  String initialRoute = (user == null)
      ? LoginPage.routeName // أو صفحة ترحيب لو تحب
      : HomePage.routeName;

  runApp(MemoriesApp(initialRoute: initialRoute));
}

class MemoriesApp extends StatelessWidget {
  final String initialRoute;

  const MemoriesApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MemoriesProvider()),
      ],
      child: MaterialApp(
        title: 'Memories Entry',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,

        initialRoute: initialRoute,
        routes: {
          HomePage.routeName: (_) =>  HomePage(),
          LoginPage.routeName: (_) => LoginPage(),
          SignUpPage.routeName: (_) => SignUpPage(),
          AddMemoriesPage.routeName: (_) =>  AddMemoriesPage(),
        },
      ),
    );
  }
}
