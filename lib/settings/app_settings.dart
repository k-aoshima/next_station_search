import 'package:flutter/material.dart';
import 'package:next_station_search/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _SELECTED_ROUTE = "selectedRoute";
const String _SELECTED_LOOP_TIME = "selectedLoppTime";
var Settings = new SetingData();

class SetingData{
  int selectedRoute = 0;
  int selectedLoopTime = 0;
}

Future<void> GetSettingData() async {
	SharedPreferences prefs = await SharedPreferences.getInstance();
	int route = prefs.getInt(_SELECTED_ROUTE ) ?? 0;
  Settings.selectedRoute = route;

  int loop = prefs.getInt(_SELECTED_LOOP_TIME ) ?? 0;
  Settings.selectedLoopTime = loop;
	return Future.delayed(const Duration(milliseconds: 500));
}

void SetSelectedRoute(int value) async { 
	final SharedPreferences prefs = await SharedPreferences.getInstance();
	await prefs.setInt(_SELECTED_ROUTE, value);
}

void SetSelectedLoopTime(int value) async { 
	final SharedPreferences prefs = await SharedPreferences.getInstance();
	await prefs.setInt(_SELECTED_LOOP_TIME, value);
}

