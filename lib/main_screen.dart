import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:newcomer/add_new_comer_screen.dart';
import 'package:newcomer/guide_screen.dart';
import 'package:newcomer/my.dart';
import 'package:newcomer/new_comer_info_screen.dart';
import 'package:path_provider/path_provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final firestoreInstance = FirebaseFirestore.instance;

  List<bool> is_manager_list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(CtTheme.light_gray_color),
      appBar: AppBar(
        centerTitle: true,
        //automaticallyImplyLeading: false,
        title: Text(
          "수원동부교회 새가족부",
          style: TextStyle(
            color: Color(CtTheme.black_color),
            fontSize: CtTheme.small_font_size,
          ),
        ),
        actions: <Widget>[
          FutureBuilder(
            future: firestoreInstance
                .collection("users")
                .doc(tiny_db.getString("user_id"))
                .get().then(
                    (value) => value
            ),
            builder: (context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot){
              if(snapshot.hasData){
                if(snapshot.data!["is_manager"]){
                  return IconButton(
                    icon: Icon(
                      Icons.upload_file,
                      color: Color(CtTheme.black_color),
                    ),
                    onPressed: () {
                      showDialog<String>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("알림"),
                            content: Text("xlsx파일을 추출하시겠습니까?"),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("아니요"),
                              ),
                              TextButton(
                                onPressed: () async{
                                  dynamic xlsx_file_path = await generateXlsx();

                                  if(xlsx_file_path == 0){
                                    await showDialog<String>(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text("알림"),
                                          content: SelectableText("파일 선택이 취소되었습니다"),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: Text("확인"),
                                            ),
                                          ],
                                        )
                                    );
                                  }
                                  else{
                                    await showDialog<String>(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text("알림"),
                                          content: SelectableText("완료!\nxlsx파일이 추출되었습니다\n(저장경로: ${xlsx_file_path})"),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: Text("확인"),
                                            ),
                                          ],
                                        )
                                    );
                                  }

                                  Navigator.pop(context);
                                },
                                child: Text("예"),
                              ),
                            ],
                          )
                      );
                    },
                  );
                }
                else{
                  return SizedBox();
                }
              }
              else{
                return CircularProgressIndicator(
                  color: Color(CtTheme.black_color),
                );
              }
            },
          ),
          IconButton(
            icon: Icon(
              Icons.add,
              color: Color(CtTheme.black_color),
            ),
            onPressed: () async{
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddNewPersonScreen()),
              );

              setState(() {});
            },
          ),
        ],
        backgroundColor: Color(CtTheme.white_color),
        iconTheme: IconThemeData(color: Color(CtTheme.black_color)),
      ),
      drawer: Drawer(
        child: FutureBuilder(
          future: firestoreInstance
              .collection("users")
              .doc(tiny_db.getString("user_id"))
              .get().then(
                  (value) => value
          ),
          builder: (context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>> > snapshot){
            if(snapshot.hasData){
              return ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                      padding: EdgeInsets.all(CtTheme.middle_padding),
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data!["name"],
                              style: TextStyle(
                                color: Color(CtTheme.white_color),
                                fontSize: CtTheme.small_font_size,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Builder(
                              builder: (context){
                                if(snapshot.data!["is_manager"]){
                                  return Text(
                                    "관리자",
                                    style: TextStyle(
                                      color: Color(CtTheme.white_color),
                                      fontSize: CtTheme.small_font_size,
                                    ),
                                  );
                                }
                                else{
                                  return SizedBox();
                                }
                              },
                            )
                          ],
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Color(CtTheme.primary_color),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        "구성원",
                        style: TextStyle(
                          color: Color(CtTheme.black_color),
                          fontSize: CtTheme.small_font_size,
                        ),
                      ),
                      trailing: FutureBuilder(
                        future: firestoreInstance
                          .collection("users")
                          .doc(tiny_db.getString("user_id"))
                          .get().then((value) => value),
                        builder: (context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot){
                          if(snapshot.hasData){
                            if(snapshot.data!["is_manager"]){
                              return Text(
                                "관리자 여부",
                                style: TextStyle(
                                  color: Color(CtTheme.black_color),
                                  fontSize: CtTheme.small_font_size,
                                ),
                              );
                            }
                            else{
                              return SizedBox();
                            }
                          }
                          else{
                            return SizedBox();
                          }
                        },
                      ),
                    ),
                    FutureBuilder(
                      future: firestoreInstance
                          .collection("users")
                          .get().then(
                              (value) => value
                      ),
                      builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> _snapshot){
                        if(_snapshot.hasData){
                          List<ListTile> widgets = [];

                          for(int index = 0; index < _snapshot.data!.docs.length; index++){
                            is_manager_list.add(_snapshot.data!.docs[index]["is_manager"]);

                            widgets.add(
                                ListTile(
                                  leading: Icon(
                                    Icons.face,
                                    color: Color(CtTheme.black_color),
                                  ),
                                  title: Text(
                                    _snapshot.data!.docs[index]["name"],
                                    style: TextStyle(
                                      color: Color(CtTheme.black_color),
                                      fontSize: CtTheme.small_font_size,
                                    ),
                                  ),
                                  trailing: Builder(
                                    builder: (context){
                                      dynamic? on_changed = (value) async{
                                        await firestoreInstance
                                            .collection("users")
                                            .doc(_snapshot.data!.docs[index]["id"])
                                            .update(
                                            {
                                              "is_manager" : value
                                            }
                                        );

                                        is_manager_list[index] = value;

                                        setState(() {});
                                      };

                                      if(!snapshot.data!["is_manager"]){
                                        return SizedBox();
                                      }

                                      if(tiny_db.getString("user_id") != _snapshot.data!.docs[index]["id"]){
                                        return Switch(
                                          value: is_manager_list[index],
                                          onChanged: on_changed,
                                        );
                                      }
                                      else{
                                        return SizedBox();
                                      }
                                    },
                                  ),
                                )
                            );
                          }

                          return Container(
                            width: double.infinity,
                            child: Column(
                              children: widgets,
                            ),
                          );
                        }
                        else{
                          return Container(
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Color(CtTheme.black_color),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    Divider(),
                    ListTile(
                      title: Text(
                        "설정",
                        style: TextStyle(
                          color: Color(CtTheme.black_color),
                          fontSize: CtTheme.small_font_size,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.exit_to_app,
                        color: Color(CtTheme.black_color),
                      ),
                      title: Text(
                        "로그아웃",
                        style: TextStyle(
                          color: Color(CtTheme.black_color),
                          fontSize: CtTheme.small_font_size,
                        ),
                      ),
                      onTap: () {
                        showDialog<String>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("알림"),
                              content: Text("로그아웃 하시겠습니까?"),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("아니요"),
                                ),
                                TextButton(
                                  onPressed: () async{
                                    EasyLoading.show(status: "로그아웃 중...");

                                    await FirebaseAuth.instance.signOut();
                                    tiny_db.remove("user_id");

                                    EasyLoading.dismiss();

                                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                        GuideScreen()), (Route<dynamic> route) => false);
                                  },
                                  child: Text("예"),
                                ),
                              ],
                            )
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.delete_forever,
                        color: Color(CtTheme.black_color),
                      ),
                      title: Text(
                        "회원탈퇴",
                        style: TextStyle(
                          color: Color(CtTheme.black_color),
                          fontSize: CtTheme.small_font_size,
                        ),
                      ),
                      onTap: () {
                        showDialog<String>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("알림"),
                              content: Text("정말로 계정을 삭제하시겠습니까?\n다시 되돌릴 수 없습니다."),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("아니요"),
                                ),
                                TextButton(
                                  onPressed: () async{
                                    EasyLoading.show(status: "계정삭제 중...");

                                    await FirebaseAuth.instance.currentUser!.delete();
                                    await firestoreInstance
                                        .collection("users")
                                        .doc(tiny_db.getString("user_id"))
                                        .delete();
                                    tiny_db.remove("user_id");

                                    EasyLoading.dismiss();

                                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                        GuideScreen()), (Route<dynamic> route) => false);
                                  },
                                  child: Text("예"),
                                ),
                              ],
                            )
                        );
                      },
                    ),
                  ]
              );
            }
            else{
              return Center(
                child: CircularProgressIndicator(
                  color: Color(CtTheme.black_color),
                ),
              );
            }
          },
        ),
      ),
      body: FutureBuilder(
        future: firestoreInstance
            .collection("new_comers")
            .orderBy("enr_date", descending: true)
            .get().then(
                (value) => value
        ),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot){
          if(snapshot.hasData){
            var new_comer_list = snapshot.data?.docs;

            return ListView.separated(
              padding: EdgeInsets.all(CtTheme.middle_padding),
              itemCount: new_comer_list!.length,
              itemBuilder: (context, index){
                String id = new_comer_list[index]["id"];

                DateTime enr_date = new_comer_list[index]["enr_date"].toDate();
                String name = new_comer_list[index]["name"];
                Sex sex = calStringToEnum(new_comer_list[index]["sex"]); String? sex_display_text = calSexToDisplayText(sex);
                DateTime birth_date = new_comer_list[index]["birth_date"].toDate();
                SunMoon sun_moon = calStringToEnum(new_comer_list[index]["sun_moon"]); String? sun_moon_display_text = calSunMoonToDisplayText(sun_moon);
                int age = DateTime.now().year - birth_date.year + 1;
                EnrType enr_type = calStringToEnum(new_comer_list[index]["enr_type"]); String? enr_type_display_text = calEnrTypeToDisplayText(enr_type);
                String enr_boss = new_comer_list[index]["enr_boss"];

                if(sun_moon == SunMoon.sun){
                  sun_moon_display_text = "+";
                }
                else if(sun_moon == SunMoon.moon){
                  sun_moon_display_text = "-";
                }

                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Color(CtTheme.white_color)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(CtTheme.middle_radius),
                          )
                      ),
                    ),
                    child: Container(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: CtTheme.small_padding-10,
                          right: CtTheme.small_padding-10,
                          top: CtTheme.small_padding,
                          bottom: CtTheme.small_padding,
                        ),
                        child: Container(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "등록일자: ${enr_date.month}/${enr_date.day}",
                                style: TextStyle(
                                  color: Color(CtTheme.black_color),
                                  fontSize: CtTheme.small_font_size,
                                ),
                              ),
                              Text(
                                "${name}(${sex_display_text?.substring(0, 1)})",
                                style: TextStyle(
                                  color: Color(CtTheme.black_color),
                                  fontSize: CtTheme.middle_font_size,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10.0,),
                              Text(
                                "생년월일: ${sun_moon_display_text}${birth_date.year}/${birth_date.month}/${birth_date.day} (${age}세)",
                                style: TextStyle(
                                  color: Color(CtTheme.black_color),
                                  fontSize: CtTheme.small_font_size,
                                ),
                              ),
                              Text(
                                "등록유형: ${enr_type_display_text}",
                                style: TextStyle(
                                  color: Color(CtTheme.black_color),
                                  fontSize: CtTheme.small_font_size,
                                ),
                              ),
                              Text(
                                "등록대표: ${enr_boss}",
                                style: TextStyle(
                                  color: Color(CtTheme.black_color),
                                  fontSize: CtTheme.small_font_size,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    onPressed: () async{
                      await showDialog<String>(
                          context: context,
                          builder: (context) => AlertDialog(
                            actions: <Widget>[
                              SizedBox(
                                width: double.infinity,
                                child: TextButton(
                                  onPressed: () async{
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => NewComerInfoScreen([true, true, false, false, false], "세부등록", id)),
                                    );

                                    Navigator.pop(context);

                                    setState(() {});
                                  },
                                  child: Text(
                                    "세부등록",
                                    style: TextStyle(
                                      color: Color(CtTheme.black_color),
                                      fontSize: CtTheme.small_font_size,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: TextButton(
                                  onPressed: () async{
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => NewComerInfoScreen([true, false, true, false, false], "출석체크", id)),
                                    );

                                    Navigator.pop(context);

                                    setState(() {});
                                  },
                                  child: Text(
                                    "출석체크",
                                    style: TextStyle(
                                      color: Color(CtTheme.black_color),
                                      fontSize: CtTheme.small_font_size,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: TextButton(
                                  onPressed: () async{
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => NewComerInfoScreen([true, true, false, false, true], "면담기록", id)),
                                    );

                                    Navigator.pop(context);

                                    setState(() {});
                                  },
                                  child: Text(
                                    "면담기록",
                                    style: TextStyle(
                                      color: Color(CtTheme.black_color),
                                      fontSize: CtTheme.small_font_size,
                                    ),
                                  ),
                                ),
                              ),
                              FutureBuilder(
                                future: firestoreInstance
                                    .collection("users")
                                    .doc(tiny_db.getString("user_id"))
                                    .get().then(
                                        (value) => value
                                ),
                                builder: (context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> _snapshot){
                                  if(_snapshot.hasData){
                                    return Builder(
                                        builder: (context) {
                                          if(_snapshot.data!["is_manager"]){
                                            return SizedBox(
                                              width: double.infinity,
                                              child: TextButton(
                                                onPressed: () async{
                                                  await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => NewComerInfoScreen([true, true, true, true, true], "관리자 권한", id)),
                                                  );

                                                  Navigator.pop(context);

                                                  setState(() {});
                                                },
                                                child: Text(
                                                  "관리자 권한",
                                                  style: TextStyle(
                                                    color: Color(CtTheme.black_color),
                                                    fontSize: CtTheme.small_font_size,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                          else{
                                            return SizedBox();
                                          }
                                        }
                                    );
                                  }
                                  else{
                                    return SizedBox(
                                      width: double.infinity,
                                      child: Container(
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: Color(CtTheme.black_color),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          )
                      );

                      setState(() {});
                    },
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(height: CtTheme.middle_padding,);
              },
            );
          }
          else{
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<dynamic> generateXlsx() async {
    EasyLoading.show(status: "파일 경로 선택 중...");

    String? selected_directory = await FilePicker.platform.getDirectoryPath();

    EasyLoading.dismiss();

    if (selected_directory == null) {
      return 0;
    }

    EasyLoading.show(status: "xlsx파일 추출 중...");

    final excel = Excel.createExcel();
    final Sheet sheet = excel[excel.getDefaultSheet()!];

    var data = (await firestoreInstance
        .collection("new_comers")
        .orderBy("enr_date", descending: false)
        .get().then(
            (value) => value
    )).docs;

    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0))
        .value = "No";
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0))
        .value = "등록일자";
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0))
        .value = "등록유형";
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 0))
        .value = "이름";
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 0))
        .value = "성별";
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: 0))
        .value = "생년월일";
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: 0))
        .value = "전도회";
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: 0))
        .value = "양력/음력";
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: 0))
        .value = "전화번호";
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: 0))
        .value = "등록대표";

    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 10, rowIndex: 0))
        .value = "결혼여부";
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 11, rowIndex: 0))
        .value = "주소";
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 12, rowIndex: 0))
        .value = "지역";
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 13, rowIndex: 0))
        .value = "직장";
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 14, rowIndex: 0))
        .value = "취미(특기)";
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 15, rowIndex: 0))
        .value = "학력";
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 16, rowIndex: 0))
        .value = "인도자";
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 17, rowIndex: 0))
        .value = "신급";
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 18, rowIndex: 0))
        .value = "이전교회";
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 19, rowIndex: 0))
        .value = "직분";
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 20, rowIndex: 0))
        .value = "섬김부서";
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 21, rowIndex: 0))
        .value = "멘토";

    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 22, rowIndex: 0))
        .value = "교육상태";
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 23, rowIndex: 0))
        .value = "교육 1차";
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 24, rowIndex: 0))
        .value = "교육 2차";
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 25, rowIndex: 0))
        .value = "교육 3차";
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 26, rowIndex: 0))
        .value = "교육 4차";
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 27, rowIndex: 0))
        .value = "교육 5차";
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 28, rowIndex: 0))
        .value = "예배 출석 현황";

    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 29, rowIndex: 0))
        .value = "수료식 여부";
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 30, rowIndex: 0))
        .value = "가정교회 배치현황";
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 31, rowIndex: 0))
        .value = "등록카드 사진";
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 32, rowIndex: 0))
        .value = "새가족 사진";

    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 33, rowIndex: 0))
        .value = "등록동기";
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 34, rowIndex: 0))
        .value = "신앙생활";
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 35, rowIndex: 0))
        .value = "자녀관련";
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 36, rowIndex: 0))
        .value = "가정생활";
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 37, rowIndex: 0))
        .value = "직장관련";
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 38, rowIndex: 0))
        .value = "기도제목";
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 39, rowIndex: 0))
        .value = "기타의견";

    for (var row_index = 1; row_index < data.length+1; row_index++) {
      var new_comer = data[row_index-1];

      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row_index))
          .value = "${row_index}";
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row_index))
          .value = calDateTimeToString(new_comer["enr_date"].toDate());
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row_index))
          .value = calEnrTypeToDisplayText(calStringToEnum(new_comer["enr_type"]));
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row_index))
          .value = new_comer["name"];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row_index))
          .value = calSexToDisplayText(calStringToEnum(new_comer["sex"]));
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: row_index))
          .value = calDateTimeToString(new_comer["birth_date"].toDate());
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: row_index))
          .value = new_comer["evange"];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: row_index))
          .value = calSunMoonToDisplayText(calStringToEnum(new_comer["sun_moon"]));
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: row_index))
          .value = new_comer["call_number"];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: row_index))
          .value = new_comer["enr_boss"];

      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 10, rowIndex: row_index))
          .value = calIsMarryToDisplayText(calStringToEnum(new_comer["is_marry"]));
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 11, rowIndex: row_index))
          .value = new_comer["address"];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 12, rowIndex: row_index))
          .value = new_comer["area"];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 13, rowIndex: row_index))
          .value = new_comer["job"];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 14, rowIndex: row_index))
          .value = new_comer["hobby"];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 15, rowIndex: row_index))
          .value = calSchoolToDisplayText(calStringToEnum(new_comer["school"]));
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 16, rowIndex: row_index))
          .value = new_comer["guider"];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 17, rowIndex: row_index))
          .value = calBapLevelToDisplayText(calStringToEnum(new_comer["bap_level"]));
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 18, rowIndex: row_index))
          .value = new_comer["pre_church"];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 19, rowIndex: row_index))
          .value = calRoleToDisplayText(calStringToEnum(new_comer["role"]));
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 20, rowIndex: row_index))
          .value = new_comer["service_part"];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 21, rowIndex: row_index))
          .value = new_comer["mento"];

      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 22, rowIndex: row_index))
          .value = calEduLevelToDisplayText(calStringToEnum(new_comer["edu_level"]));

      String edu_1_date_display_text = "미교육";
      String edu_2_date_display_text = "미교육";
      String edu_3_date_display_text = "미교육";
      String edu_4_date_display_text = "미교육";
      String edu_5_date_display_text = "미교육";

      if(new_comer["edu_state"][0] != 0){
        edu_1_date_display_text = "${(new_comer["edu_state"][0]["date"]).toDate().month}/${(new_comer["edu_state"][0]["date"]).toDate().day}";
      }
      if(new_comer["edu_state"][1] != 0){
        edu_2_date_display_text = "${(new_comer["edu_state"][1]["date"]).toDate().month}/${(new_comer["edu_state"][1]["date"]).toDate().day}";
      }
      if(new_comer["edu_state"][2] != 0){
        edu_3_date_display_text = "${(new_comer["edu_state"][2]["date"]).toDate().month}/${(new_comer["edu_state"][2]["date"]).toDate().day}";
      }
      if(new_comer["edu_state"][3] != 0){
        edu_4_date_display_text = "${(new_comer["edu_state"][3]["date"]).toDate().month}/${(new_comer["edu_state"][3]["date"]).toDate().day}";
      }
      if(new_comer["edu_state"][4] != 0){
        edu_5_date_display_text = "${(new_comer["edu_state"][4]["date"]).toDate().month}/${(new_comer["edu_state"][4]["date"]).toDate().day}";
      }

      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 23, rowIndex: row_index))
          .value = edu_1_date_display_text;
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 24, rowIndex: row_index))
          .value = edu_2_date_display_text;
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 25, rowIndex: row_index))
          .value = edu_3_date_display_text;
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 26, rowIndex: row_index))
          .value = edu_4_date_display_text;
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 27, rowIndex: row_index))
          .value = edu_5_date_display_text;

      String attend_worship_display_text = "";
      var attend_worship_state_data = new_comer["attend_worship_state"];
      for(int i = 0; i < attend_worship_state_data.length; i++){
        String sep_text = ", ";
        if(i == 0){
          sep_text = "";
        }

        attend_worship_display_text =
            attend_worship_display_text +
                sep_text +
                "${(attend_worship_state_data[i]["date"]).toDate().month}/${(attend_worship_state_data[i]["date"]).toDate().day}\n${calAttendWorshipTypeToDisplayText(calStringToEnum(attend_worship_state_data[i]["type"]))}";
      }
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 28, rowIndex: row_index))
          .value = attend_worship_display_text;

      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 29, rowIndex: row_index))
          .value = calIsCeremonyToDisplayText(calStringToEnum(new_comer["is_ceremony"]));
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 30, rowIndex: row_index))
          .value = new_comer["matching"];

      String enr_card_file_url_data = "";
      String new_comer_img_file_url_data = "";

      if(new_comer["enr_card_file_url"] != ""){
        enr_card_file_url_data = await FirebaseStorage.instance
            .ref(new_comer["enr_card_file_url"])
            .getDownloadURL();
      }
      if(new_comer["new_comer_img_file_url"] != ""){
        new_comer_img_file_url_data = await FirebaseStorage.instance
            .ref(new_comer["new_comer_img_file_url"])
            .getDownloadURL();
      }

      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 31, rowIndex: row_index))
          .value = enr_card_file_url_data;
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 32, rowIndex: row_index))
          .value = new_comer_img_file_url_data;

      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 33, rowIndex: row_index))
          .value = new_comer["enr_motiv"];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 34, rowIndex: row_index))
          .value = new_comer["follow_life"];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 35, rowIndex: row_index))
          .value = new_comer["child_related"];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 36, rowIndex: row_index))
          .value = new_comer["home_life"];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 37, rowIndex: row_index))
          .value = new_comer["job_related"];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 38, rowIndex: row_index))
          .value = new_comer["pray_list"];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 39, rowIndex: row_index))
          .value = new_comer["other_opinion"];
    }

    var file_bytes = excel.save();

    String file_path = await new Directory(selected_directory!).create(recursive: true)
        .then((Directory directory) {
      String _file_path = "${directory.path}/수원동부교회_새가족부_새가족명단_${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}.xlsx";

      File(_file_path)
        ..createSync(recursive: true)
        ..writeAsBytesSync(file_bytes!);

      return _file_path;
    });

    EasyLoading.dismiss();

    return file_path;
  }

  String calDateTimeToString(DateTime value){
    String year = value.year.toString();
    String month = value.month.toString();
    String day = value.day.toString();

    if(month.length == 1){
      month = "0" + month;
    }
    if(day.length == 1){
      day = "0" + day;
    }

    return year+month+day;
  }
}