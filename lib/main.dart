import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:newcomer/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'guide_screen.dart';
import 'my.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.light
    ..textStyle = TextStyle(
      color: Color(CtTheme.black_color),
      fontSize: CtTheme.small_font_size,
    )
    ..maskType = EasyLoadingMaskType.black
    ..backgroundColor = Color(CtTheme.white_color)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..indicatorColor = Color(CtTheme.black_color)
    ..indicatorSize = 50.0;
}

class MyApp extends StatelessWidget {
  MaterialColor primary_color = MaterialColor(
      CtTheme.primary_color,
      <int, Color>{
        50: Color(CtTheme.primary_color),
        100: Color(CtTheme.primary_color),
        200: Color(CtTheme.primary_color),
        300: Color(CtTheme.primary_color),
        400: Color(CtTheme.primary_color),
        500: Color(CtTheme.primary_color),
        600: Color(CtTheme.primary_color),
        700: Color(CtTheme.primary_color),
        800: Color(CtTheme.primary_color),
        900: Color(CtTheme.primary_color),
      }
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ko', 'KR'),
      ],
      theme: ThemeData(
        primarySwatch: primary_color,
      ),
      home: ReadyScreen(),
      builder: EasyLoading.init(),
    );
  }
}

class ReadyScreen extends StatelessWidget {
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: returnInitFuture(),
        builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if(snapshot.hasData) {
            return returnMainPage(snapshot.data);
          }
          else if(snapshot.hasError){
            return returnErrorPage();
          }
          else{
            return returnLoadingPage();
          }
        }
    );
  }

  Future<Map<String, dynamic>> returnInitFuture() async{
    var prefs_data = await prefs;

    if (await FirebaseAuth.instance.currentUser! == null) {
      prefs_data.remove("user_id");
    }

    return {"prefs" : prefs_data};
  }

  dynamic returnMainPage(var data){
    tiny_db = data["prefs"];

    if(tiny_db.getString("user_id") == null){ // 만약 앱을 처음 사용한다면
      return GuideScreen();
    }
    else{
      return MainScreen();
    }
  }
}