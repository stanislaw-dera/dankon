import 'package:dankon/constants.dart';
import 'package:dankon/firebase_options.dart';
import 'package:dankon/screens/home/search.dart';
import 'package:dankon/screens/home/settings.dart';
import 'package:dankon/services/authentication.dart';
import 'package:dankon/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<AuthenticationService>().authStateChanges, initialData: null,
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Dankon',
        theme: kThemeData,
        initialRoute: '/',
        routes: {
          '/': (context) => const Wrapper(),
          '/search': (context) => SearchScreen(),
          '/settings': (context) => SettingsScreen()
        },
      ),
    );
  }
}

