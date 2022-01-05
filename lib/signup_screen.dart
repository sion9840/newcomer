import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:newcomer/my.dart';

import 'main_screen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final firestoreInstance = FirebaseFirestore.instance;

  TextEditingController id_textfield = TextEditingController();
  TextEditingController password_textfield = TextEditingController();
  TextEditingController password_check_textfield = TextEditingController();
  TextEditingController name_textfield = TextEditingController();
  TextEditingController uid_textfield = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(CtTheme.light_gray_color),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "회원가입",
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
              EasyLoading.show(status: "회원가입 중...");

              id_textfield.text = id_textfield.text.trimLeft().trimRight();
              password_textfield.text = password_textfield.text.trimLeft().trimRight();
              password_check_textfield.text = password_check_textfield.text.trimLeft().trimRight();

              if(id_textfield.text.contains(" ")){
                EasyLoading.dismiss();

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("알림"),
                      content: Text("아이디에는 공백이 있으면 안됍니다."),
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

              if(password_textfield.text.contains(" ")){
                EasyLoading.dismiss();

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("알림"),
                      content: Text("비밀번호에는 공백이 있으면 안됍니다."),
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
              if(password_check_textfield.text.length == 0){
                EasyLoading.dismiss();

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("알림"),
                      content: Text("비밀번호 확인을 입력해주세요."),
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
              if(name_textfield.text.length == 0){
                EasyLoading.dismiss();

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("알림"),
                      content: Text("이름을 입력해주세요."),
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
              if(uid_textfield.text.length == 0){
                EasyLoading.dismiss();

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("알림"),
                      content: Text("고유 코드를 입력해주세요."),
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

              if((id_textfield.text.length < 5) || (id_textfield.text.length > 15)){
                EasyLoading.dismiss();

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("알림"),
                      content: Text("아이디는 5~15자 입니다.\n현재 당신의 아이디는 ${id_textfield.text.length}자 입니다."),
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
              if((password_textfield.text.length < 5) || (password_textfield.text.length > 20)){
                EasyLoading.dismiss();

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("알림"),
                      content: Text("비밀번호는 5~20자 입니다.\n현재 당신의 아이디는 ${id_textfield.text.length}자 입니다."),
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
              if(password_textfield.text != password_check_textfield.text){
                EasyLoading.dismiss();

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("알림"),
                      content: Text("비밀번호가 일치하지 않습니다."),
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
              if((name_textfield.text.length < 1) || (name_textfield.text.length > 10)){
                EasyLoading.dismiss();

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("알림"),
                      content: Text("이름은 1~10자 입니다.\n현재 당신의 이름은 ${id_textfield.text.length}자 입니다."),
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
              if(uid_textfield.text.length != 6){
                EasyLoading.dismiss();

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("알림"),
                      content: Text("고유 코드는 6자 입니다.\n현재 당신의 고유 코드는 ${uid_textfield.text.length}자 입니다."),
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

              if(uid_textfield.text != "913077"){
                EasyLoading.dismiss();

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("알림"),
                      content: Text("존재하지 않는 고유 코드 입니다."),
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

              for(int i = 0; i<id_textfield.text.length; i++){
                String text = id_textfield.text[i];
                if(!validateNumber(text) && !validateEnglishString(text) && !validateTukString(text)){
                  EasyLoading.dismiss();

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("알림"),
                        content: Text("아이디는 영어,숫자,특수문자만 입력할 수 있습니다."),
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
              }

              for(int i = 0; i<password_textfield.text.length; i++){
                String text = password_textfield.text[i];
                if(!validateNumber(text) && !validateEnglishString(text) && !validateTukString(text)){
                  EasyLoading.dismiss();

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("알림"),
                        content: Text("비밀번호는 영어,숫자,특수문자만 입력할 수 있습니다."),
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
              }

              bool is_error = false;

              try {
                UserCredential _userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: "${id_textfield.text}123@gmail.com",
                  password: password_textfield.text,
                );
              } on FirebaseAuthException catch (e) {
                EasyLoading.dismiss();

                is_error = true;

                if (e.code == 'weak-password') {
                  //EasyLoading.dismiss();

                  showDialog<String>(
                      context: context,
                      builder: (context) =>
                          AlertDialog(
                            title: Text("알림"),
                            content: Text("보안이 약한 비밀번호입니다.\n비밀번호를 바꿔주세요."),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context),
                                child: Text("확인"),
                              ),
                            ],
                          )
                  );
                } else if (e.code == 'email-already-in-use') {
                  //EasyLoading.dismiss();

                  showDialog<String>(
                      context: context,
                      builder: (context) =>
                          AlertDialog(
                            title: Text("알림"),
                            content: Text("이미 존재하는 아이디 입니다.\n다른 아이디로 바꿔주세요."),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context),
                                child: Text("확인"),
                              ),
                            ],
                          )
                  );
                } else{
                  //EasyLoading.dismiss();

                  showDialog<String>(
                      context: context,
                      builder: (context) =>
                          AlertDialog(
                            title: Text("알림"),
                            content: Text("회원가입에 실패하셨습니다.\n인터넷 연결을 확인해주세요."),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context),
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

              bool is_manager = false;

              if(id_textfield.text.contains(".manager")){
                is_manager = true;
              }

              await firestoreInstance
                  .collection("users")
                  .doc(id_textfield.text)
                  .set(
                  {
                    "name" : name_textfield.text,
                    "id" : id_textfield.text,
                    "password" : password_textfield.text,
                    "is_manager" : is_manager,
                  });

              tiny_db.setString("user_id", id_textfield.text);

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
                                  hintText: "5~15자, 영어/숫자/특수문자만",
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
                                  hintText: "5~20자, 영어/숫자/특수문자만",
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
                    Divider(),
                    SizedBox(
                      height: 40.0,
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 120.0,
                              child: Text(
                                "비밀번호 확인",
                                style: TextStyle(
                                  color: Color(CtTheme.black_color),
                                  fontSize: CtTheme.small_font_size,
                                ),
                              ),
                            ),
                            SizedBox(width: CtTheme.small_padding,),
                            Expanded(
                              child: TextField(
                                controller: password_check_textfield,
                                style: TextStyle(
                                  color: Color(CtTheme.black_color),
                                  fontSize: CtTheme.small_font_size,
                                ),
                                decoration: InputDecoration.collapsed(
                                  hintText: "비밀번호 확인",
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
                    Divider(),
                    SizedBox(
                      height: 40.0,
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 80.0,
                              child: Text(
                                "이름",
                                style: TextStyle(
                                  color: Color(CtTheme.black_color),
                                  fontSize: CtTheme.small_font_size,
                                ),
                              ),
                            ),
                            SizedBox(width: CtTheme.small_padding,),
                            Expanded(
                              child: TextField(
                                controller: name_textfield,
                                style: TextStyle(
                                  color: Color(CtTheme.black_color),
                                  fontSize: CtTheme.small_font_size,
                                ),
                                decoration: InputDecoration.collapsed(
                                  hintText: "1~10자",
                                  hintStyle: TextStyle(
                                    color: Color(CtTheme.dark_gray_color),
                                    fontSize: CtTheme.small_font_size,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
                                "식별코드",
                                style: TextStyle(
                                  color: Color(CtTheme.black_color),
                                  fontSize: CtTheme.small_font_size,
                                ),
                              ),
                            ),
                            SizedBox(width: CtTheme.small_padding,),
                            Expanded(
                              child: TextField(
                                controller: uid_textfield,
                                style: TextStyle(
                                  color: Color(CtTheme.black_color),
                                  fontSize: CtTheme.small_font_size,
                                ),
                                decoration: InputDecoration.collapsed(
                                  hintText: "숫자 6자",
                                  hintStyle: TextStyle(
                                    color: Color(CtTheme.dark_gray_color),
                                    fontSize: CtTheme.small_font_size,
                                  ),
                                ),
                                obscureText: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}