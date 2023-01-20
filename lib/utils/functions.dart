import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

const pageSize = 30;

listPaginator({required RxList rangeList, required RxList selectList}) {
  if (rangeList.length < selectList.length) {
    if (selectList.length <= pageSize) {
      rangeList.addAll(selectList.getRange(0, selectList.length));
    } else {
      rangeList.addAll(selectList.getRange(0, pageSize));
    }
  }
}

listAppender({required RxList rangeList, required RxList selectList}) {
  if (rangeList.length < selectList.length) {
    if (selectList.length <= rangeList.length + pageSize) {
      rangeList
          .addAll(selectList.getRange(rangeList.length, selectList.length));
    } else {
      rangeList.addAll(
          selectList.getRange(rangeList.length, rangeList.length + pageSize));
    }
  }
}

List<String> searchParser(String tillString) {
  List<String> parsed = [];
  List<String> listHolder = [];
  String stringHolder = '';

  if (tillString.contains('-')) {
    listHolder = tillString.split('-');
    stringHolder = listHolder.reduce((value, element) => '$value, $element');
    stringHolder = stringHolder.replaceAll(RegExp(r'[^\w\s\-]+'), '');
  } else if (tillString.contains('.')) {
    stringHolder = tillString.replaceAll(RegExp(r'[^\w\s\-]+'), '');
  } else {
    stringHolder = tillString;
  }
  stringHolder = stringHolder.toLowerCase();
  parsed = stringHolder.split(' ');
  return parsed;
}

Map<String, String> apiHeaders = {'Content-type': 'application/json'};

Future<String?> get getBranch async {
  var prefs = await SharedPreferences.getInstance();
  var branch = prefs.getString('branchId');
  if (branch != null) {
    return branch;
  }
  return branch;
}

get headers {
  return {"Content-Type": "application/json"};
}
