import 'dart:async';
import 'package:flutter/services.dart';


class LineInfo{

  List<String> lineNo = [];
  List<String> stationName = [];
  List<String> latitude = [];
  List<String> longitude = [];

  Future getCsvData(String fileName) async{

    String csv = await rootBundle.loadString('assets/' + fileName);

    for(String line in csv.split('\n')){
      List rows = line.split(',');
      lineNo.add(rows[0]);
      stationName.add(rows[1]);
      latitude.add(rows[2]);
      longitude.add(rows[3]);
    }
    return Future.delayed(const Duration(seconds: 1));
  }
}