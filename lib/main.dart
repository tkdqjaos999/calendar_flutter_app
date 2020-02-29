import 'package:calendar_flutter_app/src/bloc/back_up_bloc.dart';
import 'package:calendar_flutter_app/src/data/date_repository.dart';
import 'package:calendar_flutter_app/src/data/firebase_provider.dart';
import 'package:calendar_flutter_app/src/data/sqflite_provider.dart';
import 'package:calendar_flutter_app/src/page/detail_page.dart';
import 'package:calendar_flutter_app/src/page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SqlfliteProvider>(
          create: (_) => SqlfliteProvider(),
        ),
        ChangeNotifierProvider<FirebaseProvider>(
          create: (_) => FirebaseProvider(),
        ),
      ],
      child: BlocProvider(
        create: (context) => BackUpBloc(DateRepository()),
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            textTheme: GoogleFonts.nanumGothicTextTheme()
          ),
          home: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarColor: Colors.black
            ),
              child: HomePage()),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}

