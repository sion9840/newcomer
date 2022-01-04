import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'main_screen.dart';
import 'my.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController id_textfield = TextEditingController();
  TextEditingController password_textfield = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(CtTheme.light_gray_color),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "로그인",
          style: TextStyle(
            color: Color(CtTheme.black_color),
            fontSize: CtTheme.small_font_size,
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              "확인",
              style: TextStyle(
                color: Color(CtTheme.primary_color),
                fontSize: CtTheme.small_font_size,
              ),
            ),
            onPressed: () async{
              EasyLoading.show(status: "로그인 중...");

              id_textfield.text = id_textfield.text.trimLeft().trimRight();
              password_textfield.text = password_textfield.text.trimLeft().trimRight();

              if(id_textfield.text.length == 0){
                EasyLoading.dismiss();

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("알림"),
                      content: Text("아이디를 입력해주세요."),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("확인"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                );

                return;
              }
              if(password_textfield.text.length == 0){
                EasyLoading.dismiss();

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("알림"),
                      content: Text("비밀번호를 입력해주세요."),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("확인"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                );

                return;
              }

              bool is_error = false;

              try {
                UserCredential _userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: "${id_textfield.text}123@gmail.com",
                  password: password_textfield.text,
                );
              } on FirebaseAuthException catch (e) {
                EasyLoading.dismiss();

                is_error = true;
                print(e.message);

                if (e.code == 'user-not-found') {
                  //EasyLoading.dismiss();

                  showDialog<String>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("알림"),
                        content: Text("존재하지 않는 아이디 입니다"),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("확인"),
                          ),
                        ],
                      )
                  );
                } else if (e.code == 'wrong-password') {
                  //EasyLoading.dismiss();

                  showDialog<String>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("알림"),
                        content: Text("비밀번호가 맞지 않습니다."),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("확인"),
                          ),
                        ],
                      )
                  );
                } else{
                  //EasyLoading.dismiss();

                  showDialog<String>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("알림"),
                        content: Text("로그인에 실패하셨습니다.\n인터넷 연결을 확인해주세요."),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("확인"),
                          ),
                        ],
                      )
                  );
                }
              }

              if(is_error){
                return;
              }

              TinyDb.setString("user_id", id_textfield.text);

              EasyLoading.dismiss();

              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                  MainScreen()), (Route<dynamic> route) => false);
            },
          ),
        ],
        backgroundColor: Color(CtTheme.white_color),
        iconTheme: IconThemeData(color: Color(CtTheme.black_color)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: CtTheme.middle_padding,),
            Container(
              width: double.infinity,
              color: Color(CtTheme.white_color),
              child: Padding(
                padding: EdgeInsets.all(CtTheme.middle_padding),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 40.0,
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 80.0,
                              child: Text(
                                "아이디",
                                style: TextStyle(
                                  color: Color(CtTheme.black_color),
                                  fontSize: CtTheme.small_font_size,
                                ),
                              ),
                            ),
                            SizedBox(width: CtTheme.small_padding,),
                            Expanded(
                              child: TextField(
                                controller: id_textfield,
                                style: TextStyle(
                                  color: Color(CtTheme.black_color),
                                  fontSize: CtTheme.small_font_size,
                                ),
                                decoration: InputDecoration.collapsed(
                                  hintText: "아이디",
                                  hintStyle: TextStyle(
                                    color: Color(CtTheme.dark_gray_color),
                                    fontSize: CtTheme.small_font_size,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Divider(),
                    SizedBox(
                      height: 40.0,
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 80.0,
                              child: Text(
                                "비밀번호",
                                style: TextStyle(
                                  color: Color(CtTheme.black_color),
                                  fontSize: CtTheme.small_font_size,
                                ),
                              ),
                            ),
                            SizedBox(width: CtTheme.small_padding,),
                            Expanded(
                              child: TextField(
                                controller: password_textfield,
                                style: TextStyle(
                                  color: Color(CtTheme.black_color),
                                  fontSize: CtTheme.small_font_size,
                                ),
                                decoration: InputDecoration.collapsed(
                                  hintText: "비밀번호",
                                  hintStyle: TextStyle(
                                    color: Color(CtTheme.dark_gray_color),
                                    fontSize: CtTheme.small_font_size,
                                  ),
                                ),
                                obscureText: true,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}