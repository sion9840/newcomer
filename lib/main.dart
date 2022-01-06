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
    return FutureBuilder<SharedPreferences>(
        future: prefs,
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            tiny_db = snapshot.data;

            initSet();

            if(tiny_db.getString("user_id") == null){ // 만약 앱을 처음 사용한다면
              return GuideScreen();
            }
            else{
              return MainScreen();
            }
          }
          else{
            return Scaffold(
              backgroundColor: Color(CtTheme.white_color),
              body: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Color(CtTheme.black_color),
                    ),
                    Text(
                      "시작 판단 중...",
                      style: TextStyle(
                        color: Color(CtTheme.black_color),
                        fontSize: CtTheme.small_font_size,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        }
    );
  }

  void initSet() async{
    if (await FirebaseAuth.instance.currentUser! == null) {
      tiny_db.remove("user_id");
    }
  }
}