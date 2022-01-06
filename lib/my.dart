import 'package:flutter/material.dart';

var tiny_db;

class CtTheme {
  static int primary_color = 0xFFEA8205;
  static int light_gray_color = 0xFFE9ECEF;
  static int dark_gray_color = 0xFFadb5bd;
  static int black_color = 0xFF212529;
  static int white_color = 0xFFFFFFFF;

  static double small_radius = 6.0;
  static double middle_radius = 12.0;

  static double small_padding = 10.0;
  static double middle_padding = 20.0;

  static double small_font_size = 17.0;
  static double middle_font_size = 24.0;
  static double big_font_size = 36.0;
}

enum EnrType { single, couple, family, none }
enum Sex { male, female, none }
enum SunMoon { sun, moon, none }

enum Division { young, old, none }
enum IsMarry { yes, no, none }
enum School { element, middle, high, college, university, master, docter, none }
enum BapLevel { baby, study, enter, bap, nothing, none }
enum Role { beginner, believer, servant, senior, formal_servant, elder, assistant, probation, assi_pastor, pastor, old_pastor, none }

enum EduLevel { before, now, after, none }

enum ManageState { cancel, manage, none }
enum IsCeremony { yes, no, none }

enum AttendWorshipType { on, off, no, none }

String? calEnrTypeToDisplayText(var value) {
  if(value == EnrType.single){ return "개인"; }
  else if(value == EnrType.couple){ return "부부"; }
  else if(value == EnrType.family){ return "가족"; }
  else if(value == EnrType.none){ return ""; }
}

String? calSexToDisplayText(var value) {
  if(value == Sex.male){ return "남자"; }
  else if(value == Sex.female){ return "여자"; }
  else if(value == Sex.none){ return ""; }
}

String? calSunMoonToDisplayText(var value) {
  if(value == SunMoon.sun){ return "양력"; }
  else if(value == SunMoon.moon){ return "음력"; }
  else if(value == SunMoon.none){ return ""; }
}

String? calDivisionToDisplayText(var value) {
  if(value == Division.young){ return "청년"; }
  else if(value == Division.old){ return "장년"; }
  else if(value == Division.none){ return ""; }
}

String? calIsMarryToDisplayText(var value) {
  if(value == IsMarry.yes){ return "기혼"; }
  else if(value == IsMarry.no){ return "미혼"; }
  else if(value == IsMarry.none){ return ""; }
}

String? calSchoolToDisplayText(var value) {
  if(value == School.element){ return "초졸"; }
  else if(value == School.middle){ return "중졸"; }
  else if(value == School.high){ return "고졸"; }
  else if(value == School.college){ return "전문대"; }
  else if(value == School.university){ return "대학원"; }
  else if(value == School.master){ return "석사"; }
  else if(value == School.docter){ return "박사"; }
  else if(value == School.none){ return ""; }
}

String? calBapLevelToDisplayText(var value) {
  if(value == BapLevel.baby){ return "유아세례"; }
  else if(value == BapLevel.study){ return "학습"; }
  else if(value == BapLevel.enter){ return "입교"; }
  else if(value == BapLevel.bap){ return "세례"; }
  else if(value == BapLevel.nothing){ return "없음"; }
  else if(value == BapLevel.none){ return ""; }
}

String? calRoleToDisplayText(var value) {
  if(value == Role.beginner){ return "처음"; }
  else if(value == Role.believer){ return "성도"; }
  else if(value == Role.servant){ return "집사"; }
  else if(value == Role.senior){ return "권사"; }
  else if(value == Role.formal_servant){ return "안수집사"; }
  else if(value == Role.elder){ return "장로"; }
  else if(value == Role.assistant){ return "전도사"; }
  else if(value == Role.probation){ return "강도사"; }
  else if(value == Role.assi_pastor){ return "부목사"; }
  else if(value == Role.pastor){ return "목사"; }
  else if(value == Role.old_pastor){ return "원로목사"; }
  else if(value == Role.none){ return ""; }
}

String? calEduLevelToDisplayText(var value) {
  if(value == EduLevel.before){ return "교육 전"; }
  else if(value == EduLevel.now){ return "진행 중"; }
  else if(value == EduLevel.after){ return "완료"; }
  else if(value == EduLevel.none){ return ""; }
}

String? calManageStateToDisplayText(var value) {
  if(value == ManageState.cancel){ return "해제"; }
  else if(value == ManageState.manage){ return "관리"; }
  else if(value == ManageState.none){ return ""; }
}

String? calIsCeremonyToDisplayText(var value) {
  if(value == IsCeremony.yes){ return "완료"; }
  else if(value == IsCeremony.no){ return "예정"; }
  else if(value == IsCeremony.none){ return ""; }
}

String? calAttendWorshipTypeToDisplayText(var value) {
  if(value == AttendWorshipType.on){ return "온라인"; }
  else if(value == AttendWorshipType.off){ return "대면"; }
  else if(value == AttendWorshipType.no){ return "미출석"; }
  else if(value == AttendWorshipType.none){ return ""; }
}

dynamic calStringToEnum(String value){
  String string_value = value.toString();
  for(int i = 0; i < EnrType.values.length; i++){
    if(string_value == EnrType.values[i].toString()){
      return EnrType.values[i];
    }
  }

  for(int i = 0; i < Sex.values.length; i++){
    if(string_value == Sex.values[i].toString()){
      return Sex.values[i];
    }
  }

  for(int i = 0; i < SunMoon.values.length; i++){
    if(string_value == SunMoon.values[i].toString()){
      return SunMoon.values[i];
    }
  }

  for(int i = 0; i < Division.values.length; i++){
    if(string_value == Division.values[i].toString()){
      return Division.values[i];
    }
  }

  for(int i = 0; i < IsMarry.values.length; i++){
    if(string_value == IsMarry.values[i].toString()){
      return IsMarry.values[i];
    }
  }

  for(int i = 0; i < School.values.length; i++){
    if(string_value == School.values[i].toString()){
      return School.values[i];
    }
  }

  for(int i = 0; i < BapLevel.values.length; i++){
    if(string_value == BapLevel.values[i].toString()){
      return BapLevel.values[i];
    }
  }

  for(int i = 0; i < Role.values.length; i++){
    if(string_value == Role.values[i].toString()){
      return Role.values[i];
    }
  }

  for(int i = 0; i < EduLevel.values.length; i++){
    if(string_value == EduLevel.values[i].toString()){
      return EduLevel.values[i];
    }
  }

  for(int i = 0; i < ManageState.values.length; i++){
    if(string_value == ManageState.values[i].toString()){
      return ManageState.values[i];
    }
  }

  for(int i = 0; i < IsCeremony.values.length; i++){
    if(string_value == IsCeremony.values[i].toString()){
      return IsCeremony.values[i];
    }
  }

  for(int i = 0; i < AttendWorshipType.values.length; i++){
    if(string_value == AttendWorshipType.values[i].toString()){
      return AttendWorshipType.values[i];
    }
  }
}

bool validateEnglishString(String value) {
  String patttern = r'(^[a-zA-Z ]*$)';
  RegExp regExp = new RegExp(patttern);
  if (value.length == 0) {
    return false;
  } else if (!regExp.hasMatch(value)) {
    return false;
  }
  return true;
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

bool validateTukString(String value) {
  return value.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
}

dynamic returnLoadingPage(){
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
            "생각 중...",
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

dynamic returnErrorPage(){
  return Scaffold(
    backgroundColor: Color(CtTheme.white_color),
    body: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.error,
            color: Color(CtTheme.black_color),
          ),
          Text(
            ":(",
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

Map calListToMap(List data){
  var return_data = { for (Map v in data) v.keys.toList()[0]: v.values.toList()[0] };

  return return_data;
}