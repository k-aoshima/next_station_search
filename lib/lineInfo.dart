import 'dart:io';
import 'dart:async';
import 'dart:convert';


class LineInfo{

  List<String> lineNo = [];
  List<String> stationName = [];
  List<String> latitude = [];
  List<String> longitude = [];


  Future getCsvData(String fileName) async{

    File file = File("/Users/k.aoshima/FlutterProject/NextStationSearch/next_station_search/lib/csv/" + fileName);

    file.openRead()
      .transform(Utf8Decoder())
      .transform(const LineSplitter())
      .forEach((line){

        List rows = line.split(',');
        lineNo.add(rows[0]);
        stationName.add(rows[1]);
        latitude.add(rows[2]);
        longitude.add(rows[3]);
    });

    return Future.delayed(const Duration(seconds: 1));

  }
  
  
}