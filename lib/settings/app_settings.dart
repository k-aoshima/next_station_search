import 'package:flutter/material.dart';
import 'package:next_station_search/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _SELECTED_LINE = "selectedLine";


Future<int> GetSelectedLine() async {
	SharedPreferences prefs = await SharedPreferences.getInstance();
	int ret = prefs.getInt(_SELECTED_LINE ) ?? 0;
  Future.delayed(const Duration(milliseconds: 500));
	return ret;
}

void SetSelectedLine(int value) async { 
	final SharedPreferences prefs = await SharedPreferences.getInstance();
	await prefs.setInt(_SELECTED_LINE, value);
}