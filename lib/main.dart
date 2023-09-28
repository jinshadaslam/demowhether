import 'package:demowhether/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'api.dart';
import 'theamchange.dart';
// import 'package:weatherapp/api.dart';
// import 'package:weatherapp/sharedpref/nightshared.dart';
// import 'package:weatherapp/ui/location_page.dart';
// import 'package:weatherapp/ui.dart';

Future<void> main() async {
  await dotenv.load();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Fech(),
        ),
        ChangeNotifierProvider(create: (context) => ThemeProvider())
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}
