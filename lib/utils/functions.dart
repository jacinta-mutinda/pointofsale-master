import 'package:get/get.dart';

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
