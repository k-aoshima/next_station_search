import 'package:shared_preferences/shared_preferences.dart';

const String selectedRoute = "selectedRoute";
const String selectedLoopTime = "selectedLoppTime";
var settings = SetingData();

class SetingData{
  int selectedRoute = 0;
  int selectedLoopTime = 0;
}

Future<void> getSettingData() async {
	SharedPreferences prefs = await SharedPreferences.getInstance();
	int route = prefs.getInt(selectedRoute ) ?? 0;
  settings.selectedRoute = route;

  int loop = prefs.getInt(selectedLoopTime ) ?? 0;
  settings.selectedLoopTime = loop;
	return Future.delayed(const Duration(milliseconds: 500));
}

void setSelectedRoute(int value) async { 
	final SharedPreferences prefs = await SharedPreferences.getInstance();
	await prefs.setInt(selectedRoute, value);
}

void setSelectedLoopTime(int value) async { 
	final SharedPreferences prefs = await SharedPreferences.getInstance();
	await prefs.setInt(selectedLoopTime, value);
}

