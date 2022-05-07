import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:path/path.dart';

import 'package:flutter/rendering.dart';

final File file = File("/Users/k.aoshima/FlutterProject/NextStationSearch/next_station_search/lib/csv/routeInfo.txt");

class RouteInfo{
  List<String> abbreviation = [];
  List<String> routeName = [];
  List<String> csvFileName = [];
  List<Color> routeColor = [];

  Future getCsvData() async{

    file.openRead()
        .transform(Utf8Decoder())
        .transform(const LineSplitter())
        .forEach((line){

          List rows = line.split(',');

          abbreviation.add(rows[0]);
          routeName.add(rows[1]);
          csvFileName.add(rows[2]);
          routeColor.add(HexColor(rows[3]));
    });

    return Future.delayed(const Duration(milliseconds: 1500));
  }
}


class HexColor extends Color {
 static int _getColorFromHex(String hexColor) {
   hexColor = hexColor.toUpperCase().replaceAll('#', '');
   if (hexColor.length == 6) {
     hexColor = 'FF' + hexColor;
   }
   return int.parse(hexColor, radix: 16);
 }

 HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}