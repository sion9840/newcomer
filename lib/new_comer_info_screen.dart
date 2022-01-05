import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_linear_datepicker/flutter_datepicker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newcomer/my.dart';

class NewComerInfoScreen extends StatefulWidget {
  List<bool> is_show_page_list = [];
  String title = "";
  String id = "";

  NewComerInfoScreen(List<bool> _is_show_page_list, String _title, String _id){
    is_show_page_list = _is_show_page_list;
    title = _title;
    id = _id;
  }

  @override
  _NewComerInfoScreenState createState() => _NewComerInfoScreenState(is_show_page_list, title, id);
}

class _NewComerInfoScreenState extends State<NewComerInfoScreen> {
  final firestoreInstance = FirebaseFirestore.instance;

  bool is_editing_mode = false;
  List<bool> is_show_page_list = [];
  String title = "";
  String id = "";

  bool is_first_state = true;

  TextEditingController enr_date_textfield = TextEditingController(); //등록일자
  EnrType enr_type = EnrType.none; String enr_type_display_text = "";//등록유형
  TextEditingController name_textfield = TextEditingController(); //이름
  Sex sex = Sex.none; String sex_display_text = "";//성별
  TextEditingController birth_date_textfield = TextEditingController(); //생년월일
  String evange = "";
  SunMoon sun_moon = SunMoon.none; String sun_moon_display_text = "";//양력/음력
  TextEditingController call_number_textfield = TextEditingController(); //전화번호
  TextEditingController enr_boss_textfield = TextEditingController(); //등록대표

  Division division = Division.none; String division_display_text = "";//구분
  IsMarry is_marry = IsMarry.none; String is_marry_display_text = "";//결혼여부
  TextEditingController address_textfield = TextEditingController(); //주소

  List areas = ["선택", "반월동", "신영통", "영통", "동탄1", "동탄2", "병점", "진안동", "봉담", "향남", "기타화성", "광교", "기타수원", "기흥", "흥덕", "수지", "기타용인", "오산", "경기도", "서울", "인천", "해외", "기타"]; //지역
  String area = "선택";

  TextEditingController job_textfield = TextEditingController(); //직장
  TextEditingController hobby_textfield = TextEditingController(); //취미(특기)
  School school = School.none; String school_display_text = "";//학력
  TextEditingController guider_textfield = TextEditingController(); //인도자
  BapLevel bap_level = BapLevel.none; String bap_level_display_text = "";//신급
  TextEditingController pre_church_textfield = TextEditingController(); //이전교회(담임목사)
  Role role = Role.none; String role_display_text = "";//직분
  TextEditingController service_part_textfield = TextEditingController(); //섬김부서
  TextEditingController mento_textfield = TextEditingController(); //멘토

  EduLevel edu_level = EduLevel.none; String edu_level_display_text = "";//교육상태(교육전, 진행중, 완료)
  List edu_state = [0, 0, 0, 0, 0]; String edu_state_display_text = "";//교육현황
  List attend_worship_state = []; String attend_worship_state_display_text = "";//예배출석 현황

  ManageState manage_state = ManageState.none; String manage_state_display_text = "";//관리상태
  IsCeremony is_ceremony = IsCeremony.none; String is_ceremony_display_text = "";//수료식 여부
  TextEditingController matching_textfield = TextEditingController(); //가정교회 배치 현황
  File? enr_card_file = null; String enr_card_file_url = "";//등록카드 사진
  File? new_comer_img_file = null; String new_comer_img_file_url = "";//새가족 사진

  //멀티라인 ㄱㄱ
  TextEditingController enr_motiv_textfield = TextEditingController(); //등록동기
  TextEditingController follow_life_textfield = TextEditingController(); //신앙생활
  TextEditingController child_related_textfield = TextEditingController(); //자녀관련
  TextEditingController home_life_textfield = TextEditingController(); //가정생활
  TextEditingController job_related_textfield = TextEditingController(); //직장관련
  TextEditingController pray_list_textfield = TextEditingController(); //기도제목
  TextEditingController other_opinion_textfield = TextEditingController(); //기타의견

  _NewComerInfoScreenState(List<bool> _is_show_page_list, String _title, String _id){
    is_show_page_list = _is_show_page_list;
    title = _title;
    id = _id;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        if(is_editing_mode){
          showDialog<String>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("알림"),
                content: Text("편집을 취소하시겠습니까?"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("아니요"),
                  ),
                  TextButton(
                    onPressed: () {
                      is_editing_mode = false;
                      is_first_state = true;

                      setState(() {});

                      Navigator.pop(context);
                    },
                    child: Text("예"),
                  ),
                ],
              )
          );
        }
        else{
          Navigator.pop(context);
        }

        return false;
      },
      child: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: FutureBuilder(
          future: firestoreInstance
            .collection("new_comers")
            .doc(id)
            .get().then(
              (value) => value
          ),
          builder: (context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot){
            if(snapshot.hasData){
              var data;

              if(is_first_state){
                is_first_state = false;

                data = snapshot.data;

                enr_date_textfield.text = calDateTimeToString(data!["enr_date"].toDate());
                enr_type = calStringToEnum(data["enr_type"]); enr_type_display_text = calEnrTypeToDisplayText(enr_type)!;
                name_textfield.text = data["name"];
                sex = calStringToEnum(data["sex"]); sex_display_text = calSexToDisplayText(sex)!;
                birth_date_textfield.text = calDateTimeToString(data["birth_date"].toDate());
                evange = data["evange"];
                sun_moon = calStringToEnum(data["sun_moon"]); sun_moon_display_text = calSunMoonToDisplayText(sun_moon)!;
                call_number_textfield.text = data["call_number"];
                enr_boss_textfield.text = data["enr_boss"];

                division = calStringToEnum(data["division"]); division_display_text = calDivisionToDisplayText(division)!;
                is_marry = calStringToEnum(data["is_marry"]); is_marry_display_text = calIsMarryToDisplayText(is_marry)!;
                address_textfield.text = data["address"];
                area = data["area"];
                if(area == ""){
                  area = "선택";
                }
                job_textfield.text = data["job"];
                hobby_textfield.text = data["hobby"];
                school = calStringToEnum(data["school"]); school_display_text = calSchoolToDisplayText(school)!;
                guider_textfield.text = data["guider"];
                bap_level = calStringToEnum(data["bap_level"]); bap_level_display_text = calBapLevelToDisplayText(bap_level)!;
                pre_church_textfield.text = data["pre_church"];
                role = calStringToEnum(data["role"]); role_display_text = calRoleToDisplayText(role)!;
                service_part_textfield.text = data["service_part"];
                mento_textfield.text = data["mento"];

                edu_level = calStringToEnum(data["edu_level"]); edu_level_display_text = calEduLevelToDisplayText(edu_level)!;
                edu_state = data["edu_state"];
                attend_worship_state = data["attend_worship_state"];

                manage_state = calStringToEnum(data["manage_state"]); manage_state_display_text = calManageStateToDisplayText(manage_state)!;
                is_ceremony = calStringToEnum(data["is_ceremony"]); is_ceremony_display_text = calIsCeremonyToDisplayText(is_ceremony)!;
                matching_textfield.text = data["matching"];
                enr_card_file = null; enr_card_file_url = data["enr_card_file_url"];
                new_comer_img_file = null; new_comer_img_file_url = data["new_comer_img_file_url"];

                enr_motiv_textfield.text = data["enr_motiv"];
                follow_life_textfield.text = data["follow_life"];
                child_related_textfield.text = data["child_related"];
                home_life_textfield.text = data["home_life"];
                job_related_textfield.text = data["job_related"];
                pray_list_textfield.text = data["pray_list"];
                other_opinion_textfield.text = data["other_opinion"];
              }

              return Scaffold(
                backgroundColor: Color(CtTheme.light_gray_color),
                appBar: AppBar(
                  centerTitle: true,
                  title: Text(
                    title,
                    style: TextStyle(
                      color: Color(CtTheme.black_color),
                      fontSize: CtTheme.small_font_size,
                    ),
                  ),
                  backgroundColor: Color(CtTheme.white_color),
                  iconTheme: IconThemeData(color: Color(CtTheme.black_color)),
                  actions: <Widget>[
                    Builder(
                      builder: (context){
                        if(is_editing_mode){
                          return TextButton(
                            child: Text(
                              "저장",
                              style: TextStyle(
                                color: Color(CtTheme.primary_color),
                                fontSize: CtTheme.small_font_size,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () async{
                              EasyLoading.show(status: "저장 중...");

                              if(
                              (enr_date_textfield.text.length == 0) ||
                                  (enr_type == EnrType.none) ||
                                  (name_textfield.text.length == 0) ||
                                  (sex == Sex.none) ||
                                  (birth_date_textfield.text.length == 0) ||
                                  (sun_moon == SunMoon.none) ||
                                  (call_number_textfield.text.length == 0) ||
                                  (enr_boss_textfield.text.length == 0)
                              ){
                                EasyLoading.dismiss();

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("알림"),
                                      content: Text("필수사항을 입력해주세요."),
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

                              if(enr_date_textfield.text.length != 8){
                                EasyLoading.dismiss();

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("알림"),
                                      content: Text("등록일자는 년월일조합의 8자 입니다. 예) 19980813"),
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

                              if(birth_date_textfield.text.length != 8){
                                EasyLoading.dismiss();

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("알림"),
                                      content: Text("생년월일은 년월일조합의 8자 입니다. 예) 19980813"),
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

                              if(call_number_textfield.text.length != 11){
                                EasyLoading.dismiss();

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("알림"),
                                      content: Text("휴대전화번호는 예시와 같이 11자 입니다. 예) 01012345678"),
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

                              if(validateNumber(enr_date_textfield.text) == false){
                                EasyLoading.dismiss();

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("알림"),
                                      content: Text("등록일자는 년월일조합의 숫자 8자 입니다. 예) 19980813"),
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

                              if(validateNumber(birth_date_textfield.text) == false){
                                EasyLoading.dismiss();

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("알림"),
                                      content: Text("생년월일은 년월일조합의 숫자 8자 입니다. 예) 19980813"),
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

                              if(validateNumber(call_number_textfield.text) == false){
                                EasyLoading.dismiss();

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("알림"),
                                      content: Text("전화번호는 숫자 11자 입니다. 예) 01012345678"),
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

                              if(isValidDate(enr_date_textfield.text) == false){
                                EasyLoading.dismiss();

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("알림"),
                                      content: Text("해당 등록일자는 존재하지 않는 날짜 입니다."),
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

                              if(isValidDate(birth_date_textfield.text) == false){
                                EasyLoading.dismiss();

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("알림"),
                                      content: Text("해당 생년월일은 존재하지 않는 날짜 입니다."),
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

                              var temp_enr_card_file_url = "new_comers/cards/${id}_enr_card.png";
                              var temp_new_comer_img_file_url = "new_comers/imgs/${id}_new_comer_img.png";

                              if(enr_card_file == null){
                                if(enr_card_file_url != ""){
                                  temp_enr_card_file_url = enr_card_file_url;
                                }
                                else{
                                  temp_enr_card_file_url = "";
                                }
                              }
                              else{
                                await FirebaseStorage.instance
                                    .ref(temp_enr_card_file_url)
                                    .putFile(enr_card_file!);
                              }

                              if(new_comer_img_file == null){
                                if(new_comer_img_file_url != ""){
                                  temp_new_comer_img_file_url = new_comer_img_file_url;
                                }
                                else{
                                  temp_new_comer_img_file_url = "";
                                }
                              }
                              else{
                                await FirebaseStorage.instance
                                    .ref(temp_new_comer_img_file_url)
                                    .putFile(new_comer_img_file!);
                              }

                              if(area == "선택"){
                                area = "";
                              }

                              await firestoreInstance
                                  .collection("new_comers")
                                  .doc(id)
                                  .update(
                                  {
                                    "id" : id,
                                    "enr_date" : calStringToDateTime(enr_date_textfield.text),
                                    "enr_type" : enr_type.toString(),
                                    "name" : name_textfield.text,
                                    "sex" : sex.toString(),
                                    "birth_date" : calStringToDateTime(birth_date_textfield.text),
                                    "evange" : evange,
                                    "sun_moon" : sun_moon.toString(),
                                    "call_number" : call_number_textfield.text,
                                    "enr_boss" : enr_boss_textfield.text,

                                    "division" : division.toString(),
                                    "is_marry" : is_marry.toString(),
                                    "address" : address_textfield.text,
                                    "area" : area,
                                    "job" : job_textfield.text,
                                    "hobby" : hobby_textfield.text,
                                    "school" : school.toString(),
                                    "guider" : guider_textfield.text,
                                    "bap_level" : bap_level.toString(),
                                    "pre_church" : pre_church_textfield.text,
                                    "role" : role.toString(),
                                    "service_part" : service_part_textfield.text,
                                    "mento" : mento_textfield.text,

                                    "edu_level" : edu_level.toString(),
                                    "edu_state" : edu_state,
                                    "attend_worship_state" : attend_worship_state,

                                    "manage_state" : manage_state.toString(),
                                    "is_ceremony" : is_ceremony.toString(),
                                    "matching" : matching_textfield.text,
                                    "enr_card_file_url" : temp_enr_card_file_url,
                                    "new_comer_img_file_url" : temp_new_comer_img_file_url,

                                    "enr_motiv" : enr_motiv_textfield.text,
                                    "follow_life" : follow_life_textfield.text,
                                    "child_related" : child_related_textfield.text,
                                    "home_life" : home_life_textfield.text,
                                    "job_related" : job_related_textfield.text,
                                    "pray_list" : pray_list_textfield.text,
                                    "other_opinion" : other_opinion_textfield.text,
                                  }
                              );

                              EasyLoading.dismiss();

                              Navigator.pop(context);
                            },
                          );
                        }
                        else{
                          return TextButton(
                            child: Text(
                              "편집",
                              style: TextStyle(
                                color: Color(CtTheme.primary_color),
                                fontSize: CtTheme.small_font_size,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              is_editing_mode = true;

                              setState(() {});
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Builder(
                                builder: (context) {
                                  if(is_show_page_list[0]){
                                    return Container(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.all(CtTheme.middle_padding),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "*",
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: CtTheme.small_font_size,
                                                  ),
                                                ),
                                                Text(
                                                  "필수사항",
                                                  style: TextStyle(
                                                    color: Color(CtTheme.black_color),
                                                    fontSize: CtTheme.small_font_size,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            color: Color(CtTheme.white_color),
                                            child: Padding(
                                              padding: EdgeInsets.all(CtTheme.middle_padding),
                                              child: Column(
                                                children: <Widget>[
                                                  Container(
                                                    height: 40.0,
                                                    child: Row(
                                                      children: <Widget>[
                                                        SizedBox(
                                                          width: 80.0,
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                "*",
                                                                style: TextStyle(
                                                                  color: Colors.red,
                                                                  fontSize: CtTheme.small_font_size,
                                                                ),
                                                              ),
                                                              Text(
                                                                "등록일자",
                                                                style: TextStyle(
                                                                  color: Color(CtTheme.black_color),
                                                                  fontSize: CtTheme.small_font_size,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: TextField(
                                                            controller: enr_date_textfield,
                                                            style: TextStyle(
                                                              color: Color(CtTheme.black_color),
                                                              fontSize: CtTheme.small_font_size,
                                                            ),
                                                            decoration: InputDecoration.collapsed(
                                                              hintText: responseEditingMode("예) 19980813"),
                                                              hintStyle: TextStyle(
                                                                color: Color(CtTheme.dark_gray_color),
                                                                fontSize: CtTheme.small_font_size,
                                                              ),
                                                            ),
                                                            enabled: is_editing_mode,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Divider(),
                                                  Container(
                                                    height: 40.0,
                                                    child: Row(
                                                      children: <Widget>[
                                                        SizedBox(
                                                          width: 80.0,
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                "*",
                                                                style: TextStyle(
                                                                  color: Colors.red,
                                                                  fontSize: CtTheme.small_font_size,
                                                                ),
                                                              ),
                                                              Text(
                                                                "등록유형",
                                                                style: TextStyle(
                                                                  color: Color(CtTheme.black_color),
                                                                  fontSize: CtTheme.small_font_size,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Text(
                                                          enr_type_display_text,
                                                          style: TextStyle(
                                                            color: Color(CtTheme.black_color),
                                                            fontSize: CtTheme.small_font_size,
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        Builder(
                                                            builder: (context) {
                                                              if(is_editing_mode){
                                                                return TextButton(
                                                                  child: Text(
                                                                    "선택",
                                                                    style: TextStyle(
                                                                      color: Color(CtTheme.primary_color),
                                                                      fontSize: CtTheme.small_font_size,
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                                  ),
                                                                  onPressed: () async{
                                                                    FocusScope.of(context).unfocus();

                                                                    await showBottomSheetOfEnrType();

                                                                    setState(() {});
                                                                  },
                                                                );
                                                              }
                                                              else{
                                                                return SizedBox();
                                                              }
                                                            }
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Divider(),
                                                  Container(
                                                    height: 40.0,
                                                    child: Row(
                                                      children: <Widget>[
                                                        SizedBox(
                                                          width: 80.0,
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                "*",
                                                                style: TextStyle(
                                                                  color: Colors.red,
                                                                  fontSize: CtTheme.small_font_size,
                                                                ),
                                                              ),
                                                              Text(
                                                                "이름",
                                                                style: TextStyle(
                                                                  color: Color(CtTheme.black_color),
                                                                  fontSize: CtTheme.small_font_size,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: TextField(
                                                            controller: name_textfield,
                                                            style: TextStyle(
                                                              color: Color(CtTheme.black_color),
                                                              fontSize: CtTheme.small_font_size,
                                                            ),
                                                            decoration: InputDecoration.collapsed(
                                                              hintText: responseEditingMode("이름"),
                                                              hintStyle: TextStyle(
                                                                color: Color(CtTheme.dark_gray_color),
                                                                fontSize: CtTheme.small_font_size,
                                                              ),
                                                            ),
                                                            enabled: is_editing_mode,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Divider(),
                                                  Container(
                                                    height: 40.0,
                                                    child: Row(
                                                      children: <Widget>[
                                                        SizedBox(
                                                          width: 80.0,
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                "*",
                                                                style: TextStyle(
                                                                  color: Colors.red,
                                                                  fontSize: CtTheme.small_font_size,
                                                                ),
                                                              ),
                                                              Text(
                                                                "성별",
                                                                style: TextStyle(
                                                                  color: Color(CtTheme.black_color),
                                                                  fontSize: CtTheme.small_font_size,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Text(
                                                          sex_display_text,
                                                          style: TextStyle(
                                                            color: Color(CtTheme.black_color),
                                                            fontSize: CtTheme.small_font_size,
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        Builder(
                                                            builder: (context) {
                                                              if(is_editing_mode){
                                                                return TextButton(
                                                                  child: Text(
                                                                    "선택",
                                                                    style: TextStyle(
                                                                      color: Color(CtTheme.primary_color),
                                                                      fontSize: CtTheme.small_font_size,
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                                  ),
                                                                  onPressed: () async{
                                                                    FocusScope.of(context).unfocus();

                                                                    await showBottomSheetOfSex();

                                                                    setState(() {});
                                                                  },
                                                                );
                                                              }
                                                              else{
                                                                return SizedBox();
                                                              }
                                                            }
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Divider(),
                                                  Container(
                                                    height: 40.0,
                                                    child: Row(
                                                      children: <Widget>[
                                                        SizedBox(
                                                          width: 80.0,
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                "*",
                                                                style: TextStyle(
                                                                  color: Colors.red,
                                                                  fontSize: CtTheme.small_font_size,
                                                                ),
                                                              ),
                                                              Text(
                                                                "생년월일",
                                                                style: TextStyle(
                                                                  color: Color(CtTheme.black_color),
                                                                  fontSize: CtTheme.small_font_size,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: TextField(
                                                            controller: birth_date_textfield,
                                                            style: TextStyle(
                                                              color: Color(CtTheme.black_color),
                                                              fontSize: CtTheme.small_font_size,
                                                            ),
                                                            decoration: InputDecoration.collapsed(
                                                              hintText: responseEditingMode("예) 19980813"),
                                                              hintStyle: TextStyle(
                                                                color: Color(CtTheme.dark_gray_color),
                                                                fontSize: CtTheme.small_font_size,
                                                              ),
                                                            ),
                                                            enabled: is_editing_mode,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Divider(),
                                                  Container(
                                                    height: 40.0,
                                                    child: Row(
                                                      children: <Widget>[
                                                        SizedBox(
                                                          width: 80.0,
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                "*",
                                                                style: TextStyle(
                                                                  color: Colors.red,
                                                                  fontSize: CtTheme.small_font_size,
                                                                ),
                                                              ),
                                                              Text(
                                                                "전도회",
                                                                style: TextStyle(
                                                                  color: Color(CtTheme.black_color),
                                                                  fontSize: CtTheme.small_font_size,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Builder(
                                                            builder: (context) {
                                                              if((birth_date_textfield.text.length != 8) ||
                                                                  (validateNumber(birth_date_textfield.text) == false) ||
                                                                  (isValidDate(birth_date_textfield.text) == false) ||
                                                                  (sex == Sex.none)
                                                              ){
                                                                return Text(
                                                                  "",
                                                                  style: TextStyle(
                                                                    color: Color(CtTheme.black_color),
                                                                    fontSize: CtTheme.small_font_size,
                                                                  ),
                                                                );
                                                              }
                                                              int new_comer_age = DateTime.now().year - calStringToDateTime(birth_date_textfield.text).year + 1;

                                                              if(sex == Sex.male){
                                                                if(new_comer_age <= 43){
                                                                  evange = "5남";
                                                                }
                                                                else if(new_comer_age <= 51){
                                                                  evange = "4남";
                                                                }
                                                                else if(new_comer_age <= 56){
                                                                  evange = "3남";
                                                                }
                                                                else if(new_comer_age <= 62){
                                                                  evange = "2남";
                                                                }
                                                                else if(new_comer_age <= 71){
                                                                  evange = "1남";
                                                                }
                                                                else{
                                                                  evange = "은록회";
                                                                }
                                                              }
                                                              else{
                                                                if(new_comer_age <= 42){
                                                                  evange = "6여";
                                                                }
                                                                else if(new_comer_age <= 48){
                                                                  evange = "5여";
                                                                }
                                                                else if(new_comer_age <= 52){
                                                                  evange = "4여";
                                                                }
                                                                else if(new_comer_age <= 55){
                                                                  evange = "3여";
                                                                }
                                                                else if(new_comer_age <= 60){
                                                                  evange = "2여";
                                                                }
                                                                else if(new_comer_age <= 71){
                                                                  evange = "1여";
                                                                }
                                                                else{
                                                                  evange = "은록회";
                                                                }
                                                              }

                                                              return Text(
                                                                evange,
                                                                style: TextStyle(
                                                                  color: Color(CtTheme.black_color),
                                                                  fontSize: CtTheme.small_font_size,
                                                                ),
                                                              );
                                                            }
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Divider(),
                                                  Container(
                                                    height: 40.0,
                                                    child: Row(
                                                      children: <Widget>[
                                                        SizedBox(
                                                          width: 90.0,
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                "*",
                                                                style: TextStyle(
                                                                  color: Colors.red,
                                                                  fontSize: CtTheme.small_font_size,
                                                                ),
                                                              ),
                                                              Text(
                                                                "양력/음력",
                                                                style: TextStyle(
                                                                  color: Color(CtTheme.black_color),
                                                                  fontSize: CtTheme.small_font_size,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Text(
                                                          sun_moon_display_text,
                                                          style: TextStyle(
                                                            color: Color(CtTheme.black_color),
                                                            fontSize: CtTheme.small_font_size,
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        Builder(
                                                            builder: (context) {
                                                              if(is_editing_mode){
                                                                return TextButton(
                                                                  child: Text(
                                                                    "선택",
                                                                    style: TextStyle(
                                                                      color: Color(CtTheme.primary_color),
                                                                      fontSize: CtTheme.small_font_size,
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                                  ),
                                                                  onPressed: () async{
                                                                    FocusScope.of(context).unfocus();

                                                                    await showBottomSheetOfSunMoon();

                                                                    setState(() {});
                                                                  },
                                                                );
                                                              }
                                                              else{
                                                                return SizedBox();
                                                              }
                                                            }
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Divider(),
                                                  Container(
                                                    height: 40.0,
                                                    child: Row(
                                                      children: <Widget>[
                                                        SizedBox(
                                                          width: 80.0,
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                "*",
                                                                style: TextStyle(
                                                                  color: Colors.red,
                                                                  fontSize: CtTheme.small_font_size,
                                                                ),
                                                              ),
                                                              Text(
                                                                "전화번호",
                                                                style: TextStyle(
                                                                  color: Color(CtTheme.black_color),
                                                                  fontSize: CtTheme.small_font_size,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: TextField(
                                                            controller: call_number_textfield,
                                                            style: TextStyle(
                                                              color: Color(CtTheme.black_color),
                                                              fontSize: CtTheme.small_font_size,
                                                            ),
                                                            decoration: InputDecoration.collapsed(
                                                              hintText: responseEditingMode("예) 01012345678"),
                                                              hintStyle: TextStyle(
                                                                color: Color(CtTheme.dark_gray_color),
                                                                fontSize: CtTheme.small_font_size,
                                                              ),
                                                            ),
                                                            enabled: is_editing_mode,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Divider(),
                                                  Container(
                                                    height: 40.0,
                                                    child: Row(
                                                      children: <Widget>[
                                                        SizedBox(
                                                          width: 80.0,
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                "*",
                                                                style: TextStyle(
                                                                  color: Colors.red,
                                                                  fontSize: CtTheme.small_font_size,
                                                                ),
                                                              ),
                                                              Text(
                                                                "등록대표",
                                                                style: TextStyle(
                                                                  color: Color(CtTheme.black_color),
                                                                  fontSize: CtTheme.small_font_size,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: TextField(
                                                            controller: enr_boss_textfield,
                                                            style: TextStyle(
                                                              color: Color(CtTheme.black_color),
                                                              fontSize: CtTheme.small_font_size,
                                                            ),
                                                            decoration: InputDecoration.collapsed(
                                                              hintText: responseEditingMode("등록대표"),
                                                              hintStyle: TextStyle(
                                                                color: Color(CtTheme.dark_gray_color),
                                                                fontSize: CtTheme.small_font_size,
                                                              ),
                                                            ),
                                                            enabled: is_editing_mode,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                  else{
                                    return SizedBox();
                                  }
                                }
                            ),
                            Builder(
                              builder: (context){
                                if(is_show_page_list[1]){
                                  return Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.all(CtTheme.middle_padding),
                                          child: Text(
                                            "세부정보",
                                            style: TextStyle(
                                              color: Color(CtTheme.black_color),
                                              fontSize: CtTheme.small_font_size,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          color: Color(CtTheme.white_color),
                                          child: Padding(
                                            padding: EdgeInsets.all(CtTheme.middle_padding),
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  height: 40.0,
                                                  child: Row(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: 80.0,
                                                        child: Text(
                                                          "소속구분",
                                                          style: TextStyle(
                                                            color: Color(CtTheme.black_color),
                                                            fontSize: CtTheme.small_font_size,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        division_display_text,
                                                        style: TextStyle(
                                                          color: Color(CtTheme.black_color),
                                                          fontSize: CtTheme.small_font_size,
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      Builder(
                                                          builder: (context) {
                                                            if(is_editing_mode){
                                                              return TextButton(
                                                                child: Text(
                                                                  "선택",
                                                                  style: TextStyle(
                                                                    color: Color(CtTheme.primary_color),
                                                                    fontSize: CtTheme.small_font_size,
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                                ),
                                                                onPressed: () async{
                                                                  FocusScope.of(context).unfocus();

                                                                  await showBottomSheetOfDivision();

                                                                  setState(() {});
                                                                },
                                                              );
                                                            }
                                                            else{
                                                              return SizedBox();
                                                            }
                                                          }
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Divider(),
                                                Container(
                                                  height: 40.0,
                                                  child: Row(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: 80.0,
                                                        child: Text(
                                                          "결혼여부",
                                                          style: TextStyle(
                                                            color: Color(CtTheme.black_color),
                                                            fontSize: CtTheme.small_font_size,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        is_marry_display_text,
                                                        style: TextStyle(
                                                          color: Color(CtTheme.black_color),
                                                          fontSize: CtTheme.small_font_size,
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      Builder(
                                                          builder: (context) {
                                                            if(is_editing_mode){
                                                              return TextButton(
                                                                child: Text(
                                                                  "선택",
                                                                  style: TextStyle(
                                                                    color: Color(CtTheme.primary_color),
                                                                    fontSize: CtTheme.small_font_size,
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                                ),
                                                                onPressed: () async{
                                                                  FocusScope.of(context).unfocus();

                                                                  await showBottomSheetOfIsMarry();

                                                                  setState(() {});
                                                                },
                                                              );
                                                            }
                                                            else{
                                                              return SizedBox();
                                                            }
                                                          }
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Divider(),
                                                Container(
                                                  height: 40.0,
                                                  child: Row(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: 80.0,
                                                        child: Text(
                                                          "주소",
                                                          style: TextStyle(
                                                            color: Color(CtTheme.black_color),
                                                            fontSize: CtTheme.small_font_size,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: TextField(
                                                          controller: address_textfield,
                                                          style: TextStyle(
                                                            color: Color(CtTheme.black_color),
                                                            fontSize: CtTheme.small_font_size,
                                                          ),
                                                          decoration: InputDecoration.collapsed(
                                                            hintText: responseEditingMode("세부주소 입력"),
                                                            hintStyle: TextStyle(
                                                              color: Color(CtTheme.dark_gray_color),
                                                              fontSize: CtTheme.small_font_size,
                                                            ),
                                                          ),
                                                          enabled: is_editing_mode,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Divider(),
                                                Container(
                                                  height: 40.0,
                                                  child: Row(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: 80.0,
                                                        child: Text(
                                                          "지역",
                                                          style: TextStyle(
                                                            color: Color(CtTheme.black_color),
                                                            fontSize: CtTheme.small_font_size,
                                                          ),
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      IgnorePointer(
                                                        ignoring: !is_editing_mode,
                                                        child: DropdownButton(
                                                          value: area,
                                                          items: areas.map((value) {
                                                            return DropdownMenuItem(
                                                              value: value,
                                                              child: Text(
                                                                  value,
                                                                  style: TextStyle(
                                                                    color: Color(CtTheme.black_color),
                                                                    fontSize: CtTheme.small_font_size,
                                                                  )
                                                              ),
                                                            );
                                                          }).toList(),
                                                          onChanged: (value) {
                                                            area = value as String;

                                                            setState(() {});
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Divider(),
                                                Container(
                                                  height: 40.0,
                                                  child: Row(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: 80.0,
                                                        child: Text(
                                                          "직장",
                                                          style: TextStyle(
                                                            color: Color(CtTheme.black_color),
                                                            fontSize: CtTheme.small_font_size,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: TextField(
                                                          controller: job_textfield,
                                                          style: TextStyle(
                                                            color: Color(CtTheme.black_color),
                                                            fontSize: CtTheme.small_font_size,
                                                          ),
                                                          decoration: InputDecoration.collapsed(
                                                            hintText: responseEditingMode("직장명"),
                                                            hintStyle: TextStyle(
                                                              color: Color(CtTheme.dark_gray_color),
                                                              fontSize: CtTheme.small_font_size,
                                                            ),
                                                          ),
                                                          enabled: is_editing_mode,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Divider(),
                                                Container(
                                                  height: 40.0,
                                                  child: Row(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: 100.0,
                                                        child: Text(
                                                          "취미(특기)",
                                                          style: TextStyle(
                                                            color: Color(CtTheme.black_color),
                                                            fontSize: CtTheme.small_font_size,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: TextField(
                                                          controller: hobby_textfield,
                                                          style: TextStyle(
                                                            color: Color(CtTheme.black_color),
                                                            fontSize: CtTheme.small_font_size,
                                                          ),
                                                          decoration: InputDecoration.collapsed(
                                                            hintText: responseEditingMode("취미(특기)"),
                                                            hintStyle: TextStyle(
                                                              color: Color(CtTheme.dark_gray_color),
                                                              fontSize: CtTheme.small_font_size,
                                                            ),
                                                          ),
                                                          enabled: is_editing_mode,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Divider(),
                                                Container(
                                                  height: 40.0,
                                                  child: Row(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: 80.0,
                                                        child: Text(
                                                          "학력",
                                                          style: TextStyle(
                                                            color: Color(CtTheme.black_color),
                                                            fontSize: CtTheme.small_font_size,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        school_display_text,
                                                        style: TextStyle(
                                                          color: Color(CtTheme.black_color),
                                                          fontSize: CtTheme.small_font_size,
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      Builder(
                                                          builder: (context) {
                                                            if(is_editing_mode){
                                                              return TextButton(
                                                                child: Text(
                                                                  "선택",
                                                                  style: TextStyle(
                                                                    color: Color(CtTheme.primary_color),
                                                                    fontSize: CtTheme.small_font_size,
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                                ),
                                                                onPressed: () async{
                                                                  FocusScope.of(context).unfocus();

                                                                  await showBottomSheetOfSchool();

                                                                  setState(() {});
                                                                },
                                                              );
                                                            }
                                                            else{
                                                              return SizedBox();
                                                            }
                                                          }
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Divider(),
                                                Container(
                                                  height: 40.0,
                                                  child: Row(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: 80.0,
                                                        child: Text(
                                                          "인도자",
                                                          style: TextStyle(
                                                            color: Color(CtTheme.black_color),
                                                            fontSize: CtTheme.small_font_size,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: TextField(
                                                          controller: guider_textfield,
                                                          style: TextStyle(
                                                            color: Color(CtTheme.black_color),
                                                            fontSize: CtTheme.small_font_size,
                                                          ),
                                                          decoration: InputDecoration.collapsed(
                                                            hintText: responseEditingMode("인도자"),
                                                            hintStyle: TextStyle(
                                                              color: Color(CtTheme.dark_gray_color),
                                                              fontSize: CtTheme.small_font_size,
                                                            ),
                                                          ),
                                                          enabled: is_editing_mode,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Divider(),
                                                Container(
                                                  height: 40.0,
                                                  child: Row(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: 80.0,
                                                        child: Text(
                                                          "신급",
                                                          style: TextStyle(
                                                            color: Color(CtTheme.black_color),
                                                            fontSize: CtTheme.small_font_size,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        bap_level_display_text,
                                                        style: TextStyle(
                                                          color: Color(CtTheme.black_color),
                                                          fontSize: CtTheme.small_font_size,
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      Builder(
                                                          builder: (context) {
                                                            if(is_editing_mode){
                                                              return TextButton(
                                                                child: Text(
                                                                  "선택",
                                                                  style: TextStyle(
                                                                    color: Color(CtTheme.primary_color),
                                                                    fontSize: CtTheme.small_font_size,
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                                ),
                                                                onPressed: () async{
                                                                  FocusScope.of(context).unfocus();

                                                                  await showBottomSheetOfBapLevel();

                                                                  setState(() {});
                                                                },
                                                              );
                                                            }
                                                            else{
                                                              return SizedBox();
                                                            }
                                                          }
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Divider(),
                                                Container(
                                                  height: 40.0,
                                                  child: Row(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: 80.0,
                                                        child: Text(
                                                          "이전교회",
                                                          style: TextStyle(
                                                            color: Color(CtTheme.black_color),
                                                            fontSize: CtTheme.small_font_size,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: TextField(
                                                          controller: pre_church_textfield,
                                                          style: TextStyle(
                                                            color: Color(CtTheme.black_color),
                                                            fontSize: CtTheme.small_font_size,
                                                          ),
                                                          decoration: InputDecoration.collapsed(
                                                            hintText: responseEditingMode("이전교회(담임목사)"),
                                                            hintStyle: TextStyle(
                                                              color: Color(CtTheme.dark_gray_color),
                                                              fontSize: CtTheme.small_font_size,
                                                            ),
                                                          ),
                                                          enabled: is_editing_mode,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Divider(),
                                                Container(
                                                  height: 40.0,
                                                  child: Row(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: 80.0,
                                                        child: Text(
                                                          "직분",
                                                          style: TextStyle(
                                                            color: Color(CtTheme.black_color),
                                                            fontSize: CtTheme.small_font_size,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        role_display_text,
                                                        style: TextStyle(
                                                          color: Color(CtTheme.black_color),
                                                          fontSize: CtTheme.small_font_size,
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      Builder(
                                                          builder: (context) {
                                                            if(is_editing_mode){
                                                              return TextButton(
                                                                child: Text(
                                                                  "선택",
                                                                  style: TextStyle(
                                                                    color: Color(CtTheme.primary_color),
                                                                    fontSize: CtTheme.small_font_size,
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                                ),
                                                                onPressed: () async{
                                                                  FocusScope.of(context).unfocus();

                                                                  await showBottomSheetOfRole();

                                                                  setState(() {});
                                                                },
                                                              );
                                                            }
                                                            else{
                                                              return SizedBox();
                                                            }
                                                          }
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Divider(),
                                                Container(
                                                  height: 40.0,
                                                  child: Row(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: 80.0,
                                                        child: Text(
                                                          "섬김부서",
                                                          style: TextStyle(
                                                            color: Color(CtTheme.black_color),
                                                            fontSize: CtTheme.small_font_size,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: TextField(
                                                          controller: service_part_textfield,
                                                          style: TextStyle(
                                                            color: Color(CtTheme.black_color),
                                                            fontSize: CtTheme.small_font_size,
                                                          ),
                                                          decoration: InputDecoration.collapsed(
                                                            hintText: responseEditingMode("예) 청소년부"),
                                                            hintStyle: TextStyle(
                                                              color: Color(CtTheme.dark_gray_color),
                                                              fontSize: CtTheme.small_font_size,
                                                            ),
                                                          ),
                                                          enabled: is_editing_mode,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Divider(),
                                                Container(
                                                  height: 40.0,
                                                  child: Row(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: 80.0,
                                                        child: Text(
                                                          "멘토",
                                                          style: TextStyle(
                                                            color: Color(CtTheme.black_color),
                                                            fontSize: CtTheme.small_font_size,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: TextField(
                                                          controller: mento_textfield,
                                                          style: TextStyle(
                                                            color: Color(CtTheme.black_color),
                                                            fontSize: CtTheme.small_font_size,
                                                          ),
                                                          decoration: InputDecoration.collapsed(
                                                            hintText: responseEditingMode("새가족 멘토 이름"),
                                                            hintStyle: TextStyle(
                                                              color: Color(CtTheme.dark_gray_color),
                                                              fontSize: CtTheme.small_font_size,
                                                            ),
                                                          ),
                                                          enabled: is_editing_mode,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                else{
                                  return SizedBox();
                                }
                              },
                            ),
                            Builder(
                              builder: (context){
                                if(is_show_page_list[2]){
                                  return Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.all(CtTheme.middle_padding),
                                          child: Text(
                                            "출석현황",
                                            style: TextStyle(
                                              color: Color(CtTheme.black_color),
                                              fontSize: CtTheme.small_font_size,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          color: Color(CtTheme.white_color),
                                          child: Padding(
                                            padding: EdgeInsets.all(CtTheme.middle_padding),
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  height: 40.0,
                                                  child: Row(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: 80.0,
                                                        child: Text(
                                                          "교육상태",
                                                          style: TextStyle(
                                                            color: Color(CtTheme.black_color),
                                                            fontSize: CtTheme.small_font_size,
                                                          ),
                                                        ),
                                                      ),
                                                      Builder(
                                                          builder: (context) {
                                                            int nothing_count = 0;
                                                            for(int i = 0; i < edu_state.length; i++){
                                                              if(edu_state[i] == 0){
                                                                nothing_count++;
                                                              }
                                                            }

                                                            if(nothing_count == 0){
                                                              edu_level = EduLevel.after;
                                                              edu_level_display_text = "완료";
                                                            }
                                                            else if(nothing_count == 5){
                                                              edu_level = EduLevel.before;
                                                              edu_level_display_text = "교육 전";
                                                            }
                                                            else{
                                                              edu_level = EduLevel.now;
                                                              edu_level_display_text = "진행 중";
                                                            }

                                                            return Text(
                                                              edu_level_display_text,
                                                              style: TextStyle(
                                                                color: Color(CtTheme.black_color),
                                                                fontSize: CtTheme.small_font_size,
                                                              ),
                                                            );
                                                          }
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Divider(),
                                                Container(
                                                  height: 80.0,
                                                  child: Row(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: 80.0,
                                                        child: Text(
                                                          "교육현황",
                                                          style: TextStyle(
                                                            color: Color(CtTheme.black_color),
                                                            fontSize: CtTheme.small_font_size,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: SingleChildScrollView(
                                                          scrollDirection: Axis.horizontal,
                                                          child: Builder(
                                                              builder: (context) {
                                                                List<Widget> edu_state_widget = [];

                                                                for(int i = 0; i<edu_state.length; i++){
                                                                  edu_state_widget.add(
                                                                      Container(
                                                                        width: 90.0,
                                                                        height: 80.0,
                                                                        child: Center(
                                                                          child: SizedBox(
                                                                            width: 80.0,
                                                                            height: 60.0,
                                                                            child: ElevatedButton(
                                                                              style: ButtonStyle(
                                                                                backgroundColor: MaterialStateProperty.all<Color>(Color(CtTheme.primary_color)),
                                                                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                                    RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius.circular(CtTheme.middle_radius),
                                                                                    )),
                                                                              ),
                                                                              child: Builder(
                                                                                  builder: (context) {
                                                                                    if(edu_state[i] == 0){
                                                                                      return Text(
                                                                                        "${i+1}차\n미교육",
                                                                                        style: TextStyle(
                                                                                          color: Color(CtTheme.white_color),
                                                                                          fontSize: CtTheme.small_font_size-2,
                                                                                        ),
                                                                                        textAlign: TextAlign.center,
                                                                                      );
                                                                                    }
                                                                                    else{
                                                                                      return Text(
                                                                                        "${i+1}차\n${(edu_state[i]["date"]).toDate().month}/${(edu_state[i]["date"]).toDate().day}",
                                                                                        style: TextStyle(
                                                                                          color: Color(CtTheme.white_color),
                                                                                          fontSize: CtTheme.small_font_size-2,
                                                                                        ),
                                                                                        textAlign: TextAlign.center,
                                                                                      );
                                                                                    }
                                                                                  }
                                                                              ),
                                                                              onPressed: () {
                                                                                if(!is_editing_mode){
                                                                                  return;
                                                                                }

                                                                                showDialog(
                                                                                  context: context,
                                                                                  builder: (BuildContext context) {
                                                                                    return AlertDialog(
                                                                                      actions: <Widget>[
                                                                                        SizedBox(
                                                                                          width: double.infinity,
                                                                                          child: FlatButton(
                                                                                            child: Text("수정"),
                                                                                            onPressed: () async{
                                                                                              await showModalBottomSheet(
                                                                                                  context: context,
                                                                                                  builder: (context){
                                                                                                    DateTime selected_date = DateTime.now();

                                                                                                    return StatefulBuilder(
                                                                                                        builder: (BuildContext context, StateSetter setState) {
                                                                                                          return Container(
                                                                                                            child: Padding(
                                                                                                              padding: EdgeInsets.all(CtTheme.middle_padding),
                                                                                                              child: Column(
                                                                                                                children: [
                                                                                                                  Spacer(),
                                                                                                                  LinearDatePicker(
                                                                                                                    yearText: "년",
                                                                                                                    monthText: "월",
                                                                                                                    dayText: "일",
                                                                                                                    dateChangeListener: (String temp_selected_date) {
                                                                                                                      List<String> date_list = temp_selected_date.split("/");

                                                                                                                      selected_date = DateTime(int.parse(date_list[0]), int.parse(date_list[1]), int.parse(date_list[2]));
                                                                                                                    },
                                                                                                                  ),
                                                                                                                  Spacer(),
                                                                                                                  SizedBox(
                                                                                                                    width: double.infinity,
                                                                                                                    height: 50.0,
                                                                                                                    child: ElevatedButton(
                                                                                                                      child: Text(
                                                                                                                        "확인",
                                                                                                                        style: TextStyle(
                                                                                                                          color: Color(CtTheme.white_color),
                                                                                                                          fontSize: CtTheme.small_font_size,
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                      style: ButtonStyle(
                                                                                                                        backgroundColor: MaterialStateProperty.all<Color>(Color(CtTheme.black_color)),
                                                                                                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                                                                            RoundedRectangleBorder(
                                                                                                                              borderRadius: BorderRadius.circular(CtTheme.small_radius),
                                                                                                                            )),
                                                                                                                      ),
                                                                                                                      onPressed: () {
                                                                                                                        if(edu_state[i] == 0){
                                                                                                                          edu_state[i] = {};
                                                                                                                        }
                                                                                                                        edu_state[i]["date"] = Timestamp.fromDate(selected_date);

                                                                                                                        Navigator.pop(context);
                                                                                                                      },
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ],
                                                                                                              ),
                                                                                                            ),
                                                                                                          );
                                                                                                        }
                                                                                                    );
                                                                                                  }
                                                                                              );

                                                                                              setState(() {});

                                                                                              Navigator.pop(context);
                                                                                            },
                                                                                          ),
                                                                                        ),
                                                                                        SizedBox(
                                                                                          width: double.infinity,
                                                                                          child: FlatButton(
                                                                                            child: Text("삭제"),
                                                                                            onPressed: () {
                                                                                              edu_state[i] = 0;

                                                                                              setState(() {});

                                                                                              Navigator.pop(context);
                                                                                            },
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    );
                                                                                  },
                                                                                );
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      )
                                                                  );
                                                                }

                                                                return Row(
                                                                  children: edu_state_widget,
                                                                );
                                                              }
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Divider(),
                                                Container(
                                                  height: 80.0,
                                                  child: Row(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: 80.0,
                                                        child: Text(
                                                          "예배 출석 현황",
                                                          style: TextStyle(
                                                            color: Color(CtTheme.black_color),
                                                            fontSize: CtTheme.small_font_size,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: SingleChildScrollView(
                                                          scrollDirection: Axis.horizontal,
                                                          child: Builder(
                                                              builder: (context) {
                                                                List<Widget> temp_attend_worship_widget = [];
                                                                List date_list = [];
                                                                List<Widget> attend_worship_widget = [];

                                                                for(int i = 0; i<attend_worship_state.length; i++){
                                                                  String temp_year = (attend_worship_state[i]["date"]).toDate().year.toString();
                                                                  String temp_month = (attend_worship_state[i]["date"]).toDate().month.toString();
                                                                  String temp_day = (attend_worship_state[i]["date"]).toDate().day.toString();

                                                                  if(temp_month.length == 1){
                                                                    temp_month = "0" + temp_month;
                                                                  }
                                                                  if(temp_day.length == 1){
                                                                    temp_day = "0" + temp_day;
                                                                  }

                                                                  date_list.add(
                                                                      int.parse(temp_year + temp_month + temp_day)
                                                                  );

                                                                  String display_text = "미참석";
                                                                  if(calStringToEnum(attend_worship_state[i]["type"]) == AttendWorshipType.on){
                                                                    display_text = "온라인";
                                                                  }
                                                                  else if(calStringToEnum(attend_worship_state[i]["type"]) == AttendWorshipType.off){
                                                                    display_text = "대면";
                                                                  }

                                                                  temp_attend_worship_widget.add(
                                                                      Container(
                                                                        width: 90.0,
                                                                        height: 80.0,
                                                                        child: Center(
                                                                          child: SizedBox(
                                                                            width: 80.0,
                                                                            height: 60.0,
                                                                            child: ElevatedButton(
                                                                              style: ButtonStyle(
                                                                                backgroundColor: MaterialStateProperty.all<Color>(Color(CtTheme.primary_color)),
                                                                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                                    RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius.circular(CtTheme.middle_radius),
                                                                                    )),
                                                                              ),
                                                                              child: Text(
                                                                                "${(attend_worship_state[i]["date"]).toDate().month}/${(attend_worship_state[i]["date"]).toDate().day}\n${display_text}",
                                                                                style: TextStyle(
                                                                                  color: Color(CtTheme.white_color),
                                                                                  fontSize: CtTheme.small_font_size-2,
                                                                                ),
                                                                                textAlign: TextAlign.center,
                                                                              ),
                                                                              onPressed: () {
                                                                                if(!is_editing_mode){
                                                                                  return;
                                                                                }

                                                                                showDialog(
                                                                                  context: context,
                                                                                  builder: (BuildContext context) {
                                                                                    return AlertDialog(
                                                                                      title: Text("알림"),
                                                                                      content: Text("삭제 하시겠습니까?"),
                                                                                      actions: <Widget>[
                                                                                        FlatButton(
                                                                                          child: Text("아니요"),
                                                                                          onPressed: () {
                                                                                            Navigator.pop(context);
                                                                                          },
                                                                                        ),
                                                                                        FlatButton(
                                                                                          child: Text("예"),
                                                                                          onPressed: () {
                                                                                            attend_worship_state.remove(attend_worship_state[i]);

                                                                                            setState(() {});

                                                                                            Navigator.pop(context);
                                                                                          },
                                                                                        ),
                                                                                      ],
                                                                                    );
                                                                                  },
                                                                                );
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      )
                                                                  );
                                                                }

                                                                List remove_index_list = [];

                                                                for(int i = 0; i<attend_worship_state.length; i++){
                                                                  int max_val = 0;
                                                                  int index = 0;
                                                                  for(int j = 0; j<attend_worship_state.length; j++){
                                                                    if(remove_index_list.contains(j)){
                                                                      continue;
                                                                    }

                                                                    if(date_list[j] > max_val){
                                                                      max_val = date_list[j];
                                                                      index = j;
                                                                    }
                                                                  }

                                                                  remove_index_list.add(index);
                                                                  attend_worship_widget.add(temp_attend_worship_widget[index]);
                                                                }

                                                                return Row(
                                                                  children: [
                                                                    Container(
                                                                      width: 90.0,
                                                                      height: 80.0,
                                                                      child: Center(
                                                                        child: SizedBox(
                                                                          width: 80.0,
                                                                          height: 60.0,
                                                                          child: ElevatedButton(
                                                                            style: ButtonStyle(
                                                                              backgroundColor: MaterialStateProperty.all<Color>(Color(CtTheme.dark_gray_color)),
                                                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                                  RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(CtTheme.middle_radius),
                                                                                  )),
                                                                            ),
                                                                            child: Icon(
                                                                              Icons.add,
                                                                              color: Color(CtTheme.white_color),
                                                                            ),
                                                                            onPressed: () async{
                                                                              if(!is_editing_mode){
                                                                                return;
                                                                              }

                                                                              await showModalBottomSheet(
                                                                                  context: context,
                                                                                  builder: (context){
                                                                                    DateTime selected_date = DateTime.now();
                                                                                    AttendWorshipType attend_worship_type = AttendWorshipType.no;

                                                                                    return StatefulBuilder(
                                                                                        builder: (BuildContext context, StateSetter setState) {
                                                                                          return Container(
                                                                                            child: Padding(
                                                                                              padding: EdgeInsets.all(CtTheme.middle_padding),
                                                                                              child: Column(
                                                                                                children: [
                                                                                                  Spacer(),
                                                                                                  LinearDatePicker(
                                                                                                    yearText: "년",
                                                                                                    monthText: "월",
                                                                                                    dayText: "일",
                                                                                                    dateChangeListener: (String temp_selected_date) {
                                                                                                      List<String> date_list = temp_selected_date.split("/");

                                                                                                      selected_date = DateTime(int.parse(date_list[0]), int.parse(date_list[1]), int.parse(date_list[2]));
                                                                                                    },
                                                                                                  ),
                                                                                                  Container(
                                                                                                    child: Column(
                                                                                                      children: <Widget>[
                                                                                                        Row(
                                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                                          children: <Widget>[
                                                                                                            Row(
                                                                                                              children: <Widget>[
                                                                                                                Radio<AttendWorshipType>(
                                                                                                                  value: AttendWorshipType.off,
                                                                                                                  groupValue: attend_worship_type,
                                                                                                                  onChanged: (AttendWorshipType? value) {
                                                                                                                    setState(() {
                                                                                                                      attend_worship_type = value!;
                                                                                                                    });
                                                                                                                  },
                                                                                                                ),
                                                                                                                Text(
                                                                                                                  '대면',
                                                                                                                  style: TextStyle(
                                                                                                                    color: Color(CtTheme.black_color),
                                                                                                                    fontSize: CtTheme.small_font_size,
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ],
                                                                                                            ),
                                                                                                            SizedBox(width: CtTheme.small_padding,),
                                                                                                            Row(
                                                                                                              children: <Widget>[
                                                                                                                Radio<AttendWorshipType>(
                                                                                                                  value: AttendWorshipType.on,
                                                                                                                  groupValue: attend_worship_type,
                                                                                                                  onChanged: (AttendWorshipType? value) {
                                                                                                                    setState(() {
                                                                                                                      attend_worship_type = value!;
                                                                                                                    });
                                                                                                                  },
                                                                                                                ),
                                                                                                                Text(
                                                                                                                  '온라인',
                                                                                                                  style: TextStyle(
                                                                                                                    color: Color(CtTheme.black_color),
                                                                                                                    fontSize: CtTheme.small_font_size,
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ],
                                                                                                            ),
                                                                                                            SizedBox(width: CtTheme.small_padding,),
                                                                                                            Row(
                                                                                                              children: <Widget>[
                                                                                                                Radio<AttendWorshipType>(
                                                                                                                  value: AttendWorshipType.no,
                                                                                                                  groupValue: attend_worship_type,
                                                                                                                  onChanged: (AttendWorshipType? value) {
                                                                                                                    setState(() {
                                                                                                                      attend_worship_type = value!;
                                                                                                                    });
                                                                                                                  },
                                                                                                                ),
                                                                                                                Text(
                                                                                                                  '미참석',
                                                                                                                  style: TextStyle(
                                                                                                                    color: Color(CtTheme.black_color),
                                                                                                                    fontSize: CtTheme.small_font_size,
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ],
                                                                                                            ),
                                                                                                          ],
                                                                                                        )
                                                                                                      ],
                                                                                                    ),
                                                                                                  ),
                                                                                                  Spacer(),
                                                                                                  SizedBox(
                                                                                                    width: double.infinity,
                                                                                                    height: 50.0,
                                                                                                    child: ElevatedButton(
                                                                                                      child: Text(
                                                                                                        "확인",
                                                                                                        style: TextStyle(
                                                                                                          color: Color(CtTheme.white_color),
                                                                                                          fontSize: CtTheme.small_font_size,
                                                                                                        ),
                                                                                                      ),
                                                                                                      style: ButtonStyle(
                                                                                                        backgroundColor: MaterialStateProperty.all<Color>(Color(CtTheme.black_color)),
                                                                                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                                                            RoundedRectangleBorder(
                                                                                                              borderRadius: BorderRadius.circular(CtTheme.small_radius),
                                                                                                            )),
                                                                                                      ),
                                                                                                      onPressed: () {
                                                                                                        var temp = {};
                                                                                                        temp["date"] = selected_date;
                                                                                                        temp["type"] = attend_worship_type.toString();

                                                                                                        attend_worship_state.add(temp);

                                                                                                        Navigator.pop(context);
                                                                                                      },
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                          );
                                                                                        }
                                                                                    );
                                                                                  }
                                                                              );

                                                                              setState(() {});
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Row(
                                                                      children: attend_worship_widget,
                                                                    ),
                                                                  ],
                                                                );
                                                              }
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                else{
                                  return SizedBox();
                                }
                              },
                            ),
                            Builder(
                              builder: (context){
                                if(is_show_page_list[3]){
                                  return Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.all(CtTheme.middle_padding),
                                          child: Text(
                                            "관리",
                                            style: TextStyle(
                                              color: Color(CtTheme.black_color),
                                              fontSize: CtTheme.small_font_size,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          color: Color(CtTheme.white_color),
                                          child: Padding(
                                            padding: EdgeInsets.all(CtTheme.middle_padding),
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  height: 40.0,
                                                  child: Row(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: 100.0,
                                                        child: Text(
                                                          "관리상태",
                                                          style: TextStyle(
                                                            color: Color(CtTheme.black_color),
                                                            fontSize: CtTheme.small_font_size,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        manage_state_display_text,
                                                        style: TextStyle(
                                                          color: Color(CtTheme.black_color),
                                                          fontSize: CtTheme.small_font_size,
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      Builder(
                                                          builder: (context) {
                                                            if(is_editing_mode){
                                                              return TextButton(
                                                                child: Text(
                                                                  "선택",
                                                                  style: TextStyle(
                                                                    color: Color(CtTheme.primary_color),
                                                                    fontSize: CtTheme.small_font_size,
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                                ),
                                                                onPressed: () async{
                                                                  FocusScope.of(context).unfocus();

                                                                  await showBottomSheetOfManageState();

                                                                  setState(() {});
                                                                },
                                                              );
                                                            }
                                                            else{
                                                              return SizedBox();
                                                            }
                                                          }
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Divider(),
                                                Container(
                                                  height: 40.0,
                                                  child: Row(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: 100.0,
                                                        child: Text(
                                                          "수료식 여부",
                                                          style: TextStyle(
                                                            color: Color(CtTheme.black_color),
                                                            fontSize: CtTheme.small_font_size,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        is_ceremony_display_text,
                                                        style: TextStyle(
                                                          color: Color(CtTheme.black_color),
                                                          fontSize: CtTheme.small_font_size,
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      Builder(
                                                          builder: (context) {
                                                            if(is_editing_mode){
                                                              return TextButton(
                                                                child: Text(
                                                                  "선택",
                                                                  style: TextStyle(
                                                                    color: Color(CtTheme.primary_color),
                                                                    fontSize: CtTheme.small_font_size,
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                                ),
                                                                onPressed: () async{
                                                                  FocusScope.of(context).unfocus();

                                                                  await showBottomSheetOfIsCeremony();

                                                                  setState(() {});
                                                                },
                                                              );
                                                            }
                                                            else{
                                                              return SizedBox();
                                                            }
                                                          }
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Divider(),
                                                Container(
                                                  height: 40.0,
                                                  child: Row(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: 150.0,
                                                        child: Text(
                                                          "가정교회 배치현황",
                                                          style: TextStyle(
                                                            color: Color(CtTheme.black_color),
                                                            fontSize: CtTheme.small_font_size,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: TextField(
                                                          controller: matching_textfield,
                                                          style: TextStyle(
                                                            color: Color(CtTheme.black_color),
                                                            fontSize: CtTheme.small_font_size,
                                                          ),
                                                          decoration: InputDecoration.collapsed(
                                                            hintText: responseEditingMode("미배정/OO가정교회"),
                                                            hintStyle: TextStyle(
                                                              color: Color(CtTheme.dark_gray_color),
                                                              fontSize: CtTheme.small_font_size,
                                                            ),
                                                          ),
                                                          enabled: is_editing_mode,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Divider(),
                                                Container(
                                                  height: 40.0,
                                                  child: Row(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: 120.0,
                                                        child: Text(
                                                          "등록카드 사진",
                                                          style: TextStyle(
                                                            color: Color(CtTheme.black_color),
                                                            fontSize: CtTheme.small_font_size,
                                                          ),
                                                        ),
                                                      ),
                                                      Builder(
                                                          builder: (context) {
                                                            if((enr_card_file == null) && (enr_card_file_url == "")){
                                                              return Text(
                                                                "",
                                                                style: TextStyle(
                                                                  color: Color(CtTheme.dark_gray_color),
                                                                  fontSize: CtTheme.small_font_size,
                                                                ),
                                                              );
                                                            }
                                                            else if(enr_card_file != null) {
                                                              return GestureDetector(
                                                                onTap: () {
                                                                  showModalBottomSheet(
                                                                      context: context,
                                                                      builder: (
                                                                          context) {
                                                                        return Container(
                                                                          child: Padding(
                                                                            padding: EdgeInsets
                                                                                .all(
                                                                                CtTheme
                                                                                    .middle_padding),
                                                                            child: Column(
                                                                              children: [
                                                                                Expanded(
                                                                                  child: Container(
                                                                                    decoration: BoxDecoration(
                                                                                        image: DecorationImage(
                                                                                            image: FileImage(
                                                                                                enr_card_file!),
                                                                                            fit: BoxFit
                                                                                                .contain)),
                                                                                  ),
                                                                                ),
                                                                                Builder(
                                                                                  builder: (context) {
                                                                                    if(is_editing_mode){
                                                                                      return Container(
                                                                                        child: Column(
                                                                                          children: <Widget>[
                                                                                            SizedBox(
                                                                                              height: CtTheme
                                                                                                  .middle_padding,),
                                                                                            SizedBox(
                                                                                              width: double
                                                                                                  .infinity,
                                                                                              height: 50.0,
                                                                                              child: ElevatedButton(
                                                                                                child: Text(
                                                                                                  "삭제",
                                                                                                  style: TextStyle(
                                                                                                    color: Color(
                                                                                                        CtTheme
                                                                                                            .white_color),
                                                                                                    fontSize: CtTheme
                                                                                                        .small_font_size,
                                                                                                  ),
                                                                                                ),
                                                                                                style: ButtonStyle(
                                                                                                  backgroundColor: MaterialStateProperty
                                                                                                      .all<
                                                                                                      Color>(
                                                                                                      Colors
                                                                                                          .red),
                                                                                                  shape: MaterialStateProperty
                                                                                                      .all<
                                                                                                      RoundedRectangleBorder>(
                                                                                                      RoundedRectangleBorder(
                                                                                                        borderRadius: BorderRadius
                                                                                                            .circular(
                                                                                                            CtTheme
                                                                                                                .small_radius),
                                                                                                      )),
                                                                                                ),
                                                                                                onPressed: () {
                                                                                                  enr_card_file = null;
                                                                                                  enr_card_file_url = "";

                                                                                                  setState(() {});

                                                                                                  Navigator
                                                                                                      .pop(
                                                                                                      context);
                                                                                                },
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      );
                                                                                    }
                                                                                    else{
                                                                                      return SizedBox();
                                                                                    }
                                                                                  }
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }
                                                                  );
                                                                },
                                                                child: Container(
                                                                  width: 40.0,
                                                                  height: 40.0,
                                                                  decoration: BoxDecoration(
                                                                      image: DecorationImage(
                                                                          image: FileImage(
                                                                              enr_card_file!),
                                                                          fit: BoxFit
                                                                              .cover)),
                                                                ),
                                                              );
                                                            }
                                                            else if(enr_card_file_url != "") {
                                                              return GestureDetector(
                                                                onTap: () {
                                                                  showModalBottomSheet(
                                                                      context: context,
                                                                      builder: (context) {
                                                                        return Container(
                                                                          child: Padding(
                                                                            padding: EdgeInsets
                                                                                .all(
                                                                                CtTheme
                                                                                    .middle_padding),
                                                                            child: Column(
                                                                              children: [
                                                                                Expanded(
                                                                                  child: FutureBuilder<String>(
                                                                                    future: FirebaseStorage.instance
                                                                                      .ref(enr_card_file_url)
                                                                                      .getDownloadURL(),
                                                                                    builder: (context, snapshot){
                                                                                      if(snapshot.hasData){
                                                                                        return Image.network(
                                                                                            snapshot.data!,
                                                                                          fit: BoxFit.contain,
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
                                                                                    }
                                                                                  ),
                                                                                ),
                                                                                Builder(
                                                                                  builder: (context) {
                                                                                    if(is_editing_mode){
                                                                                      return Container(
                                                                                        child: Column(
                                                                                          children: <Widget>[
                                                                                            SizedBox(
                                                                                              height: CtTheme
                                                                                                  .middle_padding,),
                                                                                            SizedBox(
                                                                                              width: double
                                                                                                  .infinity,
                                                                                              height: 50.0,
                                                                                              child: ElevatedButton(
                                                                                                child: Text(
                                                                                                  "삭제",
                                                                                                  style: TextStyle(
                                                                                                    color: Color(
                                                                                                        CtTheme
                                                                                                            .white_color),
                                                                                                    fontSize: CtTheme
                                                                                                        .small_font_size,
                                                                                                  ),
                                                                                                ),
                                                                                                style: ButtonStyle(
                                                                                                  backgroundColor: MaterialStateProperty
                                                                                                      .all<
                                                                                                      Color>(
                                                                                                      Colors
                                                                                                          .red),
                                                                                                  shape: MaterialStateProperty
                                                                                                      .all<
                                                                                                      RoundedRectangleBorder>(
                                                                                                      RoundedRectangleBorder(
                                                                                                        borderRadius: BorderRadius
                                                                                                            .circular(
                                                                                                            CtTheme
                                                                                                                .small_radius),
                                                                                                      )),
                                                                                                ),
                                                                                                onPressed: () {
                                                                                                  enr_card_file = null;
                                                                                                  enr_card_file_url = "";

                                                                                                  setState(() {});

                                                                                                  Navigator
                                                                                                      .pop(
                                                                                                      context);
                                                                                                },
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      );
                                                                                    }
                                                                                    else{
                                                                                      return SizedBox();
                                                                                    }
                                                                                  }
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }
                                                                  );
                                                                },
                                                                child: FutureBuilder<String>(
                                                                    future: FirebaseStorage.instance
                                                                        .ref(enr_card_file_url)
                                                                        .getDownloadURL(),
                                                                    builder: (context, snapshot){
                                                                      if(snapshot.hasData){
                                                                        return Image.network(
                                                                          snapshot.data!,
                                                                          fit: BoxFit.contain,
                                                                          width: 40.0,
                                                                          height: 40.0,
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
                                                                    }
                                                                ),
                                                              );
                                                            }
                                                            else{
                                                              return CircularProgressIndicator(
                                                                color: Color(CtTheme.black_color),
                                                              );
                                                            }
                                                          }
                                                      ),
                                                      Spacer(),
                                                      Builder(
                                                          builder: (context) {
                                                            if(is_editing_mode){
                                                              return TextButton(
                                                                child: Text(
                                                                  "불러오기",
                                                                  style: TextStyle(
                                                                    color: Color(CtTheme.primary_color),
                                                                    fontSize: CtTheme.small_font_size,
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                                ),
                                                                onPressed: () {
                                                                  FocusScope.of(context).unfocus();

                                                                  showDialog(
                                                                    context: context,
                                                                    builder: (BuildContext context) {
                                                                      return AlertDialog(
                                                                        actions: <Widget>[
                                                                          SizedBox(
                                                                            width: double.infinity,
                                                                            child: FlatButton(
                                                                              child: Text("카메라로 업로드"),
                                                                              onPressed: () async{
                                                                                PickedFile? f = await ImagePicker().getImage(source: ImageSource.camera);
                                                                                enr_card_file = File(f!.path);

                                                                                setState(() {});

                                                                                Navigator.pop(context);
                                                                              },
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width: double.infinity,
                                                                            child: FlatButton(
                                                                              child: Text("갤러리 사진으로 업로드"),
                                                                              onPressed: () async{
                                                                                PickedFile? f = await ImagePicker().getImage(source: ImageSource.gallery);
                                                                                enr_card_file = File(f!.path);

                                                                                setState(() {});

                                                                                Navigator.pop(context);
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                              );
                                                            }
                                                            else{
                                                              return SizedBox();
                                                            }
                                                          }
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Divider(),
                                                Container(
                                                  height: 40.0,
                                                  child: Row(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: 120.0,
                                                        child: Text(
                                                          "새가족 사진",
                                                          style: TextStyle(
                                                            color: Color(CtTheme.black_color),
                                                            fontSize: CtTheme.small_font_size,
                                                          ),
                                                        ),
                                                      ),
                                                      Builder(
                                                          builder: (context) {
                                                            if((new_comer_img_file == null) && (new_comer_img_file_url == "")){
                                                              return Text(
                                                                "",
                                                                style: TextStyle(
                                                                  color: Color(CtTheme.dark_gray_color),
                                                                  fontSize: CtTheme.small_font_size,
                                                                ),
                                                              );
                                                            }
                                                            else if(new_comer_img_file != null) {
                                                              return GestureDetector(
                                                                onTap: () {
                                                                  showModalBottomSheet(
                                                                      context: context,
                                                                      builder: (
                                                                          context) {
                                                                        return Container(
                                                                          child: Padding(
                                                                            padding: EdgeInsets
                                                                                .all(
                                                                                CtTheme
                                                                                    .middle_padding),
                                                                            child: Column(
                                                                              children: [
                                                                                Expanded(
                                                                                  child: Container(
                                                                                    decoration: BoxDecoration(
                                                                                        image: DecorationImage(
                                                                                            image: FileImage(
                                                                                                new_comer_img_file!),
                                                                                            fit: BoxFit
                                                                                                .contain)),
                                                                                  ),
                                                                                ),
                                                                                Builder(
                                                                                  builder: (context) {
                                                                                    if(is_editing_mode){
                                                                                      return Container(
                                                                                        child: Column(
                                                                                          children: <Widget>[
                                                                                            SizedBox(
                                                                                              height: CtTheme
                                                                                                  .middle_padding,),
                                                                                            SizedBox(
                                                                                              width: double
                                                                                                  .infinity,
                                                                                              height: 50.0,
                                                                                              child: ElevatedButton(
                                                                                                child: Text(
                                                                                                  "삭제",
                                                                                                  style: TextStyle(
                                                                                                    color: Color(
                                                                                                        CtTheme
                                                                                                            .white_color),
                                                                                                    fontSize: CtTheme
                                                                                                        .small_font_size,
                                                                                                  ),
                                                                                                ),
                                                                                                style: ButtonStyle(
                                                                                                  backgroundColor: MaterialStateProperty
                                                                                                      .all<
                                                                                                      Color>(
                                                                                                      Colors
                                                                                                          .red),
                                                                                                  shape: MaterialStateProperty
                                                                                                      .all<
                                                                                                      RoundedRectangleBorder>(
                                                                                                      RoundedRectangleBorder(
                                                                                                        borderRadius: BorderRadius
                                                                                                            .circular(
                                                                                                            CtTheme
                                                                                                                .small_radius),
                                                                                                      )),
                                                                                                ),
                                                                                                onPressed: () {
                                                                                                  new_comer_img_file = null;
                                                                                                  new_comer_img_file_url = "";

                                                                                                  setState(() {});

                                                                                                  Navigator
                                                                                                      .pop(
                                                                                                      context);
                                                                                                },
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      );
                                                                                    }
                                                                                    else{
                                                                                      return SizedBox();
                                                                                    }
                                                                                  }
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }
                                                                  );
                                                                },
                                                                child: Container(
                                                                  width: 40.0,
                                                                  height: 40.0,
                                                                  decoration: BoxDecoration(
                                                                      image: DecorationImage(
                                                                          image: FileImage(
                                                                              new_comer_img_file!),
                                                                          fit: BoxFit
                                                                              .cover)),
                                                                ),
                                                              );
                                                            }
                                                            else if(new_comer_img_file_url != "") {
                                                              return GestureDetector(
                                                                onTap: () {
                                                                  showModalBottomSheet(
                                                                      context: context,
                                                                      builder: (context) {
                                                                        return Container(
                                                                          child: Padding(
                                                                            padding: EdgeInsets
                                                                                .all(
                                                                                CtTheme
                                                                                    .middle_padding),
                                                                            child: Column(
                                                                              children: [
                                                                                Expanded(
                                                                                  child: FutureBuilder<String>(
                                                                                      future: FirebaseStorage.instance
                                                                                          .ref(new_comer_img_file_url)
                                                                                          .getDownloadURL(),
                                                                                      builder: (context, snapshot){
                                                                                        if(snapshot.hasData){
                                                                                          return Image.network(
                                                                                            snapshot.data!,
                                                                                            fit: BoxFit.contain,
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
                                                                                      }
                                                                                  ),
                                                                                ),
                                                                                Builder(
                                                                                  builder: (context) {
                                                                                    if(is_editing_mode){
                                                                                      return Container(
                                                                                        child: Column(
                                                                                          children: <Widget>[
                                                                                            SizedBox(
                                                                                              height: CtTheme
                                                                                                  .middle_padding,),
                                                                                            SizedBox(
                                                                                              width: double
                                                                                                  .infinity,
                                                                                              height: 50.0,
                                                                                              child: ElevatedButton(
                                                                                                child: Text(
                                                                                                  "삭제",
                                                                                                  style: TextStyle(
                                                                                                    color: Color(
                                                                                                        CtTheme
                                                                                                            .white_color),
                                                                                                    fontSize: CtTheme
                                                                                                        .small_font_size,
                                                                                                  ),
                                                                                                ),
                                                                                                style: ButtonStyle(
                                                                                                  backgroundColor: MaterialStateProperty
                                                                                                      .all<
                                                                                                      Color>(
                                                                                                      Colors
                                                                                                          .red),
                                                                                                  shape: MaterialStateProperty
                                                                                                      .all<
                                                                                                      RoundedRectangleBorder>(
                                                                                                      RoundedRectangleBorder(
                                                                                                        borderRadius: BorderRadius
                                                                                                            .circular(
                                                                                                            CtTheme
                                                                                                                .small_radius),
                                                                                                      )),
                                                                                                ),
                                                                                                onPressed: () {
                                                                                                  new_comer_img_file = null;
                                                                                                  new_comer_img_file_url = "";

                                                                                                  setState(() {});

                                                                                                  Navigator
                                                                                                      .pop(
                                                                                                      context);
                                                                                                },
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      );
                                                                                    }
                                                                                    else{
                                                                                      return SizedBox();
                                                                                    }
                                                                                  }
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }
                                                                  );
                                                                },
                                                                child: FutureBuilder<String>(
                                                                    future: FirebaseStorage.instance
                                                                        .ref(new_comer_img_file_url)
                                                                        .getDownloadURL(),
                                                                    builder: (context, snapshot){
                                                                      if(snapshot.hasData){
                                                                        return Image.network(
                                                                          snapshot.data!,
                                                                          fit: BoxFit.contain,
                                                                          width: 40.0,
                                                                          height: 40.0,
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
                                                                    }
                                                                ),
                                                              );
                                                            }
                                                            else{
                                                              return CircularProgressIndicator(
                                                                color: Color(CtTheme.black_color),
                                                              );
                                                            }
                                                          }
                                                      ),
                                                      Spacer(),
                                                      Builder(
                                                          builder: (context) {
                                                            if(is_editing_mode){
                                                              return TextButton(
                                                                child: Text(
                                                                  "불러오기",
                                                                  style: TextStyle(
                                                                    color: Color(CtTheme.primary_color),
                                                                    fontSize: CtTheme.small_font_size,
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                                ),
                                                                onPressed: () {
                                                                  FocusScope.of(context).unfocus();

                                                                  showDialog(
                                                                    context: context,
                                                                    builder: (BuildContext context) {
                                                                      return AlertDialog(
                                                                        actions: <Widget>[
                                                                          SizedBox(
                                                                            width: double.infinity,
                                                                            child: FlatButton(
                                                                              child: Text("카메라로 업로드"),
                                                                              onPressed: () async{
                                                                                PickedFile? f = await ImagePicker().getImage(source: ImageSource.camera);
                                                                                new_comer_img_file = File(f!.path);

                                                                                setState(() {});

                                                                                Navigator.pop(context);
                                                                              },
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width: double.infinity,
                                                                            child: FlatButton(
                                                                              child: Text("갤러리 사진으로 업로드"),
                                                                              onPressed: () async{
                                                                                PickedFile? f = await ImagePicker().getImage(source: ImageSource.gallery);
                                                                                new_comer_img_file = File(f!.path);

                                                                                setState(() {});

                                                                                Navigator.pop(context);
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                              );
                                                            }
                                                            else{
                                                              return SizedBox();
                                                            }
                                                          }
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                else{
                                  return SizedBox();
                                }
                              },
                            ),
                            Builder(
                              builder: (context){
                                if(is_show_page_list[4]){
                                  return Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.all(CtTheme.middle_padding),
                                          child: Text(
                                            "면담",
                                            style: TextStyle(
                                              color: Color(CtTheme.black_color),
                                              fontSize: CtTheme.small_font_size,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          color: Color(CtTheme.white_color),
                                          child: Padding(
                                            padding: EdgeInsets.all(CtTheme.middle_padding),
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  height: 200.0,
                                                  child: Row(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: 80.0,
                                                        height: double.infinity,
                                                        child: Text(
                                                          "등록동기",
                                                          style: TextStyle(
                                                            color: Color(CtTheme.black_color),
                                                            fontSize: CtTheme.small_font_size,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: SizedBox(
                                                          height: double.infinity,
                                                          child: TextField(
                                                            controller: enr_motiv_textfield,
                                                            style: TextStyle(
                                                              color: Color(CtTheme.black_color),
                                                              fontSize: CtTheme.small_font_size,
                                                            ),
                                                            keyboardType: TextInputType.multiline,
                                                            maxLines: null,
                                                            decoration: InputDecoration.collapsed(
                                                              hintText: responseEditingMode("등록동기"),
                                                              hintStyle: TextStyle(
                                                                color: Color(CtTheme.dark_gray_color),
                                                                fontSize: CtTheme.small_font_size,
                                                              ),
                                                            ),
                                                            enabled: is_editing_mode,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Divider(),
                                                Container(
                                                  height: 200.0,
                                                  child: Row(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: 80.0,
                                                        height: double.infinity,
                                                        child: Text(
                                                          "신앙생활",
                                                          style: TextStyle(
                                                            color: Color(CtTheme.black_color),
                                                            fontSize: CtTheme.small_font_size,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: SizedBox(
                                                          height: double.infinity,
                                                          child: TextField(
                                                            controller: follow_life_textfield,
                                                            style: TextStyle(
                                                              color: Color(CtTheme.black_color),
                                                              fontSize: CtTheme.small_font_size,
                                                            ),
                                                            keyboardType: TextInputType.multiline,
                                                            maxLines: null,
                                                            decoration: InputDecoration.collapsed(
                                                              hintText: responseEditingMode("신앙생활"),
                                                              hintStyle: TextStyle(
                                                                color: Color(CtTheme.dark_gray_color),
                                                                fontSize: CtTheme.small_font_size,
                                                              ),
                                                            ),
                                                            enabled: is_editing_mode,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Divider(),
                                                Container(
                                                  height: 200.0,
                                                  child: Row(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: 80.0,
                                                        height: double.infinity,
                                                        child: Text(
                                                          "자녀관련",
                                                          style: TextStyle(
                                                            color: Color(CtTheme.black_color),
                                                            fontSize: CtTheme.small_font_size,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: SizedBox(
                                                          height: double.infinity,
                                                          child: TextField(
                                                            controller: child_related_textfield,
                                                            style: TextStyle(
                                                              color: Color(CtTheme.black_color),
                                                              fontSize: CtTheme.small_font_size,
                                                            ),
                                                            keyboardType: TextInputType.multiline,
                                                            maxLines: null,
                                                            decoration: InputDecoration.collapsed(
                                                              hintText: responseEditingMode("자녀관련"),
                                                              hintStyle: TextStyle(
                                                                color: Color(CtTheme.dark_gray_color),
                                                                fontSize: CtTheme.small_font_size,
                                                              ),
                                                            ),
                                                            enabled: is_editing_mode,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Divider(),
                                                Container(
                                                  height: 200.0,
                                                  child: Row(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: 80.0,
                                                        height: double.infinity,
                                                        child: Text(
                                                          "가정생활",
                                                          style: TextStyle(
                                                            color: Color(CtTheme.black_color),
                                                            fontSize: CtTheme.small_font_size,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: SizedBox(
                                                          height: double.infinity,
                                                          child: TextField(
                                                            controller: home_life_textfield,
                                                            style: TextStyle(
                                                              color: Color(CtTheme.black_color),
                                                              fontSize: CtTheme.small_font_size,
                                                            ),
                                                            keyboardType: TextInputType.multiline,
                                                            maxLines: null,
                                                            decoration: InputDecoration.collapsed(
                                                              hintText: responseEditingMode("가정생활"),
                                                              hintStyle: TextStyle(
                                                                color: Color(CtTheme.dark_gray_color),
                                                                fontSize: CtTheme.small_font_size,
                                                              ),
                                                            ),
                                                            enabled: is_editing_mode,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Divider(),
                                                Container(
                                                  height: 200.0,
                                                  child: Row(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: 80.0,
                                                        height: double.infinity,
                                                        child: Text(
                                                          "직장관련",
                                                          style: TextStyle(
                                                            color: Color(CtTheme.black_color),
                                                            fontSize: CtTheme.small_font_size,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: SizedBox(
                                                          height: double.infinity,
                                                          child: TextField(
                                                            controller: job_related_textfield,
                                                            style: TextStyle(
                                                              color: Color(CtTheme.black_color),
                                                              fontSize: CtTheme.small_font_size,
                                                            ),
                                                            keyboardType: TextInputType.multiline,
                                                            maxLines: null,
                                                            decoration: InputDecoration.collapsed(
                                                              hintText: responseEditingMode("직장관련"),
                                                              hintStyle: TextStyle(
                                                                color: Color(CtTheme.dark_gray_color),
                                                                fontSize: CtTheme.small_font_size,
                                                              ),
                                                            ),
                                                            enabled: is_editing_mode,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Divider(),
                                                Container(
                                                  height: 200.0,
                                                  child: Row(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: 80.0,
                                                        height: double.infinity,
                                                        child: Text(
                                                          "기도제목",
                                                          style: TextStyle(
                                                            color: Color(CtTheme.black_color),
                                                            fontSize: CtTheme.small_font_size,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: SizedBox(
                                                          height: double.infinity,
                                                          child: TextField(
                                                            controller: pray_list_textfield,
                                                            style: TextStyle(
                                                              color: Color(CtTheme.black_color),
                                                              fontSize: CtTheme.small_font_size,
                                                            ),
                                                            keyboardType: TextInputType.multiline,
                                                            maxLines: null,
                                                            decoration: InputDecoration.collapsed(
                                                              hintText: responseEditingMode("기도제목"),
                                                              hintStyle: TextStyle(
                                                                color: Color(CtTheme.dark_gray_color),
                                                                fontSize: CtTheme.small_font_size,
                                                              ),
                                                            ),
                                                            enabled: is_editing_mode,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Divider(),
                                                Container(
                                                  height: 200.0,
                                                  child: Row(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: 80.0,
                                                        height: double.infinity,
                                                        child: Text(
                                                          "기타의견",
                                                          style: TextStyle(
                                                            color: Color(CtTheme.black_color),
                                                            fontSize: CtTheme.small_font_size,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: SizedBox(
                                                          height: double.infinity,
                                                          child: TextField(
                                                            controller: other_opinion_textfield,
                                                            style: TextStyle(
                                                              color: Color(CtTheme.black_color),
                                                              fontSize: CtTheme.small_font_size,
                                                            ),
                                                            keyboardType: TextInputType.multiline,
                                                            maxLines: null,
                                                            decoration: InputDecoration.collapsed(
                                                              hintText: responseEditingMode("기타의견"),
                                                              hintStyle: TextStyle(
                                                                color: Color(CtTheme.dark_gray_color),
                                                                fontSize: CtTheme.small_font_size,
                                                              ),
                                                            ),
                                                            enabled: is_editing_mode,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                else{
                                  return SizedBox();
                                }
                              },
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
                                  if(_snapshot.data!["is_manager"]){
                                    return Container(
                                      child: SizedBox(
                                        width: double.infinity,
                                        height: 50.0,
                                        child: ElevatedButton(
                                          child: Text(
                                            "삭제",
                                            style: TextStyle(
                                              color: Color(CtTheme.white_color),
                                              fontSize: CtTheme.small_font_size,
                                            ),
                                          ),
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(CtTheme.small_radius),
                                                )),
                                          ),
                                          onPressed: () async{
                                            bool is_delete = false;

                                            await showDialog<String>(
                                                context: context,
                                                builder: (context) => AlertDialog(
                                                  title: Text("알림"),
                                                  content: Text("정말로 삭제하시겠습니까?\n해당 새가족의 모든 데이터가 삭제 됩니다"),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () => Navigator.pop(context),
                                                      child: Text("아니요"),
                                                    ),
                                                    TextButton(
                                                      onPressed: () async{
                                                        EasyLoading.show(status: "삭제 중...");

                                                        if(data["enr_card_file_url"] != ""){
                                                          await FirebaseStorage.instance
                                                              .ref(data["enr_card_file_url"])
                                                              .delete();
                                                        }
                                                        if(data["new_comer_img_file_url"] != ""){
                                                          await FirebaseStorage.instance
                                                              .ref(data["new_comer_img_file_url"])
                                                              .delete();
                                                        }

                                                        await firestoreInstance
                                                            .collection("new_comers")
                                                            .doc(data["id"])
                                                            .delete();

                                                        is_delete = true;

                                                        EasyLoading.dismiss();

                                                        Navigator.pop(context);
                                                      },
                                                      child: Text("예"),
                                                    ),
                                                  ],
                                                )
                                            );

                                            if(is_delete){
                                              Navigator.pop(context);
                                            }
                                          },
                                        ),
                                      ),
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            else{
              return Scaffold(
                body: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(
                        color: Color(CtTheme.black_color),
                      ),
                      SizedBox(height: CtTheme.small_padding,),
                      Text(
                        "배치 중...",
                        style: TextStyle(
                          color: Color(CtTheme.black_color),
                          fontSize: CtTheme.small_font_size,
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> showBottomSheetOfEnrType() async{
    EnrType temp_enr_type = enr_type;

    await showModalBottomSheet(
        context: context,
        builder: (context){
          return StatefulBuilder(
            builder: (context, setState){
              return Container(
                child: Padding(
                  padding: EdgeInsets.all(CtTheme.middle_padding),
                  child: Column(
                    children: [
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Radio<EnrType>(
                                    value: EnrType.single,
                                    groupValue: temp_enr_type,
                                    onChanged: (EnrType? value) {
                                      setState(() {
                                        temp_enr_type = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    calEnrTypeToDisplayText(EnrType.single)!,
                                    style: TextStyle(
                                      color: Color(CtTheme.black_color),
                                      fontSize: CtTheme.small_font_size,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: CtTheme.small_padding,),
                              Row(
                                children: <Widget>[
                                  Radio<EnrType>(
                                    value: EnrType.couple,
                                    groupValue: temp_enr_type,
                                    onChanged: (EnrType? value) {
                                      setState(() {
                                        temp_enr_type = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    calEnrTypeToDisplayText(EnrType.couple)!,
                                    style: TextStyle(
                                      color: Color(CtTheme.black_color),
                                      fontSize: CtTheme.small_font_size,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: CtTheme.small_padding,),
                              Row(
                                children: <Widget>[
                                  Radio<EnrType>(
                                    value: EnrType.family,
                                    groupValue: temp_enr_type,
                                    onChanged: (EnrType? value) {
                                      setState(() {
                                        temp_enr_type = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    calEnrTypeToDisplayText(EnrType.family)!,
                                    style: TextStyle(
                                      color: Color(CtTheme.black_color),
                                      fontSize: CtTheme.small_font_size,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: <Widget>[
                                  Radio<EnrType>(
                                    value: EnrType.none,
                                    groupValue: temp_enr_type,
                                    onChanged: (EnrType? value) {
                                      setState(() {
                                        temp_enr_type = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    '선택하지 않음',
                                    style: TextStyle(
                                      color: Color(CtTheme.black_color),
                                      fontSize: CtTheme.small_font_size,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Spacer(),
                      SizedBox(
                        width: double.infinity,
                        height: 50.0,
                        child: ElevatedButton(
                          child: Text(
                            "확인",
                            style: TextStyle(
                              color: Color(CtTheme.white_color),
                              fontSize: CtTheme.small_font_size,
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Color(CtTheme.black_color)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(CtTheme.small_radius),
                                )),
                          ),
                          onPressed: () {
                            enr_type = temp_enr_type;
                            if(enr_type == EnrType.single){
                              enr_type_display_text = calEnrTypeToDisplayText(EnrType.single)!;
                            }
                            else if(enr_type == EnrType.couple){
                              enr_type_display_text = calEnrTypeToDisplayText(EnrType.couple)!;
                            }
                            else if(enr_type == EnrType.family){
                              enr_type_display_text = calEnrTypeToDisplayText(EnrType.family)!;
                            }
                            else if(enr_type == EnrType.none){
                              enr_type_display_text = calEnrTypeToDisplayText(EnrType.none)!;
                            }

                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
    );
  }

  Future<void> showBottomSheetOfSex() async{
    Sex temp_sex = sex;

    await showModalBottomSheet(
        context: context,
        builder: (context){
          return StatefulBuilder(
            builder: (context, setState){
              return Container(
                child: Padding(
                  padding: EdgeInsets.all(CtTheme.middle_padding),
                  child: Column(
                    children: [
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Radio<Sex>(
                                    value: Sex.male,
                                    groupValue: temp_sex,
                                    onChanged: (Sex? value) {
                                      setState(() {
                                        temp_sex = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    calSexToDisplayText(Sex.male)!,
                                    style: TextStyle(
                                      color: Color(CtTheme.black_color),
                                      fontSize: CtTheme.small_font_size,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: CtTheme.small_padding,),
                              Row(
                                children: <Widget>[
                                  Radio<Sex>(
                                    value: Sex.female,
                                    groupValue: temp_sex,
                                    onChanged: (Sex? value) {
                                      setState(() {
                                        temp_sex = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    calSexToDisplayText(Sex.female)!,
                                    style: TextStyle(
                                      color: Color(CtTheme.black_color),
                                      fontSize: CtTheme.small_font_size,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: <Widget>[
                                  Radio<Sex>(
                                    value: Sex.none,
                                    groupValue: temp_sex,
                                    onChanged: (Sex? value) {
                                      setState(() {
                                        temp_sex = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    '선택하지 않음',
                                    style: TextStyle(
                                      color: Color(CtTheme.black_color),
                                      fontSize: CtTheme.small_font_size,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Spacer(),
                      SizedBox(
                        width: double.infinity,
                        height: 50.0,
                        child: ElevatedButton(
                          child: Text(
                            "확인",
                            style: TextStyle(
                              color: Color(CtTheme.white_color),
                              fontSize: CtTheme.small_font_size,
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Color(CtTheme.black_color)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(CtTheme.small_radius),
                                )),
                          ),
                          onPressed: () {
                            sex = temp_sex;
                            if(sex == Sex.male){
                              sex_display_text = calSexToDisplayText(Sex.male)!;
                            }
                            else if(sex == Sex.female){
                              sex_display_text = calSexToDisplayText(Sex.female)!;
                            }
                            else if(sex == Sex.none){
                              sex_display_text = calSexToDisplayText(Sex.none)!;
                            }

                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
    );
  }

  Future<void> showBottomSheetOfSunMoon() async{
    SunMoon temp_sun_moon = sun_moon;

    await showModalBottomSheet(
        context: context,
        builder: (context){
          return StatefulBuilder(
            builder: (context, setState){
              return Container(
                child: Padding(
                  padding: EdgeInsets.all(CtTheme.middle_padding),
                  child: Column(
                    children: [
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Radio<SunMoon>(
                                    value: SunMoon.sun,
                                    groupValue: temp_sun_moon,
                                    onChanged: (SunMoon? value) {
                                      setState(() {
                                        temp_sun_moon = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    calSunMoonToDisplayText(SunMoon.sun)!,
                                    style: TextStyle(
                                      color: Color(CtTheme.black_color),
                                      fontSize: CtTheme.small_font_size,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: CtTheme.small_padding,),
                              Row(
                                children: <Widget>[
                                  Radio<SunMoon>(
                                    value: SunMoon.moon,
                                    groupValue: temp_sun_moon,
                                    onChanged: (SunMoon? value) {
                                      setState(() {
                                        temp_sun_moon = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    calSunMoonToDisplayText(SunMoon.moon)!,
                                    style: TextStyle(
                                      color: Color(CtTheme.black_color),
                                      fontSize: CtTheme.small_font_size,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: <Widget>[
                                  Radio<SunMoon>(
                                    value: SunMoon.none,
                                    groupValue: temp_sun_moon,
                                    onChanged: (SunMoon? value) {
                                      setState(() {
                                        temp_sun_moon = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    '선택하지 않음',
                                    style: TextStyle(
                                      color: Color(CtTheme.black_color),
                                      fontSize: CtTheme.small_font_size,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Spacer(),
                      SizedBox(
                        width: double.infinity,
                        height: 50.0,
                        child: ElevatedButton(
                          child: Text(
                            "확인",
                            style: TextStyle(
                              color: Color(CtTheme.white_color),
                              fontSize: CtTheme.small_font_size,
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Color(CtTheme.black_color)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(CtTheme.small_radius),
                                )),
                          ),
                          onPressed: () {
                            sun_moon = temp_sun_moon;
                            if(sun_moon == SunMoon.sun){
                              sun_moon_display_text = calSunMoonToDisplayText(SunMoon.sun)!;
                            }
                            else if(sun_moon == SunMoon.moon){
                              sun_moon_display_text = calSunMoonToDisplayText(SunMoon.moon)!;
                            }
                            else if(sun_moon == SunMoon.none){
                              sun_moon_display_text = calSunMoonToDisplayText(SunMoon.none)!;
                            }

                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
    );
  }

  Future<void> showBottomSheetOfDivision() async{
    Division temp_division = division;

    await showModalBottomSheet(
        context: context,
        builder: (context){
          return StatefulBuilder(
            builder: (context, setState){
              return Container(
                child: Padding(
                  padding: EdgeInsets.all(CtTheme.middle_padding),
                  child: Column(
                    children: [
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Radio<Division>(
                                    value: Division.young,
                                    groupValue: temp_division,
                                    onChanged: (Division? value) {
                                      setState(() {
                                        temp_division = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    calDivisionToDisplayText(Division.young)!,
                                    style: TextStyle(
                                      color: Color(CtTheme.black_color),
                                      fontSize: CtTheme.small_font_size,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: CtTheme.small_padding,),
                              Row(
                                children: <Widget>[
                                  Radio<Division>(
                                    value: Division.old,
                                    groupValue: temp_division,
                                    onChanged: (Division? value) {
                                      setState(() {
                                        temp_division = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    calDivisionToDisplayText(Division.old)!,
                                    style: TextStyle(
                                      color: Color(CtTheme.black_color),
                                      fontSize: CtTheme.small_font_size,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: <Widget>[
                                  Radio<Division>(
                                    value: Division.none,
                                    groupValue: temp_division,
                                    onChanged: (Division? value) {
                                      setState(() {
                                        temp_division = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    '선택하지 않음',
                                    style: TextStyle(
                                      color: Color(CtTheme.black_color),
                                      fontSize: CtTheme.small_font_size,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Spacer(),
                      SizedBox(
                        width: double.infinity,
                        height: 50.0,
                        child: ElevatedButton(
                          child: Text(
                            "확인",
                            style: TextStyle(
                              color: Color(CtTheme.white_color),
                              fontSize: CtTheme.small_font_size,
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Color(CtTheme.black_color)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(CtTheme.small_radius),
                                )),
                          ),
                          onPressed: () {
                            division = temp_division;
                            if(division == Division.young){
                              division_display_text = calDivisionToDisplayText(Division.young)!;
                            }
                            else if(division == Division.old){
                              division_display_text = calDivisionToDisplayText(Division.old)!;
                            }
                            else if(division == Division.none){
                              division_display_text = calDivisionToDisplayText(Division.none)!;
                            }

                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
    );
  }

  Future<void> showBottomSheetOfIsMarry() async{
    IsMarry temp_is_marry = is_marry;

    await showModalBottomSheet(
        context: context,
        builder: (context){
          return StatefulBuilder(
            builder: (context, setState){
              return Container(
                child: Padding(
                  padding: EdgeInsets.all(CtTheme.middle_padding),
                  child: Column(
                    children: [
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Radio<IsMarry>(
                                    value: IsMarry.no,
                                    groupValue: temp_is_marry,
                                    onChanged: (IsMarry? value) {
                                      setState(() {
                                        temp_is_marry = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    calIsMarryToDisplayText(IsMarry.no)!,
                                    style: TextStyle(
                                      color: Color(CtTheme.black_color),
                                      fontSize: CtTheme.small_font_size,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: CtTheme.small_padding,),
                              Row(
                                children: <Widget>[
                                  Radio<IsMarry>(
                                    value: IsMarry.yes,
                                    groupValue: temp_is_marry,
                                    onChanged: (IsMarry? value) {
                                      setState(() {
                                        temp_is_marry = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    calIsMarryToDisplayText(IsMarry.yes)!,
                                    style: TextStyle(
                                      color: Color(CtTheme.black_color),
                                      fontSize: CtTheme.small_font_size,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: <Widget>[
                                  Radio<IsMarry>(
                                    value: IsMarry.none,
                                    groupValue: temp_is_marry,
                                    onChanged: (IsMarry? value) {
                                      setState(() {
                                        temp_is_marry = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    '선택하지 않음',
                                    style: TextStyle(
                                      color: Color(CtTheme.black_color),
                                      fontSize: CtTheme.small_font_size,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Spacer(),
                      SizedBox(
                        width: double.infinity,
                        height: 50.0,
                        child: ElevatedButton(
                          child: Text(
                            "확인",
                            style: TextStyle(
                              color: Color(CtTheme.white_color),
                              fontSize: CtTheme.small_font_size,
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Color(CtTheme.black_color)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(CtTheme.small_radius),
                                )),
                          ),
                          onPressed: () {
                            is_marry = temp_is_marry;
                            if(is_marry == IsMarry.yes){
                              is_marry_display_text = calIsMarryToDisplayText(IsMarry.yes)!;
                            }
                            else if(is_marry == IsMarry.no){
                              is_marry_display_text = calIsMarryToDisplayText(IsMarry.no)!;
                            }
                            else if(is_marry == IsMarry.none){
                              is_marry_display_text = calIsMarryToDisplayText(IsMarry.none)!;
                            }

                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
    );
  }

  Future<void> showBottomSheetOfSchool() async{
    School temp_school = school;

    await showModalBottomSheet(
        context: context,
        builder: (context){
          return StatefulBuilder(
            builder: (context, setState){
              return Container(
                child: Padding(
                  padding: EdgeInsets.all(CtTheme.middle_padding),
                  child: Column(
                    children: [
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Radio<School>(
                                    value: School.element,
                                    groupValue: temp_school,
                                    onChanged: (School? value) {
                                      setState(() {
                                        temp_school = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    calSchoolToDisplayText(School.element)!,
                                    style: TextStyle(
                                      color: Color(CtTheme.black_color),
                                      fontSize: CtTheme.small_font_size,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: CtTheme.small_padding,),
                              Row(
                                children: <Widget>[
                                  Radio<School>(
                                    value: School.middle,
                                    groupValue: temp_school,
                                    onChanged: (School? value) {
                                      setState(() {
                                        temp_school = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    calSchoolToDisplayText(School.middle)!,
                                    style: TextStyle(
                                      color: Color(CtTheme.black_color),
                                      fontSize: CtTheme.small_font_size,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: CtTheme.small_padding,),
                              Row(
                                children: <Widget>[
                                  Radio<School>(
                                    value: School.high,
                                    groupValue: temp_school,
                                    onChanged: (School? value) {
                                      setState(() {
                                        temp_school = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    calSchoolToDisplayText(School.high)!,
                                    style: TextStyle(
                                      color: Color(CtTheme.black_color),
                                      fontSize: CtTheme.small_font_size,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: <Widget>[
                                  Radio<School>(
                                    value: School.college,
                                    groupValue: temp_school,
                                    onChanged: (School? value) {
                                      setState(() {
                                        temp_school = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    calSchoolToDisplayText(School.college)!,
                                    style: TextStyle(
                                      color: Color(CtTheme.black_color),
                                      fontSize: CtTheme.small_font_size,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: CtTheme.small_padding,),
                              Row(
                                children: <Widget>[
                                  Radio<School>(
                                    value: School.university,
                                    groupValue: temp_school,
                                    onChanged: (School? value) {
                                      setState(() {
                                        temp_school = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    calSchoolToDisplayText(School.university)!,
                                    style: TextStyle(
                                      color: Color(CtTheme.black_color),
                                      fontSize: CtTheme.small_font_size,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: CtTheme.small_padding,),
                              Row(
                                children: <Widget>[
                                  Radio<School>(
                                    value: School.master,
                                    groupValue: temp_school,
                                    onChanged: (School? value) {
                                      setState(() {
                                        temp_school = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    calSchoolToDisplayText(School.master)!,
                                    style: TextStyle(
                                      color: Color(CtTheme.black_color),
                                      fontSize: CtTheme.small_font_size,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Radio<School>(
                                    value: School.docter,
                                    groupValue: temp_school,
                                    onChanged: (School? value) {
                                      setState(() {
                                        temp_school = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    calSchoolToDisplayText(School.docter)!,
                                    style: TextStyle(
                                      color: Color(CtTheme.black_color),
                                      fontSize: CtTheme.small_font_size,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: CtTheme.small_padding,),
                              Row(
                                children: <Widget>[
                                  Radio<School>(
                                    value: School.none,
                                    groupValue: temp_school,
                                    onChanged: (School? value) {
                                      setState(() {
                                        temp_school = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    "선택하지 않음",
                                    style: TextStyle(
                                      color: Color(CtTheme.black_color),
                                      fontSize: CtTheme.small_font_size,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                      Spacer(),
                      SizedBox(
                        width: double.infinity,
                        height: 50.0,
                        child: ElevatedButton(
                          child: Text(
                            "확인",
                            style: TextStyle(
                              color: Color(CtTheme.white_color),
                              fontSize: CtTheme.small_font_size,
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Color(CtTheme.black_color)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(CtTheme.small_radius),
                                )),
                          ),
                          onPressed: () {
                            school = temp_school;
                            if(school == School.element){
                              school_display_text = calSchoolToDisplayText(School.element)!;
                            }
                            else if(school == School.middle){
                              school_display_text = calSchoolToDisplayText(School.middle)!;
                            }
                            else if(school == School.high){
                              school_display_text = calSchoolToDisplayText(School.high)!;
                            }
                            else if(school == School.college){
                              school_display_text = calSchoolToDisplayText(School.college)!;
                            }
                            else if(school == School.university){
                              school_display_text = calSchoolToDisplayText(School.university)!;
                            }
                            else if(school == School.master){
                              school_display_text = calSchoolToDisplayText(School.master)!;
                            }
                            else if(school == School.docter){
                              school_display_text = calSchoolToDisplayText(School.docter)!;
                            }
                            else if(school == School.none){
                              school_display_text = calSchoolToDisplayText(School.none)!;
                            }

                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
    );
  }

  Future<void> showBottomSheetOfBapLevel() async{
    BapLevel temp_bap_level = bap_level;

    await showModalBottomSheet(
        context: context,
        builder: (context){
          return StatefulBuilder(
            builder: (context, setState){
              return Container(
                child: Padding(
                  padding: EdgeInsets.all(CtTheme.middle_padding),
                  child: Column(
                    children: [
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Radio<BapLevel>(
                                    value: BapLevel.baby,
                                    groupValue: temp_bap_level,
                                    onChanged: (BapLevel? value) {
                                      setState(() {
                                        temp_bap_level = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    calBapLevelToDisplayText(BapLevel.baby)!,
                                    style: TextStyle(
                                      color: Color(CtTheme.black_color),
                                      fontSize: CtTheme.small_font_size,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: CtTheme.small_padding,),
                              Row(
                                children: <Widget>[
                                  Radio<BapLevel>(
                                    value: BapLevel.study,
                                    groupValue: temp_bap_level,
                                    onChanged: (BapLevel? value) {
                                      setState(() {
                                        temp_bap_level = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    calBapLevelToDisplayText(BapLevel.study)!,
                                    style: TextStyle(
                                      color: Color(CtTheme.black_color),
                                      fontSize: CtTheme.small_font_size,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: CtTheme.small_padding,),
                              Row(
                                children: <Widget>[
                                  Radio<BapLevel>(
                                    value: BapLevel.enter,
                                    groupValue: temp_bap_level,
                                    onChanged: (BapLevel? value) {
                                      setState(() {
                                        temp_bap_level = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    calBapLevelToDisplayText(BapLevel.enter)!,
                                    style: TextStyle(
                                      color: Color(CtTheme.black_color),
                                      fontSize: CtTheme.small_font_size,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: <Widget>[
                                  Radio<BapLevel>(
                                    value: BapLevel.bap,
                                    groupValue: temp_bap_level,
                                    onChanged: (BapLevel? value) {
                                      setState(() {
                                        temp_bap_level = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    calBapLevelToDisplayText(BapLevel.bap)!,
                                    style: TextStyle(
                                      color: Color(CtTheme.black_color),
                                      fontSize: CtTheme.small_font_size,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: CtTheme.small_padding,),
                              Row(
                                children: <Widget>[
                                  Radio<BapLevel>(
                                    value: BapLevel.nothing,
                                    groupValue: temp_bap_level,
                                    onChanged: (BapLevel? value) {
                                      setState(() {
                                        temp_bap_level = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    calBapLevelToDisplayText(BapLevel.nothing)!,
                                    style: TextStyle(
                                      color: Color(CtTheme.black_color),
                                      fontSize: CtTheme.small_font_size,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Radio<BapLevel>(
                                    value: BapLevel.none,
                                    groupValue: temp_bap_level,
                                    onChanged: (BapLevel? value) {
                                      setState(() {
                                        temp_bap_level = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    '선택하지 않음',
                                    style: TextStyle(
                                      color: Color(CtTheme.black_color),
                                      fontSize: CtTheme.small_font_size,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                      Spacer(),
                      SizedBox(
                        width: double.infinity,
                        height: 50.0,
                        child: ElevatedButton(
                          child: Text(
                            "확인",
                            style: TextStyle(
                              color: Color(CtTheme.white_color),
                              fontSize: CtTheme.small_font_size,
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Color(CtTheme.black_color)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(CtTheme.small_radius),
                                )),
                          ),
                          onPressed: () {
                            bap_level = temp_bap_level;
                            if(bap_level == BapLevel.baby){
                              bap_level_display_text = calBapLevelToDisplayText(BapLevel.baby)!;
                            }
                            else if(bap_level == BapLevel.study){
                              bap_level_display_text = calBapLevelToDisplayText(BapLevel.study)!;
                            }
                            else if(bap_level == BapLevel.enter){
                              bap_level_display_text = calBapLevelToDisplayText(BapLevel.enter)!;
                            }
                            else if(bap_level == BapLevel.bap){
                              bap_level_display_text = calBapLevelToDisplayText(BapLevel.bap)!;
                            }
                            else if(bap_level == BapLevel.nothing){
                              bap_level_display_text = calBapLevelToDisplayText(BapLevel.nothing)!;
                            }
                            else if(bap_level == BapLevel.none){
                              bap_level_display_text = calBapLevelToDisplayText(BapLevel.none)!;
                            }

                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
    );
  }

  Future<void> showBottomSheetOfRole() async{
    Role temp_role = role;

    await showModalBottomSheet(
        context: context,
        builder: (context){
          return StatefulBuilder(
            builder: (context, setState){
              return Container(
                child: Padding(
                  padding: EdgeInsets.all(CtTheme.middle_padding),
                  child: Column(
                    children: [
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Radio<Role>(
                                    value: Role.beginner,
                                    groupValue: temp_role,
                                    onChanged: (Role? value) {
                                      setState(() {
                                        temp_role = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    calRoleToDisplayText(Role.beginner)!,
                                    style: TextStyle(
                                      color: Color(CtTheme.black_color),
                                      fontSize: CtTheme.small_font_size,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: CtTheme.small_padding,),
                              Row(
                                children: <Widget>[
                                  Radio<Role>(
                                    value: Role.believer,
                                    groupValue: temp_role,
                                    onChanged: (Role? value) {
                                      setState(() {
                                        temp_role = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    calRoleToDisplayText(Role.believer)!,
                                    style: TextStyle(
                                      color: Color(CtTheme.black_color),
                                      fontSize: CtTheme.small_font_size,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: CtTheme.small_padding,),
                              Row(
                                children: <Widget>[
                                  Radio<Role>(
                                    value: Role.servant,
                                    groupValue: temp_role,
                                    onChanged: (Role? value) {
                                      setState(() {
                                        temp_role = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    calRoleToDisplayText(Role.servant)!,
                                    style: TextStyle(
                                      color: Color(CtTheme.black_color),
                                      fontSize: CtTheme.small_font_size,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: <Widget>[
                                  Radio<Role>(
                                    value: Role.senior,
                                    groupValue: temp_role,
                                    onChanged: (Role? value) {
                                      setState(() {
                                        temp_role = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    calRoleToDisplayText(Role.senior)!,
                                    style: TextStyle(
                                      color: Color(CtTheme.black_color),
                                      fontSize: CtTheme.small_font_size,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: CtTheme.small_padding,),
                              Row(
                                children: <Widget>[
                                  Radio<Role>(
                                    value: Role.formal_servant,
                                    groupValue: temp_role,
                                    onChanged: (Role? value) {
                                      setState(() {
                                        temp_role = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    calRoleToDisplayText(Role.formal_servant)!,
                                    style: TextStyle(
                                      color: Color(CtTheme.black_color),
                                      fontSize: CtTheme.small_font_size,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: CtTheme.small_padding,),
                              Row(
                                children: <Widget>[
                                  Radio<Role>(
                                    value: Role.elder,
                                    groupValue: temp_role,
                                    onChanged: (Role? value) {
                                      setState(() {
                                        temp_role = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    calRoleToDisplayText(Role.elder)!,
                                    style: TextStyle(
                                      color: Color(CtTheme.black_color),
                                      fontSize: CtTheme.small_font_size,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Radio<Role>(
                                    value: Role.assistant,
                                    groupValue: temp_role,
                                    onChanged: (Role? value) {
                                      setState(() {
                                        temp_role = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    calRoleToDisplayText(Role.assistant)!,
                                    style: TextStyle(
                                      color: Color(CtTheme.black_color),
                                      fontSize: CtTheme.small_font_size,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: CtTheme.small_padding,),
                              Row(
                                children: <Widget>[
                                  Radio<Role>(
                                    value: Role.probation,
                                    groupValue: temp_role,
                                    onChanged: (Role? value) {
                                      setState(() {
                                        temp_role = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    calRoleToDisplayText(Role.probation)!,
                                    style: TextStyle(
                                      color: Color(CtTheme.black_color),
                                      fontSize: CtTheme.small_font_size,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: CtTheme.small_padding,),
                              Row(
                                children: <Widget>[
                                  Radio<Role>(
                                    value: Role.assi_pastor,
                                    groupValue: temp_role,
                                    onChanged: (Role? value) {
                                      setState(() {
                                        temp_role = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    calRoleToDisplayText(Role.assi_pastor)!,
                                    style: TextStyle(
                                      color: Color(CtTheme.black_color),
                                      fontSize: CtTheme.small_font_size,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Radio<Role>(
                                    value: Role.pastor,
                                    groupValue: temp_role,
                                    onChanged: (Role? value) {
                                      setState(() {
                                        temp_role = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    calRoleToDisplayText(Role.pastor)!,
                                    style: TextStyle(
                                      color: Color(CtTheme.black_color),
                                      fontSize: CtTheme.small_font_size,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: CtTheme.small_padding,),
                              Row(
                                children: <Widget>[
                                  Radio<Role>(
                                    value: Role.old_pastor,
                                    groupValue: temp_role,
                                    onChanged: (Role? value) {
                                      setState(() {
                                        temp_role = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    calRoleToDisplayText(Role.old_pastor)!,
                                    style: TextStyle(
                                      color: Color(CtTheme.black_color),
                                      fontSize: CtTheme.small_font_size,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Radio<Role>(
                                    value: Role.none,
                                    groupValue: temp_role,
                                    onChanged: (Role? value) {
                                      setState(() {
                                        temp_role = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    '선택하지 않음',
                                    style: TextStyle(
                                      color: Color(CtTheme.black_color),
                                      fontSize: CtTheme.small_font_size,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Spacer(),
                      SizedBox(
                        width: double.infinity,
                        height: 50.0,
                        child: ElevatedButton(
                          child: Text(
                            "확인",
                            style: TextStyle(
                              color: Color(CtTheme.white_color),
                              fontSize: CtTheme.small_font_size,
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Color(CtTheme.black_color)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(CtTheme.small_radius),
                                )),
                          ),
                          onPressed: () {
                            role = temp_role;
                            if(role == Role.beginner){
                              role_display_text = calRoleToDisplayText(Role.beginner)!;
                            }
                            else if(role == Role.believer){
                              role_display_text = calRoleToDisplayText(Role.believer)!;
                            }
                            else if(role == Role.servant){
                              role_display_text = calRoleToDisplayText(Role.servant)!;
                            }
                            else if(role == Role.senior){
                              role_display_text = calRoleToDisplayText(Role.senior)!;
                            }
                            else if(role == Role.formal_servant){
                              role_display_text = calRoleToDisplayText(Role.formal_servant)!;
                            }
                            else if(role == Role.elder){
                              role_display_text = calRoleToDisplayText(Role.elder)!;
                            }
                            else if(role == Role.assistant){
                              role_display_text = calRoleToDisplayText(Role.assistant)!;
                            }
                            else if(role == Role.probation){
                              role_display_text = calRoleToDisplayText(Role.probation)!;
                            }
                            else if(role == Role.assi_pastor){
                              role_display_text = calRoleToDisplayText(Role.assi_pastor)!;
                            }
                            else if(role == Role.pastor){
                              role_display_text = calRoleToDisplayText(Role.pastor)!;
                            }
                            else if(role == Role.old_pastor){
                              role_display_text = calRoleToDisplayText(Role.old_pastor)!;
                            }
                            else if(role == Role.none){
                              role_display_text = calRoleToDisplayText(Role.none)!;
                            }

                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
    );
  }

  Future<void> showBottomSheetOfManageState() async{
    ManageState temp_manage_state = manage_state;

    await showModalBottomSheet(
        context: context,
        builder: (context){
          return StatefulBuilder(
            builder: (context, setState){
              return Container(
                child: Padding(
                  padding: EdgeInsets.all(CtTheme.middle_padding),
                  child: Column(
                    children: [
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Radio<ManageState>(
                                    value: ManageState.cancel,
                                    groupValue: temp_manage_state,
                                    onChanged: (ManageState? value) {
                                      setState(() {
                                        temp_manage_state = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    calManageStateToDisplayText(ManageState.cancel)!,
                                    style: TextStyle(
                                      color: Color(CtTheme.black_color),
                                      fontSize: CtTheme.small_font_size,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: CtTheme.small_padding,),
                              Row(
                                children: <Widget>[
                                  Radio<ManageState>(
                                    value: ManageState.manage,
                                    groupValue: temp_manage_state,
                                    onChanged: (ManageState? value) {
                                      setState(() {
                                        temp_manage_state = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    calManageStateToDisplayText(ManageState.manage)!,
                                    style: TextStyle(
                                      color: Color(CtTheme.black_color),
                                      fontSize: CtTheme.small_font_size,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: <Widget>[
                                  Radio<ManageState>(
                                    value: ManageState.none,
                                    groupValue: temp_manage_state,
                                    onChanged: (ManageState? value) {
                                      setState(() {
                                        temp_manage_state = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    '선택하지 않음',
                                    style: TextStyle(
                                      color: Color(CtTheme.black_color),
                                      fontSize: CtTheme.small_font_size,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Spacer(),
                      SizedBox(
                        width: double.infinity,
                        height: 50.0,
                        child: ElevatedButton(
                          child: Text(
                            "확인",
                            style: TextStyle(
                              color: Color(CtTheme.white_color),
                              fontSize: CtTheme.small_font_size,
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Color(CtTheme.black_color)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(CtTheme.small_radius),
                                )),
                          ),
                          onPressed: () {
                            manage_state = temp_manage_state;
                            if(manage_state == ManageState.cancel){
                              manage_state_display_text = calManageStateToDisplayText(ManageState.cancel)!;
                            }
                            else if(manage_state == ManageState.manage){
                              manage_state_display_text = calManageStateToDisplayText(ManageState.manage)!;
                            }
                            else if(manage_state == ManageState.none){
                              manage_state_display_text = calManageStateToDisplayText(ManageState.none)!;
                            }

                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
    );
  }

  Future<void> showBottomSheetOfIsCeremony() async{
    IsCeremony temp_is_ceremony = is_ceremony;

    await showModalBottomSheet(
        context: context,
        builder: (context){
          return StatefulBuilder(
            builder: (context, setState){
              return Container(
                child: Padding(
                  padding: EdgeInsets.all(CtTheme.middle_padding),
                  child: Column(
                    children: [
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Radio<IsCeremony>(
                                    value: IsCeremony.no,
                                    groupValue: temp_is_ceremony,
                                    onChanged: (IsCeremony? value) {
                                      setState(() {
                                        temp_is_ceremony = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    calIsCeremonyToDisplayText(IsCeremony.no)!,
                                    style: TextStyle(
                                      color: Color(CtTheme.black_color),
                                      fontSize: CtTheme.small_font_size,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: CtTheme.small_padding,),
                              Row(
                                children: <Widget>[
                                  Radio<IsCeremony>(
                                    value: IsCeremony.yes,
                                    groupValue: temp_is_ceremony,
                                    onChanged: (IsCeremony? value) {
                                      setState(() {
                                        temp_is_ceremony = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    calIsCeremonyToDisplayText(IsCeremony.yes)!,
                                    style: TextStyle(
                                      color: Color(CtTheme.black_color),
                                      fontSize: CtTheme.small_font_size,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: <Widget>[
                                  Radio<IsCeremony>(
                                    value: IsCeremony.none,
                                    groupValue: temp_is_ceremony,
                                    onChanged: (IsCeremony? value) {
                                      setState(() {
                                        temp_is_ceremony = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    '선택하지 않음',
                                    style: TextStyle(
                                      color: Color(CtTheme.black_color),
                                      fontSize: CtTheme.small_font_size,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Spacer(),
                      SizedBox(
                        width: double.infinity,
                        height: 50.0,
                        child: ElevatedButton(
                          child: Text(
                            "확인",
                            style: TextStyle(
                              color: Color(CtTheme.white_color),
                              fontSize: CtTheme.small_font_size,
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Color(CtTheme.black_color)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(CtTheme.small_radius),
                                )),
                          ),
                          onPressed: () {
                            is_ceremony = temp_is_ceremony;
                            if(is_ceremony == IsCeremony.yes){
                              is_ceremony_display_text = calIsCeremonyToDisplayText(IsCeremony.yes)!;
                            }
                            else if(is_ceremony == IsCeremony.no){
                              is_ceremony_display_text = calIsCeremonyToDisplayText(IsCeremony.no)!;
                            }
                            else if(is_ceremony == IsCeremony.none){
                              is_ceremony_display_text = calIsCeremonyToDisplayText(IsCeremony.none)!;
                            }

                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
    );
  }

  bool validateNumber(String value) {
    // String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(r'^[+-]?([0-9]+([.][0-9]*)?|[.][0-9]+)$');
    if (value.length == 0) {
      return false;
    } else if (!regExp.hasMatch(value)) {
      return false;
    }
    return true;
  }

  DateTime calStringToDateTime(String value){
    int year = int.parse(value.substring(0, 4));
    int month = int.parse(value.substring(4, 6));
    int day = int.parse(value.substring(6, 8));

    return DateTime(year, month, day);
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

  bool isValidDate(String value) {
    final date = DateTime.parse(value);
    final originalFormatString = toOriginalFormatString(date);
    return value == originalFormatString;
  }

  String toOriginalFormatString(DateTime date_time) {
    final y = date_time.year.toString().padLeft(4, '0');
    final m = date_time.month.toString().padLeft(2, '0');
    final d = date_time.day.toString().padLeft(2, '0');
    return "$y$m$d";
  }

  String responseEditingMode(String value){
    if(is_editing_mode){
      return value;
    }
    else{
      return "";
    }
  }
}