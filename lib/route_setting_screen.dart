import 'package:flutter/material.dart';
import 'settings/routeInfo.dart';

class RouteSettingScreen extends StatefulWidget{
  
  final RouteInfo routeInfo;
  RouteSettingScreen(this.routeInfo);

  @override
  _RouteSettingScreenState createState()=> _RouteSettingScreenState(this.routeInfo);
}

class _RouteSettingScreenState extends State<RouteSettingScreen>{

  final RouteInfo routeInfo;
  var _selectedIndex = 0;

  _RouteSettingScreenState(this.routeInfo);

  @override
  Widget build(BuildContext context){
    
    return Scaffold(
      appBar: AppBar(
        title: 
        const Text(
          '路線設定',
          style: TextStyle(
          fontFamily: "BIZUDPGothic"
        )),
        backgroundColor: Color.fromARGB(180, 18, 16, 16),
      ),
      body: ListView(
        children: [
          for(var i = 0; i < routeInfo.routeName.length; i++)
            RadioListTile(
              value: i,
              groupValue: _selectedIndex,
              title: Text(routeInfo.routeName[i]),
              onChanged: (value) => _onRadioSelected(value),
            ),
        ],
      )
    );
    
  }

  _onRadioSelected(value) 
  {
    setState(() {
      _selectedIndex = value;
    });
  }
}