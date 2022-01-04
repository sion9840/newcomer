import 'package:flutter/material.dart';
import 'package:newcomer/my.dart';

import 'login_screen.dart';
import 'signup_screen.dart';

class GuideScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(CtTheme.white_color),
      body: Padding(
        padding: EdgeInsets.all(CtTheme.middle_padding),
        child: Center(
          child: Column(
            children: <Widget>[
              Spacer(),
              Image.asset(
                "images/icon.png",
                width: 150.0,
                height: 150.0,
              ),
              Text(
                "수원동부교회\n새가족부",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(CtTheme.black_color),
                  fontSize: CtTheme.big_font_size,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50.0,
                child: ElevatedButton(
                  child: Text(
                    "회원가입",
                    style: TextStyle(
                      color: Color(CtTheme.white_color),
                      fontSize: CtTheme.small_font_size,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Color(CtTheme.primary_color)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(CtTheme.small_radius),
                        )),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
                    );
                  },
                ),
              ),
              SizedBox(height: CtTheme.middle_padding,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "이미 계정이 있나요?",
                    style: TextStyle(
                      color: Color(CtTheme.dark_gray_color),
                      fontSize: CtTheme.small_font_size,
                    ),
                  ),
                  TextButton(
                    child: Text(
                      "로그인",
                      style: TextStyle(
                        color: Color(CtTheme.primary_color),
                        fontSize: CtTheme.small_font_size,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      )
    );
  }
}