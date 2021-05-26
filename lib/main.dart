
import 'package:flutter/material.dart';


import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:param_quiz_app/screens/welcome_screen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Parma Quiz App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.yellow,
          bottomSheetTheme:
              const BottomSheetThemeData(backgroundColor: Colors.transparent),
        ),
        home: WelcomeScreen(),
      ),
    );
  }
}



